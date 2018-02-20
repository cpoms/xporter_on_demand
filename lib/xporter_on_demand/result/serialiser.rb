module XporterOnDemand
  module Result
    class Serialiser
      FORMAT_REGISTRY = Hash.new{ |h, k| h[k] = { type: :default } }.update(
        active:                 { type: :boolean },
        date:                   { type: :date },
        dateof_birth:           { type: :date },
        date_of_birth:          { type: :date },
        date_time:              { type: :date_time },
        eal:                    { type: :boolean },
        expires:                { type: :date_time },
        fsm_eligible:           { type: :boolean },
        fsm_ever6:              { type: :boolean },
        gifted:                 { type: :boolean },
        in_lea_care:            { type: :boolean },
        last_updated:           { type: :date_time },
        par_resp:               { type: :boolean },
        pupil_premium:          { type: :boolean },
        service_child:          { type: :boolean },
        uniform_allowance:      { type: :boolean }
      )

      FORMATTERS = {
        boolean:   ->(v){ !!v.nonzero? rescue nil },
        csv:       ->(v){ v.split(',') rescue [] },
        date:      ->(v){ Date.parse(v) rescue nil },
        date_time: ->(v){ DateTime.parse(v) rescue nil },
        default:   ->(v){ v },
      }

      def self.serialise(attributes)
        object_array = attributes.map do |attribute, value|
          key = attribute.underscore
          format = get_format(key)

          [key, FORMATTERS[format].call(value)]
        end
        object_array.to_h
      end

      private
        def self.get_format(key)
          if key =~ /_ids\z/
            :csv
          elsif key =~ /(_?date\z|(start|end)\z)/
            :date
          elsif key =~ /_date_time\z/
            :date_time
          elsif key =~ /\Ais_/
            :boolean
          else
            FORMAT_REGISTRY[key.to_sym][:type]
          end
        end
    end
  end
end
