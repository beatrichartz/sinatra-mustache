class Currystache
  
  attr_reader :curried, :proc, :args
  
  def initialize meth
    @proc     = meth.to_proc
    @args     = []
    
    if proc.arity > 0
      @curried = proc.curry
    elsif proc.arity == -1
      @proxied = true
    end
  end
  
  def has_key?(key)
    true
  end
  
  def [] arg
    if curried? || proxied?
      args << arg
      self
    else
      proc.call
    end
  end
  
  def to_s
    if curried? || proxied?
      proc.call(*args)
    else
      proc.call
    end
  end
  
  private
  
    def curried?
      !!@curried
    end
    
    def proxied?
      @proxied == true
    end
    
end