 # WARNING :
 # THIS CODE WILL PERMANENTLY DELETE RECYCLE BIN ENTRIES.
 # MAKE SURE TO VERIFY THAT ONLY ITEMS INTENDED FOR DELITION ARE BEING DELETED
 # THIS CODE IS NOT SUPPORTED BY RALLY
###############start code###########################
require 'rally_api'


#Setup custom app information
headers = RallyAPI::CustomHttpHeader.new()
headers.name = "Create image attachment, add inline to the description"
headers.vendor = "Nick M RallyLab"
headers.version = "1.0"

# Connection to Rally
config = {:base_url => "https://rally1.rallydev.com/slm"}
config[:api_key] = "_abc123" #user your API Key
config[:workspace] = "W1" 
config[:project] = "P1"
config[:headers] = headers #from RallyAPI::CustomHttpHeader.new() 
config[:version] = "v2.0"

@rally = RallyAPI::RallyRestJson.new(config)


#find recyclebinentries that meet criteria
query = RallyAPI::RallyQuery.new()
query.type = "recyclebinentry"
query.fetch = "Name,DeletionDate"
query.query_string = "(DeletionDate < \"2015-01-01\")"

results = @rally.find(query)
items_to_delete = [];
results.each do |i|
  puts "DeletionDate: #{i["DeletionDate"]}, Name: #{i["Name"]}"
  i.read
  items_to_delete << i
end

#delete recyclebinentries
items_to_delete.each do |i|
  puts "deleting... #{i["_ref"]}"
  i.delete
end


################end code###########################