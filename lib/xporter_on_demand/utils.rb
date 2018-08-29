module XporterOnDemand
  module Utils
    [:get, :post].each do |verb|
      define_method(verb) do |*args|
        request = configure_request(*args)
        response = HTTPI.request(verb, request)
        handle_exceptions(response)
        JSON.parse(response.body.presence || {})
      end
    end

    def configure_request(*args)
      request = HTTPI::Request.new(*args)
      request.headers["Content-Type"] = "application/json"
      request.headers["Authorization"] = "Idaas " + @token if @token
      request
    end

    def handle_exceptions(response)
      response_body = JSON.parse(response.body || {})
      raise response_body["ExceptionMessage"] if response_body["ExceptionMessage"]
    end

    def parameterize(sym)
      sym.to_s.camelize(:lower)
    end

    def assign_attributes(attributes)
      unless instance_variable_defined?("@attributes")
        instance_variable_set("@attributes", [])
        self.class.send(:attr_reader, :attributes)
      end

      XporterOnDemand::Result::Serialiser.serialise(attributes).each do |name, value|
        method_name = name.camelize.underscore

        if META_KEYS.include?(name.camelize)
          value = unwrap(value)
        else
          method_name = method_name.singularize if value.is_a?(Array) && value.length == 1
        end

        instance_variable_set("@#{method_name}", value)

        self.class.send(:attr_reader, method_name)

        @attributes |= [method_name]
      end
    end

    def create_result(type, object)
      Factory.create(
        META_KEYS.include?(type) ? type : type.singularize,
        XporterOnDemand::Result::Base,
        {
          namespace: XporterOnDemand::Result,
          result: object,
        }
      )
    end

    def unwrap(enum)
      if enum.is_a?(Array)
        enum.length <= 1 ? enum.first || [] : enum
      elsif enum.is_a?(Hash)
        enum.length == 1 ? unwrap(enum[enum.keys.first]) : enum
      else
        enum
      end
    end
  end
end
