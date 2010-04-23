require 'lib/modules/trending'
class Array
include Trending
  def average
    total/size.to_f
  end            
  def total
    inject(0){|sum,item| sum=sum+item}
  end
  def seperate(seperator=",")
    inject(""){|str, item| str=str+item.to_s+", "}.chop.chop
  end
end