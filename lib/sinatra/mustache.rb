require 'proxies/currystache'
require 'sinatra/helpers/mustache'
require 'tilt/mustache_template'

module Sinatra
  module Templates
    def mustache(template, options={}, locals={})
      render :mustache, template, options, locals
    end
  end
end
