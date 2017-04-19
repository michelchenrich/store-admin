class Memory
  def initialize data=Hash.new
    @data = data 
  end

  def method_missing name, *arguments
    if name.to_s.end_with? '='
      @data[name.to_s.chomp('=').to_sym] = arguments[0]
    else
      @data[name]
    end
  end

  def responds_to _
    true
  end

  def to_h
    @data
  end
end
