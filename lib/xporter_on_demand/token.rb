module XporterOnDemand
  class Token < Client
    def initialize(*args)
      @options = args.last.is_a?(Hash) ? args.pop : {}
      @options[:url] ||= STS_PATH

      @request_body = {}
      %w{ estab relyingParty password thirdpartyid }.each_with_index{ |k, i| @request_body[k] = args[i] }

      @request_body["thirdpartyid"] ||= "XporterOnDemand"
      raise ArgumentError, "must supply all the sniz" unless @request_body.none?{ |k, v| v.nil? }
    end

    def retrieve
      result = post(@options.merge(body: @request_body.to_json))
      assign_attributes(result)
      self
    end
  end
end
