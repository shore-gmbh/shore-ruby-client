if ENV['COVERAGE']
  require 'simplecov'
  SimpleCov.start do
    add_filter 'spec'
  end
end

$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'shore/client'
require 'pry'
