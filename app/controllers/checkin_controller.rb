class CheckinController < ApplicationController   
    helper Ziya::Helper    
  def index
    @checkins=Svn.list 1100
  end                  
  
  
  def checkins_per_day_chart      
    @checkins=Svn.list 1100
    chart = Ziya::Charts::Line.new           
    grouped_checkins=@checkins.reject{|a| a.time.nil? }.group_by {|b| b.time.to_date}
    chart.add( :axis_category_text, grouped_checkins.keys.collect(&:day) )
    chart.add( :series, "Checkins Count", grouped_checkins.keys.collect{|date| grouped_checkins[date].size} )
    respond_to do |fmt|
     fmt.xml { render :xml => chart.to_xml }
   end
  end
  
end
