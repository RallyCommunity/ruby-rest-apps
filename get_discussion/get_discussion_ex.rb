require 'rally_api'


#Setup custom app information
headers = RallyAPI::CustomHttpHeader.new()
headers.name = "Create image attachment, add inline to the description"
headers.vendor = "Nick M RallyLab"
headers.version = "1.0"

# Connection to Rally
config = {:base_url => "https://rally1.rallydev.com/slm"}
config[:api_key] = "_abc123" 
config[:workspace] = "W" 
config[:project] = "P1"
config[:headers] = headers #from RallyAPI::CustomHttpHeader.new() 
config[:version] = "v2.0"

@rally = RallyAPI::RallyRestJson.new(config)


#find discussion by artifact OID
def get_discussion(oid)
  query = RallyAPI::RallyQuery.new()
  query.type = "conversationpost"
  query.query_string = "(Artifact.ObjectID = \"#{oid}\")"
  query.fetch = "ObjectID,Text,User"
  results = @rally.find(query)
  
  results.each do |post|
  puts "Text: #{post["Text"]}, User: #{post["User"]._refObjectName}"
end
end

#find artifact by OID
oid = "12345"
query = RallyAPI::RallyQuery.new()
query.type = "artifact"
query.fetch = "FormattedID,Name"
query.query_string = "(ObjectID = \"#{oid}\")"

results = @rally.find(query)

if results.length != 0 then
  puts "artifact - FormattedID: #{results.first["FormattedID"]}, Name: #{results.first["Name"]}"
  get_discussion oid
else
  puts "Artifact with this ObjectID is not found"
end


