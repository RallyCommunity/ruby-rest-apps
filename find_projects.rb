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



rally = RallyAPI::RallyRestJson.new(config)

query = RallyAPI::RallyQuery.new()
query.fetch = "Name,Owner"
query.type = :project   



results = rally.find(query)

results.each do |p|
	p.read
	puts "opened project: #{p["Name"]} owner: #{p["Owner"]["_refObjectName"]}"
end