module Sinatra
  module MustacheHelper
    METHODS = {}
    
    def mustache_helper *args
      args.each do |arg|
        if arg.is_a? Symbol
          add_to_mustache_helper_methods(arg, instance_method(arg).bind(self.new!))
        elsif arg.is_a? Module
          arg.instance_methods.each { |m| add_to_mustache_helper_methods(m, arg.instance_method(m).bind(self.new!)) }
        else
          raise ArgumentError.new("#{arg.class} can not be used with mustache_helper, please provide a symbol or a Module")
        end
      end
    end
    alias :mustache_helpers :mustache_helper
    
    def add_to_mustache_helper_methods name, meth
      METHODS[name] = Proxies::Currystache.new(meth)
    end
    
  end
  
  register MustacheHelper
end