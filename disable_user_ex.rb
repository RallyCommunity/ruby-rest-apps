require 'rally_api'


#Setup custom app information
headers = RallyAPI::CustomHttpHeader.new()
headers.name = "Create image attachment, add inline to the description"
headers.vendor = "Nick M RallyLab"
headers.version = "1.0"

# Connection to Rally
config = {:base_url => "https://rally1.rallydev.com/slm"}
config[:api_key] = "_abc123
config[:workspace] = "NMDS" 
config[:project] = "Company X"
config[:headers] = headers #from RallyAPI::CustomHttpHeader.new() 
config[:version] = "v2.0"

@rally = RallyAPI::RallyRestJson.new(config)


#find user by username
query = RallyAPI::RallyQuery.new()
query.type = "user"
query.fetch = "Disabled"
query.query_string = "(UserName = \"nicktemp2@wsapi.com\")"

result = @rally.find(query)
user = result.first

#check if the user is currently enabled
puts "Is #{user} currently disabled? #{user["Disabled"]}"

#if the user is currently enabled, disable the user
if !user["Disabled"]
  field_updates = {"Disabled" => true}
  user.update(field_updates)
  puts "Is #{user} now disabled? #{user["Disabled"]}"
end
