module Trending
  def trend
    tr=[]
    self.each_with_index do |item, index|          
      tr << self[index.last(10)].average
    end     
    tr
  end  
end