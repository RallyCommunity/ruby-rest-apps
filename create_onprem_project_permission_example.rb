require 'rally_api'

#Setup custom app information
headers = RallyAPI::CustomHttpHeader.new()
headers.name = "My Utility"
headers.vendor = "Nick M RallyLab"
headers.version = "1.0"

# Connection to Rally
config = {:base_url => "https://10.32.xx.xx/slm"}
config[:username] = "admin@co.com"
config[:password] = "secret"
config[:workspace] = "Workspace 3"
config[:project] = "P0"
config[:headers] = headers #from RallyAPI::CustomHttpHeader.new()
config[:version] = "v2.0"

@rally = RallyAPI::RallyRestJson.new(config)

obj = {}
obj["user"] = {"_ref" => "https://10.32.16.77/slm/webservice/v2.0/user/23254"}
obj["Role"] = "Editor"
#obj["Role"] = "Viewer"
obj["Project"] = {"_ref" => "https://10.32.16.77/slm/webservice/v2.0/project/23862" }
new_projectpermission = @rally.create("projectpermission", obj)





