class Mingle
	attr_reader :time
	def initialize(pipeline,stage,server)
		@pipeline=pipeline
		@stage=stage
		@server=server
	end
	def calculateEfficienyData()
		Cruise.new(@pipeline,@stage,@server)
	end
	def history(limit=100)
		JSON.parse(load_history(limit))["history"]
	end
  

    def load_history(limit)
    
	url="http://jasonro:jasonro@#{@server}.tw.testttl.com:8153/cruise/stageHistory.json?pipelineName=#{@pipeline}&stageName=#{@stage}&perPage=#{limit}"
    puts "Getting data for Mingle by invoking URL #{url}"
    urlObj=URI.parse(url)
    req = Net::HTTP::Get.new(urlObj.path + '?' + urlObj.query)
    req.basic_auth urlObj.user, urlObj.password
    data = Net::HTTP.start(urlObj.host, urlObj.port) {|http|
      http.request(req)
    }
    data.body
  end
end