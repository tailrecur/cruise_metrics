class Hash

# not sure if we should implement respond_to? here.....
  def method_missing(m,*a)
    if m.to_s =~ /=$/
      self[$`] = a[0]
    elsif a.empty?
      self[m]
    else
      raise NoMethodError, "#{m}"
    end
  end
end