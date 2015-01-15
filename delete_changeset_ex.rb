# WARNING: THIS SCRIPT DELETES DATA, RUN IT AT YOUR OWN RISK
# MAKE SURE THAT YOUR QUERY RETURNS CHANGESETS YOU WANT TO DELETE
# THE SCRIPT IS FOR DEMO PURPOSES ONLY AND IS NOT SUPPORTED BY RALLY

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


#find changesets that meet criteria
query = RallyAPI::RallyQuery.new()
query.type = "changeset"
query.fetch = "ObjectID,Message"
query.query_string = "(Message contains \"DE4\")"

results = @rally.find(query)
changesets_to_delete = [];
results.each do |c|
  puts "ObjectID: #{c["ObjectID"]}, Message: #{c["Message"]}"
  c.read
  changesets_to_delete << c
end

#delete changesets
changesets_to_delete.each do |c|
  puts "deleting... #{c["_ref"]}"
  c.delete
end