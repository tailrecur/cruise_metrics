class Checkin
  attr_reader :time, :author, :message,:revision
                    
  def initialize(para={})
    @author=para[:author] 
    @time=para[:time]
    @message=para[:message]
    @revision= para[:revision]                         
    @files=para[:files]
  end                          
  
  def <=>( other)
    if other.nil? or other.time.nil? or @time.nil?
      puts ">>>>>>>> revision is #{@revision} author is #{@author}"
      return -1
    end
    @time <=> other.time
  end                  
  def size
    @files.size
  end          
  def tests
    @files.select{|file|file.strip=~/Test\.cs/}.size
  end
  
  def date
    @time.date
  end
               
  def to_s
    "#{@author} -> #{@revision}, #{@time}"
  end   
end
