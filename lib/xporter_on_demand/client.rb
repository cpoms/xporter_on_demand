require 'httpi'
require 'json'
require 'active_support/core_ext/string'
require 'xporter_on_demand/utils'

module XporterOnDemand
  class Client
    include XporterOnDemand::API
    include XporterOnDemand::Utils

    attr_reader :token, :available_scopes, :estab, :uri

    def initialize(token = nil, args = {})
      @token            = token
      @args             = args

      details           = token_details
      @available_scopes = details["Scopes"]
      @estab            = @args.delete(:estab)
      @estab            ||= details["Estab"]

      args[:edubase] ? edubase_client : school_client
    end

    %i{ token_details scopes queries logs usage }.each do |endpoint|
      define_method(endpoint){ get_info(endpoint.to_s.camelcase) }
    end

    # Dis is poo
    def school_client
      @uri = API_PATH + "School/" + estab + "/"
    end

    # So is dis
    def edubase_client
      @uri = API_PATH + "RunQuery/?"
    end

    private
      def get_info(endpoint)
        get(url: API_PATH + endpoint)
      end
  end
end