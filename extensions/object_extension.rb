class Object
  def self.mutates *names
    attr_writer *names
  end

  def self.exposes *names
    attr_reader *names
  end

  def self.requires *names
    class_eval do
      define_method :initialize do |*values|
        if values.size != names.size
          raise ArgumentError, "expected #{names.size} arguments, got #{values.size}"
        end
        names.zip(values) { |n,v| instance_variable_set "@#{n}".to_sym, v }
      end
    end
  end

  def self.collaborators *names
    exposes *names
    requires *names
  end
end
