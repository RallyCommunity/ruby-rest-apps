require 'rally_api'


#Setup custom app information
headers = RallyAPI::CustomHttpHeader.new()
headers.name = "My Utility"
headers.vendor = "Nick M RallyLab"
headers.version = "1.0"

# Connection to Rally
config = {:base_url => "https://rally1.rallydev.com/slm"}
config[:api_key] = "_abc123" 
config[:workspace] = "W1" 
config[:project] = "P1"
config[:headers] = headers #from RallyAPI::CustomHttpHeader.new()
config[:version] = "v2.0"

@rally = RallyAPI::RallyRestJson.new(config)

query = RallyAPI::RallyQuery.new()
query.type = :task
query.fetch = "Name,FormattedID,Owner"
query.order = "Name Asc"
query.query_string = "(LastUpdateDate > 2015-03-10)"

owner = {"_ref" => "https://rally1.rallydev.com/slm/webservice/v2.0/user/777" } 

task_results = @rally.find(query)
some_tasks = [];
stop_after = 2
count = 0
puts "found these tasks:"
task_results.each do |t|
	 count +=1
         break if count > stop_after
	 puts "FormattedID: #{t["FormattedID"]}"
	 t.read
	 some_tasks << t
end

some_tasks.each do |t|
	puts "updating... #{t["FormattedID"]}"
	#field_updates = {"Description" => "Changed Description"}
	field_updates = {"Owner" => owner}
	t.update(field_updates)
end