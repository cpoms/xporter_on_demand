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
