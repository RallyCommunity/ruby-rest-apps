require 'rally_api'


#Setup custom app information
headers = RallyAPI::CustomHttpHeader.new()
headers.name = "get milestone data"
headers.vendor = "Nick M RallyLab"
headers.version = "1.0"

# Connection to Rally
config = {:base_url => "https://rally1.rallydev.com/slm"}
config[:api_key] = "_abc123"
config[:headers] = headers #from RallyAPI::CustomHttpHeader.new() 
config[:version] = "v2.0"

@rally = RallyAPI::RallyRestJson.new(config)


#find changesets that meet criteria
query = RallyAPI::RallyQuery.new()
query.type = "milestone"
query.fetch = "Name,TargetDate"
query.query_string = "(TargetDate > 2015-01-01)"

results = @rally.find(query)
results.each do |m|
  puts "Name: #{m["Name"]}, Target Date: #{m["TargetDate"]}"
  m["Projects"].each do |p|
    puts "Project Name: #{p["Name"]}"
  end
end