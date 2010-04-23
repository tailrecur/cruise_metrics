class MingleController < ApplicationController   
        
  def index
    @mingleData=Mingle.new("Trunk","Developer","trunkcruise")
  end
  
end