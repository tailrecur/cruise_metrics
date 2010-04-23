class BuildController < ApplicationController    
  helper Ziya::Helper
  
  def index                                             
    unless params[:pipeline].nil?
       @builds =Cruise.new(params[:pipeline],params[:stage],params[:server]).builds(:limit=>100)
      render :partial=>"build_stat",:locals=>params,:layout=>'application'
    end
  end       

            
   def passed(builds) # hack fix it
     builds.select(&:passed?)
   end
   def not_passed(builds)
     builds.select(&:failed?)    
   end

  def build_time_chart      
    @builds =Cruise.new(params[:pipeline],params[:stage],params[:server]).builds(:limit=>100)
    chart = Ziya::Charts::Line.new           
    passed= passed(@builds)
    durations=passed.collect(&:duration)
    chart.add( :axis_category_text, passed.collect(&:label) )
    chart.add( :series, "Build Times", passed.collect(&:duration) )   # seems like a bug in ziya... causing the actual array itself to change
    chart.add( :series, "Trends", durations.trend )
    respond_to do |fmt|
     fmt.xml { render :xml => chart.to_xml }
   end
  end
  def builds_per_day_chart      
    @builds =Cruise.new(params[:pipeline],params[:stage],params[:server]).builds(:limit=>100)
    
    chart = Ziya::Charts::StackedArea.new           

    passed=passed(@builds)    
    grouped_builds=@builds.group_by {|b| b.scheduled_time.to_date}
    chart.add( :axis_category_text, grouped_builds.keys.collect(&:day) )

    grouped_passed_builds=passed.group_by{|b| b.scheduled_time.to_date}
    chart.add( :series, "Build Success", grouped_builds.keys.collect{|date| grouped_passed_builds[date].size} )

    failed=not_passed(@builds)    
    grouped_failed_builds=failed.group_by{|b| b.scheduled_time.to_date}

    chart.add( :series, "Build Failures", grouped_builds.keys.collect{|date| grouped_failed_builds[date].size} )

    respond_to do |fmt|
     fmt.xml { render :xml => chart.to_xml }
    end
  end
  
  
  
  def build_turnaround_chart      
    @builds =Cruise.new(params[:pipeline],params[:stage],params[:server]).builds(:limit=>100)
    
    chart = Ziya::Charts::Line.new           

    grouped_builds=@builds.group_by {|b| b.scheduled_time.to_date}
    chart.add( :axis_category_text, grouped_builds.keys.collect(&:day) )

    grouped_builds.keys.collect{|date| build_fail_durations(grouped_builds[date])}

    chart.add( :series, "Build Turnaround time( in minutes)", grouped_builds.keys.collect{|date| build_fail_durations(grouped_builds[date])} )
    respond_to do |fmt|100
     fmt.xml { render :xml => chart.to_xml }
    end
  end
  
  
  
  def build_fail_durations(builds_of_day)
    grouped_builds=[]
    failed_turnaround=builds_of_day.each_with_index do |build,i|
      grouped_builds << build unless build.status == builds_of_day[i-1].status
    end
    build_fix_durations=[]
    grouped_builds.each_with_index {|build,index|  build_fix_durations<<((grouped_builds[index+1].this_is_end_time - build.this_is_time)*24.0*60.0) if (build.failed? and grouped_builds[index+1].not_nil? and grouped_builds[index+1].this_is_end_time.not_nil?) }
    build_fix_durations.average
  end
end
