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
config[:workspace] = "W"
config[:project] = "P1"
config[:headers] = headers #from RallyAPI::CustomHttpHeader.new()
config[:version] = "v2.0"

@rally = RallyAPI::RallyRestJson.new(config)

query = RallyAPI::RallyQuery.new()
query.type = :testcase
query.fetch = "Name,FormattedID,Description,WorkProduct"
query.workspace = {"_ref" => "https://rally1.rallydev.com/slm/webservice/v2.0/workspace/11111" } 
query.project = {"_ref" => "https://rally1.rallydev.com/slm/webservice/v2.0/project/222" } 
query.page_size = 200 #optional - default is 200
query.limit = 1000 #optional - default is 99999
query.project_scope_up = false
query.project_scope_down = true
query.order = "Name Asc"
query.query_string = "(Tags.Name = tag1)"

story = {"_ref" => "https://rally1.rallydev.com/slm/webservice/v2.0/hierarchicalrequirement/777" } 

tc_results = @rally.find(query)
some_tc = [];
stop_after = 2
count = 0

tc_results.each do |t|
	 count +=1
         break if count > stop_after
	puts "Name: #{t["Name"]}, FormattedID: #{t["FormattedID"]}"
	t.read
	some_tc << t
end

some_tc.each do |tc|
	puts "acting on Name: #{tc["Name"]}, FormattedID: #{tc["FormattedID"]}"
	#field_updates = {"Description" => "Changed Description"}
	field_updates = {"WorkProduct" => story}
	tc.update(field_updates)
end

	
