require 'rubygems'
require 'hpricot'
require 'open-uri'   
require 'chronic'
class CCNet   
  
  def initialize (url)
    @all_build_url =url
  end             
  
  def self.at( machine)
    Cruise.new "http://#{machine}/ccnet/server/local/project/2.5+Smoke/ViewAllBuilds.aspx"
  end

  def list
    doc = Hpricot(open(@all_build_url))                                                      
    failed=doc.search(".build-failed-link").collect{|elem| Build.new(elem)}
    passed=doc.search(".build-passed-link").collect{|elem| Build.new(elem)}
    all= (passed+failed).sort
    puts "passed= #{passed.size}"
    pass_fail_ratio=passed.size/failed.size
    puts "Passed failed ratio is #{passed.size.to_f/failed.size}"
    puts "Passed  ratio is #{passed.size.to_f/all.size}"
    todays_pass_builds = passed.reject{|build| build.date < 1}
    puts "#{todays_pass_builds.size} build(s) passed today so far" 
    # todays_failed_builds = failed.reject{|build| build.date < Date.new}
    # puts "#{todays_pass_builds.size} build(s) failed today so far" 
  end
end