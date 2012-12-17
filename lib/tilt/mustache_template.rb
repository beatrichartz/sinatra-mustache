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
      ::Mustache.template_path = file.gsub(File.basename(file), '') if file
      @engine = ::Mustache.new
      @output = nil
    end

    def evaluate(scope, locals, &block)
      mustache_locals = locals.dup
      
      if data =~ /^(\s*---(.+)---\s*)/m
        yaml = $2.strip
        template = data.sub($1, '')

        YAML.load_documents(yaml) do |front_matter|
          # allows partials to override locals defined higher up
          front_matter.delete_if { |key,value| mustache_locals.has_key?(key)}
          mustache_locals.merge!(front_matter)
        end
      else
        template = data
      end

      scope.instance_variables.each do |instance_variable|
        symbol = instance_variable.to_s.gsub('@','').to_sym

        unless mustache_locals.member?(symbol)
          mustache_locals[symbol] = scope.instance_variable_get(instance_variable)
        end
      end

      mustache_locals[:yield] = block.nil? ? '' : yield
      mustache_locals[:content] = mustache_locals[:yield]

      @output = ::Mustache.render(template, mustache_locals)
    end
  end
  
  register 'mustache', MustacheTemplate
end
