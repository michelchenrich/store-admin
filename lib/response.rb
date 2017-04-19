class Response
  def initialize
    @data = {}
  end

  def responds_to? _
    true
  end

  def method_missing name, *arguments
    @data[name] = value_of(arguments)
  end

  def value_of arguments
    if arguments.size == 0
      true
    elsif arguments.size == 1
      arguments[0]
    else
      arguments
    end
  end

  def build
    @data
  end
end
