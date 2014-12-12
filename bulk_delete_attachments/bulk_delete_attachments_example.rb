require 'rally_api'

#Setup custom app information
headers = RallyAPI::CustomHttpHeader.new()
headers.name = "My Utility"
headers.vendor = "Nick M RallyLab"
headers.version = "1.0"

# Connection to Rally
config = {:base_url => "https://rally1.rallydev.com/slm"}
config[:username] = "user@co.com"
config[:password] = "secret"
config[:workspace] = "W1"
config[:project] = "P1"
config[:version] = "v2.0"
config[:headers] = headers #from RallyAPI::CustomHttpHeader.new()

@rally = RallyAPI::RallyRestJson.new(config)

query = RallyAPI::RallyQuery.new()
query.type = :attachment
query.fetch = "ObjectID,Artifact,FormattedID"
query.workspace = {"_ref" => "https://rally1.rallydev.com/slm/webservice/v2.0/workspace/12352608129" } #use valid workspace oid
query.query_string = "((ObjectID = 26825388592)OR(ObjectID = 26825388739))" # replace this query with whatever query is valid in your scenario

results = @rally.find(query)
attachments_to_delete = [];

results.each do |a|
	puts "ref: #{a["_ref"]}, Artifact: #{a["Artifact"]["FormattedID"]}"
	a.read
	attachments_to_delete << a
end

attachments_to_delete.each do |a|
	puts "deleting ... #{a["_ref"]}"
	a.delete
end

	
