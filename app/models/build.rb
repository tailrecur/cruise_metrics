require 'chronic'
class Build
    attr_reader :id, :label, :status,:reason,:duration, :scheduled_time, :agents,:this_is_time,:jobs,:max_job,:this_is_end_time,:start_time,:end_time,:new_duration
      def initialize(opt={})
        @id=opt[:id]
        @label=opt[:label]
        @status=opt[:status]
        @reason=opt[:reason]
        @duration=opt[:duration].to_f/60                              
        @agents=opt[:agents]
		@jobs=opt[:jobs]
		@jobs=(@jobs.sort_by { |j| j["current_build_duration"].to_f/60.0}).reverse
        #~ @scheduled_time=Chronic.parse opt[:scheduled_time].split[0..1].join(" ")
        @scheduled_time=Date.parse opt[:scheduled_time].split[0..1].join(" ")
		@this_is_time=DateTime.parse opt[:scheduled_time]
		if opt[:this_is_end_time]!="N/A"
		@this_is_end_time=DateTime.parse opt[:this_is_end_time]
		end
		@max_job=@jobs.collect {|item|item["current_build_duration"].to_f/60==@duration ? item["name"]+"/"+item["agent"]:"" }
		if opt[:start_time]!="N/A"
		@start_time=DateTime.parse opt[:start_time]
		end
		if opt[:end_time]!="N/A"
		@end_time=DateTime.parse opt[:end_time]
		end
		if opt[:start_time]!="N/A" and opt[:end_time]!="N/A"
		@new_duration=(@end_time-@start_time)*24.0*60.0
		@duration=@new_duration
		end
      end
      def failed?
        status!='passed'
      end

      def passed?
        status=='passed'
      end
      def to_s
        "#{@status} #{@reason}  #{@scheduled_time}"
      end
end