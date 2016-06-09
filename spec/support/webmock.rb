require 'webmock/rspec'
require 'shore/webmock'

# Disable External requests while allowing localhost
WebMock.disable_net_connect!(allow_localhost: true)
