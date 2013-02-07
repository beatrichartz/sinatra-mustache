class Currystache
  
  attr_reader :curried, :proc, :args
  
  def initialize meth
    @proc     = meth.to_proc
    @args     = []
    
    @proxied  = proc.arity != 0
  end
  
  def has_key?(key)
    true
  end
  
  def [] arg
    if proxied?
      args << arg
      self
    else
      proc.call
    end
  end
  
  def to_s
    if proxied?
      proc.call(*args)
    else
      proc.call
    end
  end
  
  private
    
    def proxied?
      @proxied == true
    end
    
end