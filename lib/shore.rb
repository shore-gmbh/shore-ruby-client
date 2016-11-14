APP_ENV = ENV['RAILS_ENV'] || ENV['RACK_ENV']

require 'active_support/all'

require 'dotenv'
Dotenv.load(
  File.expand_path("../.env.#{APP_ENV}", __FILE__),
  File.expand_path('../.env', __FILE__)
)

require_relative 'shore/version'
require_relative 'shore/authorization'

# Require all of the client classes
require_relative 'shore/appointment'
require_relative 'shore/conversation'
require_relative 'shore/feedback'
require_relative 'shore/charge'
require_relative 'shore/customer'
require_relative 'shore/merchant'
require_relative 'shore/merchant_account'
require_relative 'shore/message'
require_relative 'shore/newsletter'
require_relative 'shore/notification'
require_relative 'shore/participant'
require_relative 'shore/resource'
require_relative 'shore/service'
require_relative 'shore/short_url'
require_relative 'shore/sms_limit'
require_relative 'shore/stripe_payment'

# Only after all of the clients have been registered, create the factory for
# this version.
require_relative 'shore/client_factory'
