module Proxies
  class Currystache

    attr_reader :proc, :args

    def initialize my_proc
      @proc     = my_proc
      @args     = []
    end
  
    def has_key? arg
      true
    end

    def call arg
      args << arg
      self
    end
    alias :[] :call
  
    def to_s
      result = proc.call(*args)
      args.clear
      result
    end
    
    def inspect
      proc
    end

  end
end