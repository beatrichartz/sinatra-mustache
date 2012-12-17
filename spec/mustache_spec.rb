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
        response.body.should == 'Hello from foo!'
        get '/bar'
        response.body.should == 'Hello from bar!'
      end
    end
  end

  context 'inline mustache strings' do
    context 'without the :locals option' do
      before(:each) { mustache_app { mustache('Hello') } }

      it { should be_ok }
      its(:body) { should == 'Hello' }
    end

    context 'with :locals option' do
      before(:each) do
        locals = { :subject => 'World' }
        mustache_app { mustache('Hello {{ subject }}!', :locals => locals) }
      end

      it { should be_ok }
      its(:body) { should == 'Hello World!' }
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
      its(:body) { should == 'This is a layout!' }
    end

    context 'with a file layout' do
      before(:each) do
        mustache_app { mustache('Hello World!', :layout => :layout_too) }
      end

      it { should be_ok }
      its(:body) { should == "From a layout!\nHello World!\n" }
    end
  end

  context 'rendering .mustache files in the views path' do
    context 'without a layout' do
      before(:each) { mustache_app { mustache :hello } }

      it { should be_ok }
      its(:body) { should == "Hello \n" }
    end

    context 'that calls a partial' do
      before(:each) { mustache_app { mustache :needs_partial } }

      it { should be_ok }
      its(:body) { should == "Hello\nfrom a partial\n" }
    end

    context 'that has yaml front matter' do
      before(:each) { mustache_app { mustache :yaml } }

      it { should be_ok }
      its(:body) { should == "Hello\nfrom yaml\n" }
    end
  end
end
