require 'csv'
require 'rally_api'

headers = RallyAPI::CustomHttpHeader.new()
headers.name = "Create stories and tasks"
headers.vendor = "Nick M RallyLab"
headers.version = "1.0"

# Connection to Rally
config = {:base_url => "https://rally1.rallydev.com/slm"}
config[:api_key] = "_abc123"  
config[:workspace] = "NMDS" 
config[:project] = "Company X"
config[:headers] = headers #from RallyAPI::CustomHttpHeader.new()
config[:version] = "v2.0"

$stdout.reopen("log.log", "w")
$stdout.sync = true
$stderr.reopen($stdout)

@rally = RallyAPI::RallyRestJson.new(config)

orphan_tasks_names = []
workproduct_ids = []
tasks_per_story = 3
#num_of_stories_create = (num_of_orphaned_tasks / tasks_per_story.to_f).ceil

#slice array of orphaned tasks into sub-arrays of 3 or less:
array_of_task_arrays = orphan_tasks_names.each_slice(tasks_per_story).to_a


def find_story_by_id(id)
  query = RallyAPI::RallyQuery.new()
  query.type = :userstory
  query.fetch = "Name,FormattedID"
  query.query_string = "(FormattedID = #{id})"
  
  results = @rally.find(query)
  results.first["_ref"]
end

def create_story
  story_payload = {}
  story_payload["Name"] = "my story #{DateTime.now()}"
  story = @rally.create("userstory", story_payload)
  puts "Created a story: #{story["FormattedID"]}"
  story["_ref"]
end

def create_task (workproduct_ref, name=DateTime.now())
  task_payload = {}
  task_payload["Name"] = name
  task_payload["WorkProduct"] = {"_ref" => workproduct_ref}
  task = @rally.create("Task", task_payload)
  puts "Created a task: #{task["FormattedID"]} for story: #{workproduct_ref}"
end

$i = 0
$num = 2

while $i < $num  do
  puts("############# starting loop #{$i} #{Time.now.getutc} ##################")
    CSV.foreach("test.csv", :headers => true) do |csv_obj|
      if csv_obj['Work Product'].nil?
        orphan_tasks_names << csv_obj['Name']
      else
        workproduct_ids << csv_obj['Work Product'].split(":")[0]
      end
    end
    
    array_of_task_arrays.each do |subarray|
  begin
    ref =  create_story
    subarray.each do |e|
      create_task(ref, e);
    end
    puts "------"
  rescue => ex
    puts "#{ex.class} : #{ex}\n#{ex.backtrace.join("\n")}"
    puts "Description of the exception: #{ex.message}"
  end
  
end

  workproduct_ids.each do |id|
    puts "id #{id}"
    begin
      ref = find_story_by_id(id)
      create_task(ref);
    rescue => ex
      puts "#{ex.class} : #{ex}\n#{ex.backtrace.join("\n")}"
      puts "Description of the exception: #{ex.message}"
    end
  end
  puts("############# end loop #{$i} #{Time.now.getutc} #######################")
  $i +=1
end