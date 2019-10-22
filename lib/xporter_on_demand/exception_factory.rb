module XporterOnDemand
  module ExceptionFactory
    def self.generate_exception(response_hash)
      exception_type    = response_hash.delete('ExceptionType') || "UnknownError"
      message           = response_hash.delete('Message')
      exception_message = response_hash.delete('ExceptionMessage')
      inner_exception   = response_hash.delete('InnerException')

      unless XporterOnDemand.constants.include? exception_type.to_sym
        XporterOnDemand.const_set exception_type, Class.new(Error)
      end

      blob = <<~ERROR
      #{exception_type}
      ==========
      Message: #{message}
      ExceptionMessage: #{exception_message}
      InnerException: #{inner_exception}
      ==========
      ERROR

      raise XporterOnDemand.const_get(exception_type).new(blob)
    end
  end
end
