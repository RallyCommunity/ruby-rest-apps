 # WARNING :
 # THIS CODE WILL BULK DELETE STORIES.
 # MAKE SURE TO VERIFY THAT ONLY STORIES INTENDED FOR DELITION ARE BEING DELETED
 # stop_after variable currently set to 1 will stop the execution of the program after one story is deleted
 # THE DELETED STORIES CAN BE FOUND IN THE RECYCLE BIN, IN YOUR RALLY WORKSPACE
 

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
query.type = :story
query.fetch = "Name,FormattedID,Tags"
query.workspace = {"_ref" => "https://rally1.rallydev.com/slm/webservice/v2.0/workspace/11111" } #use valid workspace oid
query.project = {"_ref" => "https://rally1.rallydev.com/slm/webservice/v2.0/project/22222" } #use valid project oid
query.page_size = 200 #optional - default is 200
query.limit = 100 #optional - default is 99999
query.project_scope_up = false
query.project_scope_down = true
query.order = "Name Asc"
query.query_string = "(Tags.Name = \"tag-abc123defd4567\")" # replace this query with whatever query is valid in your scenario

results = @rally.find(query)
stories_to_delete = [];

stop_after = 1      # WARNING : keep this number low until you verify that only intended stories are being deleted     
count = 0

results.each do |s|
	 count +=1
         break if count > stop_after
	puts "Name: #{s["Name"]}, FormattedID: #{s["FormattedID"]}}"
	s.read
	stories_to_delete << s
end

stories_to_delete.each do |story|
	puts "deleting Name: #{story["Name"]}, FormattedID: #{story["FormattedID"]}"
	story.delete
end

	
