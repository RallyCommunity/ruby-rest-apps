###############start code###########################
require 'rally_api'


#Setup custom app information
headers = RallyAPI::CustomHttpHeader.new()
headers.name = "My Utility"
headers.vendor = "Nick M RallyLab"
headers.version = "1.0"

# Connection to Rally
config = {:base_url => "https://us1.rallydev.com/slm"}
config[:api_key] = "_KEI2ib0qSgOFBCPMkQjypGD4bgSL403ixhyO7e7L28"
config[:workspace] = "NMDS" 
config[:project] = "Company X"
config[:headers] = headers #from RallyAPI::CustomHttpHeader.new() 
config[:version] = "v2.0"

@rally = RallyAPI::RallyRestJson.new(config)

require "base64"
#encoded_string = Base64.encode64('hello') #results in "Could not convert" error
str = 'hello'
encoded_string = Base64.strict_encode64(str)

#find story by fid
query = RallyAPI::RallyQuery.new()
query.type = "story"
query.fetch = "Name,FormattedID"
query.query_string = "(FormattedID = \"US2943\")"

result = @rally.find(query)
story = result.first["_ref"]

attachment_content = {}
attachment_content["Content"] = encoded_string

content = @rally.create("attachmentcontent", attachment_content)

attachment = {}
attachment["Content"] = content
attachment["Artifact"] = story
attachment["ContentType"] = "application/octet-stream"
attachment["Name"] = "b.txt"
attachment["Size"] = str.length
attach = @rally.create("attachment", attachment)

################end code###########################