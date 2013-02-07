class Currystache
  
  attr_reader :proc, :args
  
  def initialize meth
    @proc     = meth.to_proc
    @args     = []
  end
  
  def has_key?(key)
    true
  end
  
  def [] arg
    args << arg
    self
  end
  
  def to_s
    proc.call(*args)
  end
    
end