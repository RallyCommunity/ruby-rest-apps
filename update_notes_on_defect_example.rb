require 'rally_api'

#Setup custom app information
headers = RallyAPI::CustomHttpHeader.new()
headers.name = "update Notes"
headers.vendor = "Nick M RallyLab"
headers.version = "1.0"

# Connection to Rally
config = {:base_url => "https://rally1.rallydev.com/slm"}
config[:api_key] = "_abc123"
config[:workspace] = "W1"
config[:project] = "P1"
config[:version] = "v2.0"
config[:headers] = headers #from RallyAPI::CustomHttpHeader.new()

rally = RallyAPI::RallyRestJson.new(config)


query = RallyAPI::RallyQuery.new()
query.type = :defect
query.fetch = "Name,FormattedID,Notes"
query.workspace = {"_ref" => "https://rally1.rallydev.com/slm/webservice/v2.0/workspace/12352608129" }
query.query_string = "(FormattedID = DE3)"

results = rally.find(query)

defect = results.first
puts "Defect #{defect["FormattedID"]} Notes before update: #{defect["Notes"]}"

field_updates = {"Notes" => "done and done"}
defect.update(field_updates)
puts "Defect #{defect["FormattedID"]} Notes after update: #{defect["Notes"]}"

	

	


