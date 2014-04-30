require 'rally_api'


#Setup custom app information
headers = RallyAPI::CustomHttpHeader.new()
headers.name = "My Utility: change state of feature"
headers.vendor = "Nick M RallyLab"
headers.version = "1.0"

# Connection to Rally
config = {:base_url => "https://rally1.rallydev.com/slm"}
config[:username] = "user@co.com"
config[:password] = "secret"
config[:workspace] = "W"
config[:project] = "P"
config[:headers] = headers 
config[:version] = "v2.0"

@rally = RallyAPI::RallyRestJson.new(config)

workspace_ref = {"_ref" => "https://rally1.rallydev.com/slm/webservice/v2.0/workspace/1111" } 
project_ref = {"_ref" => "https://rally1.rallydev.com/slm/webservice/v2.0/project/2222" } 

queryState = RallyAPI::RallyQuery.new()
queryState.type = :state
queryState.fetch = "true"
queryState.workspace = workspace_ref
queryState.project = project_ref
queryState.project_scope_up = false
queryState.project_scope_down = false
queryState.order = "Name Asc"
queryState.query_string = "(TypeDef.Name = \"Feature\")"

state_hash = Hash.new

state_results = @rally.find(queryState)

state_results.each do |s|
	s.read
	state_hash[s["Name"]] = s["_ref"]
end	

query = RallyAPI::RallyQuery.new()
query.type = "portfolioitem/feature"
query.fetch = "Name,FormattedID"
query.workspace = workspace_ref 
query.project = project_ref
query.project_scope_up = false
query.project_scope_down = false
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
	field_updates={"State" => state_hash["Developing"]}
	f.update(field_updates)
	puts "Feature #{f["FormattedID"]} is now in State: #{f["State"].to_s}"
end
