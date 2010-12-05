require 'sinatra'
require 'sinatra/mustache'
require 'rack'
require 'rack/test'

require 'request_helper'

RSpec.configure do |config|
  config.include RequestHelper, :type => :request
end
