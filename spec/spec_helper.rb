require 'sinatra'
require 'sinatra/mustache'
require 'rack'
require 'rack/test'

require 'request_helper'
require 'fake_template_helper'

RSpec.configure do |config|
  config.include RequestHelper, :type => :request
end
