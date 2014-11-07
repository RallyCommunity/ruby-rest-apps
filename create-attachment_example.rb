###############start code###########################
require 'rally_api'


#Setup custom app information
headers = RallyAPI::CustomHttpHeader.new()
headers.name = "My Utility"
headers.vendor = "Nick M RallyLab"
headers.version = "1.0"

# Connection to Rally
config = {:base_url => "https://us1.rallydev.com/slm"}
config[:api_key] = "_abc123"
config[:workspace] = "NMDS" 
config[:project] = "Company X"
config[:headers] = headers #from RallyAPI::CustomHttpHeader.new() 
config[:version] = "v2.0"

@rally = RallyAPI::RallyRestJson.new(config)

require "base64"
encoded_string = Base64.strict_encode64('Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Aenean commodo ligula eget dolor. Aenean massa.\nCum sociis natoque penatibus et magnis dis parturient montes, nascetur rid')
#encoded_string = Base64.encode64('Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Aenean commodo ligula eget dolor. Aenean massa.\nCum sociis natoque penatibus et magnis dis parturient montes, nascetur rid')

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
attachment["Size"] = "20"
attach = @rally.create("attachment", attachment)

=begin

if Base64.encode64 (instead of Base64.strict_encode64) is used with a string that includes \n this the content creation fails with this error:

C:/Ruby192/lib/ruby/gems/1.9.1/gems/rally_api-1.1.2/lib/rally_api/rally_json_con
nection.rb:154:in `send_request':  (StandardError)
Error on request - https://us1.rallydev.com/slm/webservice/v2.0/attachmentconten
t/create.js?/workspace=/workspace/12352608129 -
{:errors=>["Could not convert:  : value to convert : TG9yZW0gaXBzdW0gZG9sb3Igc2l
0IGFtZXQsIGNvbnNlY3RldHVlciBhZGlw\naXNjaW5nIGVsaXQuIEFlbmVhbiBjb21tb2RvIGxpZ3VsY
SBlZ2V0IGRvbG9y\nLiBBZW5lYW4gbWFzc2EuXG5DdW0gc29jaWlzIG5hdG9xdWUgcGVuYXRpYnVz\nI
GV0IG1hZ25pcyBkaXMgcGFydHVyaWVudCBtb250ZXMsIG5hc2NldHVyIHJp\nZA==\n : type to co
nvert : class [B"], :warnings=>["It is no longer necessary to append \".js\" to
WSAPI resources."]}
        from C:/Ruby192/lib/ruby/gems/1.9.1/gems/rally_api-1.1.2/lib/rally_api/r
ally_rest_json.rb:106:in `send_request'
        from C:/Ruby192/lib/ruby/gems/1.9.1/gems/rally_api-1.1.2/lib/rally_api/r
ally_rest_json.rb:187:in `create'
        from create-attachment.rb:40:in `<main>'

=start
################end code###########################