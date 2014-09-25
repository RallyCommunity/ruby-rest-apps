require 'rally_api'
require 'date'


#Setup custom app information
headers = RallyAPI::CustomHttpHeader.new()
headers.name = "My Utility"
headers.vendor = "Nick M RallyLab"
headers.version = "1.0"

# Connection to Rally
config = {:base_url => "https://rally1.rallydev.com/slm"}
config[:api_key] = "_abc123"
config[:workspace] = "W"
config[:project] = "P"
config[:headers] = headers #from RallyAPI::CustomHttpHeader.new()
config[:version] = "v2.0"


rally = RallyAPI::RallyRestJson.new(config)


query = RallyAPI::RallyQuery.new()
query.type = :attachment
query.workspace = {"_ref" => "https://rally1.rallydev.com/slm/webservice/v2.0/workspace/12345" }
query.fetch = "Artifact,FormattedID,LastUpdateDate,CreationDate,Size,User"
query.query_string = "(Size > 10000)"

results = rally.find(query)
#get attachments above 10000
results.each do |a|
	puts "ref: #{a["_ref"]}, \n Size: #{a["Size"]}, Artifact: #{a["Artifact"]["FormattedID"]}"
	a.read
end
