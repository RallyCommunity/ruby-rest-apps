###############start code###########################
require 'rally_api'


#Setup custom app information
headers = RallyAPI::CustomHttpHeader.new()
headers.name = "Create image attachment, add inline to the description"
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

require "base64"

img = File.open('connect_screenshot.png', 'rb') { |io| io.read }
encoded_string = Base64.strict_encode64(img)

#find story by fid
query = RallyAPI::RallyQuery.new()
query.type = "story"
query.fetch = "Name,FormattedID"
query.query_string = "(FormattedID = \"US2968\")"

result = @rally.find(query)
story = result.first

#create attachment content
attachment_content = {}
attachment_content["Content"] = encoded_string

content = @rally.create("attachmentcontent", attachment_content)

#create attachment
attachment = {}
attachment["Content"] = content
attachment["Artifact"] = story["_ref"]
attachment["ContentType"] = "application/octet-stream"
attachment["Name"] = "a2.png"
attachment["Size"] = img.length

attach = @rally.create("attachment", attachment)

#add this image inline in Description field of the story
image_link = "https://rally1.rallydev.com/slm/attachment/" + attach["ObjectID"].to_s + "/" + attachment["Name"]
image_source = "<img src=\"#{image_link}\""
style = " style=\"max-width: 100%;\" />"
description = image_source + style

field_updates = {"Description" => description}
story.update(field_updates)

################end code###########################