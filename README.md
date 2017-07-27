# XporterOnDemand

```ruby
relying_party = "app.example.com"
school_estab  = "1234567"
estab_secret  = "YOUR SECRET HERE"

token  = XporterOnDemand::Token.new(school_estab, relying_party, estab_secret).retrieve
client = XporterOnDemand::Client.new(token.token)
students_endpoint = XporterOnDemand::Endpoint.create(:students, options: [:include_group_ids], parameters: { student_status: 'OnRoll' })

student_results = client.query(students_endpoint)
student_results.fetch_all
```
