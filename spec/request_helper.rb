module RequestHelper
  include Rack::Test::Methods

  def mock_app(base=Sinatra::Base, &block)
    @app = Sinatra.new(base, &block)
  end
  
  def mock_helper_app &block
    @helper_app = Sinatra::Base
    @helper_app.class_eval &block
    @helper_app
  end
  
  def clean_helper_app
    Sinatra::Base.class_eval do
      layout { "{{ yield }}" }
      undef :name if instance_methods.include?(:name)
      undef :friends if instance_methods.include?(:friends)
      undef :sour_drink if instance_methods.include?(:sour_drink)
      undef :random_drink if instance_methods.include?(:random_drink)
    end
  end

  def app
    Rack::Lint.new(@app)
  end

  def mustache_app(&block)
    mock_app {
      helpers Sinatra::MustacheHelper
      set :environment, :test
      set :views, File.dirname(__FILE__) + '/views'
      get '/', &block
    }

    get '/'
  end

  alias_method :response, :last_response
end
