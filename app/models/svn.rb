require 'rubygems'
require 'chronic'
     
class Time
  def date
    Date.new year,month,day
  end
end
class Svn
  
  def nil.split( xxx)
    [""]
  end
  def self.list (limit=10)                      
    logs=`svn -v log #{ENV['CODE_BASE_TOP_DIR']} --limit #{limit} --username tlsvn --password '!4321abcd'`.split "------------------------------------------------------------------------\n"
    logs=logs[1..logs.size].select {|log| !log.strip.empty?} # skip the first one i think.
    checkins=logs.collect do |log|                                       
      revision,author,time,files,message=log.gsub("\n",' ').split '|'         
      Checkin.new :revision=>revision, :author=>author, :time=>Chronic.parse(time.split ("(")[0]), :message=>message, :files=> files.split("   ")[1..-1]
    end.sort       
  end    
  
end
