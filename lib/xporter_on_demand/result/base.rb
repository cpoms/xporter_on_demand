module XporterOnDemand
  module Result
    class Base
      include XporterOnDemand::Utils

      def initialize(args = {})
        result = args.delete(:result)
        assign_attributes(result)
      end

      def type
        self.class.name.demodulize
      end

      def update(other_result)
        return if other_result.type != type ||\
                  other_result.id != id ||\
                  other_result.last_updated <= last_updated

        attributes.each do |attribute|
          send("#{attribute}=", other_result.send(attribute))
        end
      end
    end
  end
end
