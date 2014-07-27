module Sinatra
  module MustacheHelper
    METHODS = {}

    def mustache_helper *args
      args.each do |arg|
        if arg.is_a? Symbol
          add_to_mustache_helper_methods(arg)
        elsif arg.is_a? Module
          add_to_mustache_helper_methods(*arg.instance_methods, arg)
        else
          raise ArgumentError.new("#{arg.class} can not be used with mustache_helper, please provide a symbol or a Module")
        end
      end
    end
    alias :mustache_helpers :mustache_helper

    private

    def add_to_mustache_helper_methods *meths
      scope = meths.last.is_a?(Module) ? meths.pop : self
      meths.each do |meth|
        METHODS[meth] = Proxies::Currystache.new(rebind_method!(meth, scope))
      end
    end

    def rebind_method! meth, scope=self
      scope.instance_method(meth).bind(self.new!)
    end

  end

  register MustacheHelper
end
