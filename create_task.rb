require 'rally_api'


#Setup custom app information
headers = RallyAPI::CustomHttpHeader.new()
headers.name = "Create,update task"
headers.vendor = "Nick M RallyLab"
headers.version = "1.0"

# Connection to Rally
config = {:base_url => "https://rally1.rallydev.com/slm"}
config[:api_key] = "_abc123"  
config[:workspace] = "W" 
config[:project] = "P"
config[:headers] = headers #from RallyAPI::CustomHttpHeader.new()
config[:version] = "v2.0"

@rally = RallyAPI::RallyRestJson.new(config)

#find story
query = RallyAPI::RallyQuery.new()
query.type = :userstory
query.fetch = "Name,FormattedID"
query.query_string = "(FormattedID = US24267)"

results = @rally.find(query)
story_ref = results.first["_ref"]

#create task
task_payload = {}
task_payload["Name"] = "my task"
task_payload["WorkProduct"] = {"_ref" => story_ref}
task = @rally.create("Task", task_payload)


#update task
field_updates = {"Estimate"=>3}
task.update(field_updates)