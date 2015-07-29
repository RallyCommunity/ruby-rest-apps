require 'csv'
require 'rally_api'

headers = RallyAPI::CustomHttpHeader.new()
headers.name = "create_projects_from_csv"
headers.vendor = "Nick M RallyLab"
headers.version = "1.0"

config = {:base_url => "https://rally1.rallydev.com/slm"}
config[:api_key] = "_abc123" 
config[:headers] = headers 
config[:version] = "v2.0"
config[:workspace]  = "NM Import - UTC"

@rally = RallyAPI::RallyRestJson.new(config)

def csv_to_hash_array(file_path)
  csv = CSV::parse(File.open(file_path, 'r') {|f| f.read})
  fields = csv.shift 
  csv.collect {|record| Hash[*fields.zip(record).flatten]}
end

a = csv_to_hash_array("projects.csv")

puts a.inspect

def find_project(name,workspace)
  puts "find_project with this criteria #{name}, #{workspace}"
  query = RallyAPI::RallyQuery.new()
  query.type = :project
  query.fetch = "Name,ObjectID"
  query.workspace = {"_ref" => "https://rally1.rallydev.com/slm/webservice/v2.0/workspace/#{workspace}"} 
  query.query_string = "(Name = \"#{name}\")"
  results = @rally.find(query)
  if results.length > 0
    return results.first["_ref"]
  else
    return nil
  end
  
end

def create_project(project_hash)
  project_hash.keys.each do |key|
    project_hash[(key.to_sym rescue key) || key] = project_hash.delete(key)
  end
  puts "create_project with this data #{project_hash}.inspect"
  project_payload = {}
  project_payload["Workspace"] = "/workspace/#{project_hash[:Workspace]}"
  project_payload["Name"] = project_hash[:Name]
  project_payload["State"] = "Open"
  if project_hash[:Parent]
    query_result = find_project(project_hash[:Parent],project_hash[:Workspace])
    if query_result
      project_payload["Parent"] = query_result
    end
  end
  project = @rally.create("project", project_payload)
  puts "Created a project: #{project["Name"]}"
  project["_ref"]
end

a.each do |e|
  create_project(e)
end


