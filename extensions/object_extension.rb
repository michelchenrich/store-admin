class Object
  def self.collaborators *names
    class_eval do
      public
      attr_reader *names
      define_method :initialize do |*values|
        if values.size != names.size
          raise ArgumentError, "expected #{names.size} arguments, got #{values.size}"
        end
        names.zip(values) { |n,v| instance_variable_set "@#{n}".to_sym, v }
      end
    end
  end
end
