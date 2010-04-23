class ActiveSupport::OrderedHash
  def top(number=1)             
    index=-1
    top_hash={}                                 
    self.keys.each{|key| index+=1; top_hash[key] = self[key] unless index > number }    
    top_hash
  end
end