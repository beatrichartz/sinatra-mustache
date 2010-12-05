module RequestHelper
  include Rack::Test::Methods

  def mock_app(base=Sinatra::Base, &block)
    @app = Sinatra.new(base, &block)
  end

  def app
    Rack::Lint.new(@app)
  end

  def mustache_app(&block)
    mock_app {
      set :environment, :test
      set :views, File.dirname(__FILE__) + '/views'
      get '/', &block
    }

    get '/'
  end

  alias_method :response, :last_response
end
