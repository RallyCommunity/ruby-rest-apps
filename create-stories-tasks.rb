require 'rally_api'


#Setup custom app information
headers = RallyAPI::CustomHttpHeader.new()
headers.name = "Create stories and tasks"
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

loop = 10

while loop > 0 do
  #create story
  story_payload = {}
  story_payload["Name"] = "my story #{DateTime.now()}"
  story = @rally.create("userstory", story_payload)
  fid = story["FormattedID"]
  puts story["FormattedID"]
  
  #find story
  query = RallyAPI::RallyQuery.new()
  query.type = :userstory
  query.fetch = "Name,FormattedID"
  query.query_string = "(FormattedID = #{fid})"
  
  results = @rally.find(query)
  story_ref = results.first["_ref"]
  
  #create tasks
  
  for i in 1..3
    task_payload = {}
    task_payload["Name"] = "my task #{i} #{DateTime.now()}"
    task_payload["WorkProduct"] = {"_ref" => story_ref}
    task = @rally.create("Task", task_payload)
    puts task["FormattedID"]
  end
  loop -= 1
end