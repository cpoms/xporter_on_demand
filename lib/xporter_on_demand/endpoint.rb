require 'xporter_on_demand/factory'

module XporterOnDemand
  class Endpoint
    include XporterOnDemand::Utils

    attr_accessor :endpoint, :options, :parameters, :pagination, :uri, :id

    def self.create(endpoint, args = {})
      endpoint_name = endpoint.to_s.classify

      unless const_defined?(endpoint_name, false)
        class_name = Class.new(self)
        endpoint_class = const_set(endpoint_name, class_name)
      end

      const_get(endpoint_name).new(args).tap do |s|
        s.instance_variable_set(:@endpoint, endpoint)
      end
    end

    def initialize(args = {})
      @options    = args.fetch(:options, [])
      @parameters = args.fetch(:parameters, {})

      @parameters[:page]      ||= 1
      @parameters[:page_size] ||= 25

      @id = args[:id]

      # Check that all the options are valid?
      # Check that the parameters are valid?
      # Check the pagination params are valid?
    end

    def build_query
      URI::Parser.new.escape(resource + "?" + build_parameters)
    end

    private
      def resource
        endpoint.to_s.camelize + "/" + (@id || "")
      end

      def build_options
        @options.any? ? ["options=" + @options.map{ |o| parameterize(o) }.join(',')] : []
      end

      def build_parameters
        (@parameters.map{ |k, v| parameterize(k) + "=" + v.to_s } + build_options).join('&')
      end
  end
end
