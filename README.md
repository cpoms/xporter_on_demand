# A Ruby client for the [XporterOnDemand API](https://xporter.groupcall.com/)

## Installation
```
gem install xod_client
```

## Getting started
```ruby
require 'xporter_on_demand'

relying_party = "app.example.com"   # Your relying party
school_estab  = "1234567"           # School establishment number
estab_secret  = "YOUR SECRET HERE"  # Supplied school secret

# Retrieve an IDAAS Authentication token
token  = XporterOnDemand::Token.new(school_estab, relying_party, estab_secret).retrieve
# Initialize a client with the token
client = XporterOnDemand::Client.new(token.token)

# Craft a query with your desired options & parameters
students_endpoint = XporterOnDemand::Endpoint.create(:students, options: [:include_group_ids, :include_att_stats], parameters: { student_status: 'OnRoll' })

# Fetch the first page of results
student_results = client.query(students_endpoint)
# Retrieve all pages
student_results.fetch_all
```

## Using the Invitation API

```ruby

# Create your registration object
reg = XporterOnDemand::Registration.new do |r|
  r.registration_type     = 'Test' # Defaults to 'Live'
  r.partner_id            = 'your-partner-id'
  r.app_management_secret = 'your-app-management-secret'
end

# Build your school with at the required parameters
school = {
  lea_code: 123,                                          # Required
  dfes_code: 4567,                                        # Required
  school_name: 'Test School',                             # Required
  school_contact_first_name: 'Joe',                       # Required
  school_contact_last_name: 'Bloggs',                     # Required
  school_contact_email: 'joe.bloggs@email.com',           # Required
  school_contact_phone: '01234 567890',                   # Required
  school_contact: 'Joe Bloggs',
  school_technical_contact_name: 'Jim Bloggs',
  school_technical_contact_email: 'jim.bloggs@email.com',
  school_technical_contact_phone: '01234 567890',
  partner_application_id: 'your-partner-id',              # Required
  partner_name: 'your-registered-name',                   # Required
  partner_registered_email: 'your-registered-email',      # Required
  we_accept_groupcall_usage_policy: true,                 # Required
}

# Add school to the registration object. Multiple schools can be added
reg.add_school(school)

# Send registrations
reg.register

# Will return a boolean outlining whether or not ALL registrations were successful.
# Any error messages will be assigned to the registration object or the
# individual schools eg.

reg.message
# => 'Unauthorized: ApplicationId header missing or incorrect'

reg.schools.first.message
# => 'School not found in EduBase'

```
