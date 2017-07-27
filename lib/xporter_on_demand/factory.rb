module XporterOnDemand
  module Factory
    def self.create(name, superclass, args = {})
      i_vars    = args.delete(:i_vars) || {}
      namespace = args.delete(:namespace) || superclass

      unless namespace.const_defined?(name, false)
        s_class  = Class.new(superclass)
        namespace.const_set(name, s_class)
      end

      namespace.const_get(name).new(args).tap do |klass|
        i_vars.each do |i_var, value|
          klass.instance_variable_set(i_var, value)
        end
      end
    end
  end
end
