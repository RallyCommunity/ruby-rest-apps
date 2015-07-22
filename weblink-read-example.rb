require 'rally_api'

headers = RallyAPI::CustomHttpHeader.new()
headers.name = "Create stories and tasks"
headers.vendor = "Nick M RallyLab"
headers.version = "1.0"

config = {:base_url => "https://rally1.rallydev.com/slm"}
config[:api_key] = "_abc123"  
config[:workspace] = "W1" 
config[:project] = "Team1"
config[:headers] = headers 
config[:version] = "v2.0"

@rally = RallyAPI::RallyRestJson.new(config)


workspace = "https://rally1.rallydev.com/slm/webservice/v2.0/workspace/123"
project = "https://rally1.rallydev.com/slm/webservice/v2.0/project/456"

query = RallyAPI::RallyQuery.new()
query.type = "defect"
query.fetch = "Name,FormattedID,c_MyWebLink"
query.workspace = {"_ref" => workspace }
query.project = {"_ref" => project }
query.query_string = "(Tags.Name = \"tag1\")"
query.limit = 2 

results = @rally.find(query)

defects_with_empty_link = []
defects_with_link = []

results.each do |defect|
  puts defect.Name 
  defect.read    
  if defect.c_MyWebLink.LinkID.nil?
    defects_with_empty_link << defect
  else
    defects_with_link << defect
  end
end

puts "----------EMPTY WEB LINK----------"
defects_with_empty_link.each do |defect|
  puts "#{defect.FormattedID}, WebLink: #{defect.c_MyWebLink.LinkID}"
end

puts "---------WEB LINK-----------------"
defects_with_link.each do |defect|
  puts "#{defect.FormattedID}, WebLink: #{defect.c_MyWebLink.LinkID}"
end