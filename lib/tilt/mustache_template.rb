require 'tilt'
require 'mustache'
require 'yaml'

module Tilt
  class MustacheTemplate < Template
    
    def initialize_engine
      return if defined? ::Mustache
      require_template_library 'mustache'
    end

    def prepare
      ::Mustache.template_path = file.sub File.basename(file), '' if file
      @engine = ::Mustache.new
      @output = nil
    end

    def evaluate scope, locals, &block
      mustache_locals = locals.dup
      
      template = assign_template_and_front_matter! mustache_locals, data
      assign_instance_variables! mustache_locals, scope
      assign_helper_methods! mustache_locals

      mustache_locals[:yield]   = yield if block_given?
      mustache_locals[:content] = mustache_locals.fetch(:yield, '')
      
      @output = ::Mustache.render(template, mustache_locals)
    end
    
    private
    
    def assign_helper_methods! mustache_locals
      mustache_locals.merge! Sinatra::MustacheHelper::METHODS.dup.delete_if{|k,v| mustache_locals.member?(k) }
    end
    
    def assign_instance_variables! mustache_locals, scope
      scope.instance_variables.each do |instance_variable|
        symbol = instance_variable.to_s.delete('@').to_sym
        mustache_locals[symbol] = scope.instance_variable_get(instance_variable) unless mustache_locals.member?(symbol)
      end
    end
    
    def assign_template_and_front_matter! mustache_locals, data
      if yaml = data.match(/\A(\s*-{3}(.+)-{3}\s*)/m)
        template = data.sub(yaml[1], '')
        YAML.load_documents(yaml[2].strip) do |front_matter|
          mustache_locals.merge! front_matter.delete_if{|k,v| mustache_locals.member?(k) }
        end
      else
        template = data
      end
      
      template
    end
  end
  
  register 'mustache', MustacheTemplate
end
