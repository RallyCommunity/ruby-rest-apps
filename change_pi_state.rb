require 'rally_api'


#Setup custom app information
headers = RallyAPI::CustomHttpHeader.new()
headers.name = "change state of feature"
headers.vendor = "Nick M RallyLab"
headers.version = "1.0"

# Connection to Rally
config = {:base_url => "https://rally1.rallydev.com/slm"}
config[:username] = "user@co.com"
config[:password] = "secret"
config[:workspace] = "W1"
config[:project] = "P1"
config[:headers] = headers #from RallyAPI::CustomHttpHeader.new()
config[:version] = "v2.0"

@rally = RallyAPI::RallyRestJson.new(config)

queryState = RallyAPI::RallyQuery.new()
queryState.type = :state
queryState.fetch = "true"
queryState.workspace = {"_ref" => "https://rally1.rallydev.com/slm/webservice/v2.0/workspace/1111" } 
queryState.project = {"_ref" => "https://rally1.rallydev.com/slm/webservice/v2.0/project/2222" } #Company X
queryState.page_size = 200 #optional - default is 200
queryState.limit = 1000 #optional - default is 99999
queryState.project_scope_up = false
queryState.project_scope_down = true
queryState.order = "Name Asc"
queryState.query_string = "(TypeDef.Name = \"Feature\")"

state_hash = Hash.new

state_results = @rally.find(queryState)

state_results.each do |s|
	s.read
	#puts "Ref: #{s["_ref"]}, Name: #{s["Name"] }, TypeDef: #{s["TypeDef"]}" 
	state_hash[s["Name"]] = s["_ref"]
end	

query = RallyAPI::RallyQuery.new()
query.type = "portfolioitem/feature"
query.fetch = "Name,FormattedID"
query.workspace = {"_ref" => "https://rally1.rallydev.com/slm/webservice/v2.0/workspace/1111" } 
query.project = {"_ref" => "https://rally1.rallydev.com/slm/webservice/v2.0/project/2222" } #Company X
query.page_size = 200 #optional - default is 200
query.limit = 1000 #optional - default is 99999
query.project_scope_up = false
query.project_scope_down = true
query.order = "Name Asc"
query.query_string = "(Name = \"A Feature One\")"


results = @rally.find(query)
features = [];
stop_after = 10
count = 0

results.each do |f|
	 count +=1
         break if count > stop_after
	 f.read
	 puts "Current state of Feature #{f["FormattedID"]}: #{f["State"].to_s}"
	
	features << f
end


features.each do |f|
	#field_updates = {"State" => "/state/12352608623"}
	field_updates={"State" => state_hash["Developing"]}
	f.update(field_updates)
	puts "Feature #{f["FormattedID"]} is now in State: #{f["State"].to_s}"
end
