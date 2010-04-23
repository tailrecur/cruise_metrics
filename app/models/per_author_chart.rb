require 'forwardable'
class PerAuthorChart
  extend Forwardable
            
  def_delegator :@bc,:to_url

  def self.for (checkins,opt={})
    PerAuthorChart.new(checkins, opt).to_url
  end                                

  def initialize (checkins, opt={})
    @grouped_checkins=checkins.group_by(&:author)     
    puts opt[:limit]
    if opt[:limit]
      @grouped_checkins= limit_checkins opt[:limit]     
      puts " size= #{@grouped_checkins.size}"
    end
    @bc = GoogleChart::BarChart.new('1000x200', "Bar Chart", :vertical, false)
    all_data={}
    @grouped_checkins.keys.each{|author| all_data[author]= @grouped_checkins[author].size}
    
    @bc.data "Author Checkins",all_data.values, '0000ff'
    @bc.axis :x, :labels => all_data.keys, :color => '000000' # Months
    @bc.axis :y, :labels => (0..counts.max).to_a.select{|item| item %5 ==0}, :color => '000000' # Months
    @bc.grid :y_step => 20, :x_step => 20, :length_segment => 5, :length_blank => 5
  end       
  
  def counts
    @grouped_checkins.values.collect{|arr| arr.size}.sort
  end                        
  
  def authors
    @grouped_checkins.keys
  end        
  def limit_checkins (limit)
    @grouped_checkins.sort{|first,second| second.size<=>first.size}.top(limit)
  end              
  

end