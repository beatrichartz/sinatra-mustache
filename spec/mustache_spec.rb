require 'spec_helper'

describe 'sinatra-mustache', :type => :request do
  subject { response }
  
  context 'with an inline layout and template caching' do
    before(:each) do
      @app = mock_app {
        disable :reload_templates
        layout { 'Hello from {{ yield }}!' }
        get('/foo') { mustache 'foo' }
        get('/bar') { mustache 'bar' }
      }
    end

    describe "two requests" do
      it "does not cache wrong" do
        get '/foo'
        expect(response.body).to eq('Hello from foo!')
        get '/bar'
        expect(response.body).to eq('Hello from bar!')
      end
    end
  end
  
  context "with defined mustache template helpers" do
    before(:each) do
      @app = mock_helper_app {
        register Sinatra::MustacheHelper
        layout { 'Hello, I am {{ name.Moto.Tantra }} and these are my friends {{ friends.Hazy.Lazy.Crazy }}! Come and join us for a {{ sour_drink.Whiskey }} or just a {{ random_drink }}' }
        helpers do
          def name first_name, last_name
            [first_name, last_name].join ' '
          end
          def friends *friends
            friends.join ' & '
          end
          def sour_drink type
            "#{type} Sour"
          end
          def random_drink
            "Beer"
          end
        end
        mustache_helpers :name, :friends, :sour_drink, :random_drink
        get('/foo') { mustache 'foo' }
      }
    end
    after(:each) do
      clean_helper_app
    end
    it "should include them and make them usable" do
      get '/foo'
      expect(response.body).to eq("Hello, I am Moto Tantra and these are my friends Hazy &amp; Lazy &amp; Crazy! Come and join us for a Whiskey Sour or just a Beer")
    end
  end
  
  context "with a module of mustache template helpers" do
    before(:each) do
      @app = mock_helper_app {
        register Sinatra::MustacheHelper
        layout { 'Hello, I am {{ name.Moto.Tantra }} and these are my friends {{ friends.Hazy.Lazy.Crazy }}! Come and join us for a {{ sour_drink.Whiskey }} or just a {{ random_drink }}' }
        helpers FakeTemplateHelper
        mustache_helpers FakeTemplateHelper
        get('/foo') { mustache 'foo' }
      }
    end
    after(:each) do
      clean_helper_app
    end
    it "should include them and make them usable" do
      get '/foo'
      expect(response.body).to eq("Hello, I am Moto Tantra and these are my friends Hazy &amp; Lazy &amp; Crazy! Come and join us for a Whiskey Sour or just a Beer")
    end
  end

  context 'inline mustache strings' do
    context 'without the :locals option' do
      before(:each) { mustache_app { mustache('Hello') } }

      it { should be_ok }

      describe '#body' do
        subject { super().body }
        it { should == 'Hello' }
      end
    end

    context 'with :locals option' do
      before(:each) do
        locals = { :subject => 'World' }
        mustache_app { mustache('Hello {{ subject }}!', :locals => locals) }
      end

      it { should be_ok }

      describe '#body' do
        subject { super().body }
        it { should == 'Hello World!' }
      end
    end

    context 'with an inline layout' do
      before(:each) do
        mock_app {
          layout { 'This is a {{ yield }}!' }
          get('/') { mustache 'layout' }
        }

        get '/'
      end

      it { should be_ok }

      describe '#body' do
        subject { super().body }
        it { should == 'This is a layout!' }
      end
    end

    context 'with a file layout' do
      before(:each) do
        mustache_app { mustache('Hello World!', :layout => :layout_too) }
      end

      it { should be_ok }

      describe '#body' do
        subject { super().body }
        it { should == "From a layout!\nHello World!\n" }
      end
    end
  end

  context 'rendering .mustache files in the views path' do
    context 'without a layout' do
      before(:each) { mustache_app { mustache :hello } }

      it { should be_ok }

      describe '#body' do
        subject { super().body }
        it { should == "Hello \n" }
      end
    end

    context 'that calls a partial' do
      before(:each) { mustache_app { mustache :needs_partial } }

      it { should be_ok }

      describe '#body' do
        subject { super().body }
        it { should == "Hello\nfrom a partial\n" }
      end
    end

    context 'that has yaml front matter' do
      before(:each) { mustache_app { mustache :yaml } }

      it { should be_ok }

      describe '#body' do
        subject { super().body }
        it { should == "Hello\nfrom yaml\n" }
      end
    end
  end
end
