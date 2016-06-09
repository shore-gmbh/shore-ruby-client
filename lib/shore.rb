# IMPORTANT: This gem can contain clients for multiple versions of the
# Shore API. It must be possible for the code using this gem to pick a
# particular version to use. By defaul that will be the latest version.
# However, it should be simple for said code to use a different version.
#
# Gemfile:
#   gem 'shore', require: false
# Initializer:
#   require 'shore/v1' # Require Shore::V1 explicitly.
#
# Therefore, this file should only ever contain one line. Namely, requiring
# the default (i.e. latest) version.
require 'shore/v1'
