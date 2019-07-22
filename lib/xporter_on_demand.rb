# require "xporter_on_demand/version"
# require 'xporter_on_demand/client'
# require 'xporter_on_demand/token'
# # require 'xporter_on_demand/utils'
# require 'xporter_on_demand/result/serialiser'

require 'xporter_on_demand/api'
require 'xporter_on_demand/client'
require 'xporter_on_demand/endpoint'
require 'xporter_on_demand/factory'
require 'xporter_on_demand/token'
require 'xporter_on_demand/utils'
require 'xporter_on_demand/version'
require 'xporter_on_demand/result/base'
require 'xporter_on_demand/result/result_set'
require 'xporter_on_demand/result/serialiser'
require 'xporter_on_demand/registration'
require 'xporter_on_demand/exception_factory'

module XporterOnDemand
  API_PATH          = "https://xporter.groupcall.com/api/v1/"
  STS_PATH          = "https://login.groupcall.com/idaas/sts/STS/GetToken"
  META_KEYS         = %w(ChangedRows DbStatus Meta Pagination)
  REGISTRATION_PATH = "https://manage.groupcall.com/API/XporterOnDemand/SchoolRegister"

  class Error < StandardError; end
end
