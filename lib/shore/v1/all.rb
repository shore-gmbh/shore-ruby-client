# Require all of the client classes for each micro-service.
require_relative 'client_base'

# Core
require_relative 'appointment'
require_relative 'merchant'
require_relative 'merchant_account'
require_relative 'resource'
require_relative 'service'

# Customer Service
require_relative 'customer'

# Messaging Service
require_relative 'conversation'
require_relative 'message'
require_relative 'participant'

# Newsletter Service
require_relative 'newsletter'

# Communication Service
require_relative 'sms_limit'
