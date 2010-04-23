require 'charting'

class PerDayChart 
  # include Charting
  # line_chart :
  def self.for(checkins)
    PerDayChart.new(checkins).to_url
  end                             
  
  def initialize(checkins)  
    @checkins=checkins
    @grouped_checkins=checkins.group_by(&:date)
    @line_chart = GoogleChart::LineChart.new('320x200', "Checkins per day", true) do |lcxy|
      checkins=checkin_counts(checkins)
      lcxy.data "Checkin Trends", checkins, '0000ff'
      lcxy.fill(:background, :solid, {:color => 'fff2cc'})
      lcxy.fill(:chart, :solid, {:color => 'ffcccc'})
      lcxy.show_legend = false
      lcxy.axis :x, :labels => labels(checkins), :color => '000000' # Months
      lcxy.axis :y, :labels => (0..checkins_per_day(checkins).max).to_a.select{|item| item%5 ==0}, :color => '000000' # Months

      lcxy.grid :y_step => 20, :x_step => 20, :length_segment => 5, :length_blank => 5
        checkins.size.times do |i|
          lcxy.shape_marker :circle, :color => '000000', :data_set_index => 0, :data_point_index => i, :pixel_size => 5 
        end
      end
  end             
  def to_url
    @line_chart.to_url  
  end
  
  def labels(checkins)
    @grouped_checkins.keys.collect(&:day).select{|item| item % 7 ==0}        
  end                                     
  
  def checkins_per_day(checkins)
    @grouped_checkins.values.collect(&:size)        
  end             
  
  def checkin_counts(checkins) 
    chart_checkin_data=[]
    @grouped_checkins.keys.each_with_index do |key,index|
      chart_checkin_data << [index, @grouped_checkins[key].size]
    end
    chart_checkin_data
  end
end