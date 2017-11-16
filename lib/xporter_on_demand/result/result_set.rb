module XporterOnDemand
  class ResultSet
    include Enumerable
    include XporterOnDemand::Utils

    attr_accessor :results, :school, :endpoint

    def initialize(result_hash)
      results = create_results(result_hash)
      assign_attributes results
    end

    def each
      all.each{ |result| yield result }
    end

    def all
      attributes.reject{ |a| META_KEYS.include? a.camelcase }.flat_map{ |a| send(a) }
    end

    def length
      all.length
    end

    def fetch_all
      return self unless try :pagination
      og_page = pagination.page_number

      pagination.page_count.times do |i|
        # Skip if we've already got this page
        next if og_page == i + 1

        endpoint.parameters[:page] = i + 1

        results_hash = create_results(school.get_endpoint(endpoint))

        results_hash.each do |type, results|
          if META_KEYS.include? type.camelcase
            assign_attributes(type => results)
          elsif self.respond_to?(type)
            results.each do |result|
              if result.respond_to?(:id) && existing_result = send(type).find{ |r| r.id == result.id }
                existing_result.update(result)
              else
                send(type).append(result)
              end
            end
          else
            assign_attributes(type => results)
          end
        end
      end
      self
    end

    def attach_stuff(sch, ep)
      self.school = sch
      self.endpoint = ep.dup
    end

    private
      def create_results(result_hash)
        result_hash.map do |namespace, objects|
          type = namespace.underscore.camelize
          result_objects = objects.flat_map{ |object| create_result(type, object) }

          [namespace.underscore, result_objects]
        end.to_h
      end

      # def create_result(type, object)
      #   Factory.create(
      #     META_KEYS.include?(type) ? type : type.singularize,
      #     XporterOnDemand::Result::Base,
      #     {
      #       namespace: XporterOnDemand::Result,
      #       result: object
      #     }
      #   )
      # end
  end
end
