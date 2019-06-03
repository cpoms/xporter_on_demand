require 'xporter_on_demand/utils'
require 'base64'

module XporterOnDemand
  class Registration
    include XporterOnDemand::Utils

    attr_reader :schools, :message
    attr_accessor :registration_type, :partner_id, :app_management_secret

    SCHOOL_ATTRIBUTES = %i(
      lea_code
      dfes_code
      school_name
      school_contact_first_name
      school_contact_last_name
      school_contact_email
      school_contact_phone
      school_contact
      school_technical_contact_name
      school_technical_contact_email
      school_technical_contact_phone
      partner_application_id
      partner_name
      partner_registered_email
      scopes_to_authorise
      we_accept_groupcall_usage_policy
    )

    School = Struct.new(*SCHOOL_ATTRIBUTES, keyword_init: true) do
      attr_accessor :status, :message

      def camelize
        to_h.transform_keys{ |k| k.to_s.camelcase }.reject{ |_k, v| v.nil? || (String === v && v.empty?) }
      end
    end

    def initialize(args = {})
      @schools = Set.new

      if block_given?
        yield self
      else
        @registration_type     = args[:registration_type] || 'Live'
        @partner_id            = args[:partner_id]
        @app_management_secret = args[:app_management_secret]
      end
    end

    def add_school(param_hash = {})
      attributes = SCHOOL_ATTRIBUTES.each_with_object({}) do |key, hash|
        hash[key] = param_hash[key]
      end

      @schools << School.new(attributes)
    end

    def register
      timestamp = DateTime.current.strftime("%FT%T")
      auth = generate_hash(timestamp: timestamp)

      args = {
        url: REGISTRATION_PATH,
        headers: {
          'ApplicationId': @partner_id,
          'DateTime': timestamp,
          'Authorization': "Groupcall #{auth}",
        },
        body: to_json,
      }

      response = post(args)

      if response['Schools']
        response['Schools'].all? do |school|
          s = get_school(school['LeaCode'], school['DfesCode'])
          s.status = school['Status']
          s.message = school['Message']

          school['Status'] == 'OK'
        end
      else
        @message = response['Message']
        false
      end
    end

    def get_school(lea, dfes)
      @schools.find{ |sch| sch.lea_code == lea && sch.dfes_code == dfes }
    end

    def to_json
      { Schools: @schools.map(&:camelize), RegistrationType: @registration_type }.to_json
    end

    def generate_hash(secret: @app_management_secret, timestamp:, content: to_json)
      raise ArgumentError, 'Must supply your App Management Secret' unless secret
      raise ArgumentError, 'Must supply at least one school' if @schools.empty?

      b64 = Base64.strict_encode64(content + timestamp + secret)

      sha256 = OpenSSL::Digest.new('sha256')
      OpenSSL::HMAC.hexdigest(sha256, secret, b64).upcase
    end
  end
end
