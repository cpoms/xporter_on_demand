module XporterOnDemand
  module API
    def fetch(endpoint)
      raise ArgumentError, "endpoint must contain 'id' parameter" unless endpoint.id
      create_result_set(get_endpoint(endpoint), endpoint)
    end

    def query(endpoint)
      create_result_set(get_endpoint(endpoint), endpoint)
    end

    def changed_rows(endpoint)
      raise ArgumentError, "endpoint must contain 'changed_rows' parameter" unless endpoint.parameters[:changed_rows]
      create_result_set(get_endpoint(endpoint), endpoint)
    end

    def db_status(resource)
      create_result_set(get(@uri + resource.to_s.camelize + "/?onlyGetDbStatus=true"))
    end

    def get_endpoint(endpoint)
      get(@uri + endpoint.build_query)
    end

    private
      def create_result_set(results, endpoint = nil)
        XporterOnDemand::ResultSet.new(results).tap do |rs|
          rs.attach_stuff(self, endpoint) if endpoint
        end
      end
  end
end
