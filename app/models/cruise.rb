require 'json'
require 'net/http'
require 'fileutils'
require "logger"

class Cruise
  def initialize(pipeline,stage,server)
    @pipeline=pipeline
    @stage=stage
    @server=server
  end           
  def builds(opts={})                             
    builds=history(opts.limit).collect do |hist|
      Build.new :id=>hist["id"],:label=>hist["current_label"],:scheduled_time=>hist["builds"].first["build_scheduled_date"],
                :status=>hist["current_status"], :reason=> hist["buildCause"], 
                :duration=>hist["builds"].collect {|item| item["current_build_duration"].to_f}.max,
                :agents =>hist["builds"].collect {|item| item["agent"]}.seperate,
				:jobs =>hist["builds"],
				:this_is_end_time=>hist["builds"].collect {|item| item["build_completed_date"]}.max,
				:start_time=>hist["builds"].collect {|item| item["build_scheduled_date"]}.min,
				:end_time=>hist["builds"].collect {|item| item["build_completed_date"]}.max
    end           
    builds.reverse
  end
  
  def history(limit=500)
    JSON.parse(load_history(limit))["history"]
  end
  

  def load_history(limit)
    
url="http://jasonro:jasonro@#{@server}.tw.testttl.com:8153/cruise/stageHistory.json?pipelineName=#{@pipeline}&stageName=#{@stage}&perPage=#{limit}"
    puts "invoking URL #{url}"
    urlObj=URI.parse(url)
    req = Net::HTTP::Get.new(urlObj.path + '?' + urlObj.query)
    req.basic_auth urlObj.user, urlObj.password
    data = Net::HTTP.start(urlObj.host, urlObj.port) {|http|
      http.request(req)
    }
    
    
    data.body
  end
end
