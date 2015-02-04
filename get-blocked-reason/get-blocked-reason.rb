require 'rally_api'


#Setup custom app information
headers = RallyAPI::CustomHttpHeader.new()
headers.name = "get blocked reason"
headers.vendor = "Nick M RallyLab"
headers.version = "1.0"

# Connection to Rally
config = {:base_url => "https://rally1.rallydev.com/slm"}
config[:api_key] = "_abc123"
config[:headers] = headers #from RallyAPI::CustomHttpHeader.new() 
config[:version] = "v2.0"

@rally = RallyAPI::RallyRestJson.new(config)


#find milestones that meet criteria
query = RallyAPI::RallyQuery.new()
query.type = "story"
query.fetch = "Name,FormattedID,Blocked,BlockedReason"
query.query_string = "(Blocked = true)"

results = @rally.find(query)
results.each do |s|
  puts "Name: #{s["Name"]}, FormattedID: #{s["FormattedID"]}, Blocked: #{s["Blocked"]}"
  if s["BlockedReason"] != nil then
    puts "Blocked Reason: #{s["BlockedReason"]}"
  end  
end