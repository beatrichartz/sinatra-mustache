module Sinatra
  module MustacheHelper
    METHODS = {}
    
    def mustache_helper *args      
      args.each do |arg|
        if arg.is_a? Symbol
          METHODS[arg] = Proxies::Currystache.new(instance_method(arg).bind(self.new!))
        elsif arg.is_a? Module
          arg.instance_methods.each { |m| METHODS[arg] = Proxies::Currystache.new(m) }
        else
          raise ArgumentError.new("#{arg.class} can not be used with mustache_helper, please provide a symbol or a Module")
        end
      end
    end
    alias :mustache_helpers :mustache_helper
    
  end
  
  register MustacheHelper
end