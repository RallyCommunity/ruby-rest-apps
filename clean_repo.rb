###############start code###########################
require 'rally_api'


#Setup custom app information
headers = RallyAPI::CustomHttpHeader.new()
headers.name = "Create image attachment, add inline to the description"
headers.vendor = "Nick M Clean SCMRepo"
headers.version = "1.0"

# Connection to Rally
config = {:base_url => "https://rally1.rallydev.com/slm"}
config[:api_key] = "_abc123" 
config[:workspace] = "W1" 
config[:project] = "Git"
config[:headers] = headers #from RallyAPI::CustomHttpHeader.new() 
config[:version] = "v2.0"

@rally = RallyAPI::RallyRestJson.new(config)

def delete_repo(name)
  query = RallyAPI::RallyQuery.new()
  query.type = "scmrepository"
  query.query_string = "(Name = \"#{name}\")"

  results = @rally.find(query)
  results.first.delete
end


def bulk_delete(object_type)
  query = RallyAPI::RallyQuery.new()
  query.type = object_type
  query.query_string = ""
  results = @rally.find(query)
  results.each do |i|
    i.delete
  end
end

bulk_delete("change")
bulk_delete("changeset")
delete_repo("GitSmokeTest")



