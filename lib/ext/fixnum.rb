class Fixnum
  def last (count=5)
    start= (self-count)>0 ? self-count :0     
    start..self-1
  end
end