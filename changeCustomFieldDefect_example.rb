require 'rally_api'

#Setup custom app information
headers = RallyAPI::CustomHttpHeader.new()
headers.name = "edit custom field"
headers.vendor = "Nick M RallyLab"
headers.version = "1.0"

# Connection to Rally
config = {:base_url => "https://rally1.rallydev.com/slm"}
config[:username] = "user@co.com"
config[:password] = "secret"
config[:workspace] = "W"
config[:project] = "P"
config[:version] = "v2.0"
config[:headers] = headers #from RallyAPI::CustomHttpHeader.new()

rally = RallyAPI::RallyRestJson.new(config)


query = RallyAPI::RallyQuery.new()
query.type = :defect
query.fetch = "Name,FormattedID,c_MyKB"
query.workspace = {"_ref" => "https://rally1.rallydev.com/slm/webservice/v2.0/workspace/12352608129" }
query.query_string = "(FormattedID = DE3)"

results = rally.find(query)

defect = results.first
puts "Defect #{defect["FormattedID"]} custom field c_MyKB before update: #{defect["c_MyKB"]}"

field_updates = {"c_MyKB" => "done"}
defect.update(field_updates)
puts "Defect #{defect["FormattedID"]} custom field c_MyKB after update: #{defect["c_MyKB"]}"

	

	


