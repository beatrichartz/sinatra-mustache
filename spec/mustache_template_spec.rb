require 'spec_helper'

describe Tilt::MustacheTemplate do
  describe 'registered for mustache files' do
    subject { Tilt::MustacheTemplate }

    it { should == Tilt['test.mustache'] }
    it { should == Tilt['test.html.mustache'] }
  end

  describe '#render' do
    let(:template) { Tilt::MustacheTemplate.new { |t| 'Hello {{ name }}!'} }

    context 'without locals or a scope' do
      subject { template.render }

      it { should == 'Hello !' }
    end

    context 'with locals' do
      subject { template.render(Object.new, :name => 'World') }

      it { should == 'Hello World!' }
    end

    context 'with an objects scope' do
      let(:scope) do
        scope = Object.new
        scope.instance_variable_set(:@name, 'World')
        scope
      end

      subject { template.render(scope) }

      it { should == 'Hello World!' }
    end

    context 'with both an object and locals' do
      let(:template) do
        Tilt::MustacheTemplate.new {
          'Beer is {{ beer }} but Whisky is {{ whisky }}.'
        }
      end

      let(:scope) do
        scope = Object.new
        scope.instance_variable_set(:@beer, 'wet')
        scope.instance_variable_set(:@whisky, 'wetter')
        scope
      end

      let(:locals) { { :beer => 'great', :whisky => 'greater' } }

      subject { template.render(scope, locals) }

      it 'locals should have precedence' do
        subject.should == 'Beer is great but Whisky is greater.'
      end
      context "with locals evaluating to false" do
        let(:locals) { { :beer => 'great', :whisky => nil } }
        it 'locals should still have precedence' do
          subject.should == 'Beer is great but Whisky is .'
        end
      end
    end
    
    context "data" do
      let(:template) do
        Tilt::MustacheTemplate.new {
          '{{#beers }}{{ preference }} beer is {{ beer }}. {{/beers }} {{#whiskies }}{{ preference }} Whisky is {{ whisky }}. {{/whiskies }}'
        }
      end
      let!(:data) { {:beers => [{:preference => "The best", :beer => "Gulp"}, {:preference => "The second best", :beer => "German Schluck"}],
                    :whiskies => [{:preference => "The worst", :whisky => "Rotten Brew"}, {:preference => "The best", :whisky => "Barley Pure"}]} }
      let(:scope) do
        scope = Object.new
        scope
      end
      subject { template.render(scope, data) }
      it "should not be modified through rendering" do
        subject.should == "The best beer is Gulp. The second best beer is German Schluck.  The worst Whisky is Rotten Brew. The best Whisky is Barley Pure. "
        data.keys.should == [:beers, :whiskies]
      end
    end
    
    context "when locals are changing for the same template" do
      let(:template) {
        Tilt::MustacheTemplate.new {
          'Beer is {{ beer }} but Whisky is {{ whisky }}.'
        }
      }
      before(:all) do
        @template = template
      end
      context "first time rendering" do
        let(:first_locals) { { :beer => 'great', :whisky => 'greater' } }
        subject { @template.render(Object.new, first_locals) }
        it 'should render fine' do
          subject.should == 'Beer is great but Whisky is greater.'
        end
      end
      context "second time rendering with changed locals" do
        let(:second_locals) { { :beer => 'nice', :whisky => 'the best' } }
        subject { @template.render(Object.new, second_locals) }
        it 'should render fine' do
          subject.should == 'Beer is nice but Whisky is the best.'
        end
      end
    end

    context 'passing a block' do
      let(:template) { Tilt::MustacheTemplate.new { |t| 'Hello {{ yield }}!'} }
      subject { template.render { 'World' } }

      it { should == 'Hello World!' }
    end

    context 'with a template that has yaml front matter' do
      let(:template) do
        Tilt::MustacheTemplate.new do
          File.read(File.dirname(__FILE__) + '/views/yaml.mustache')
        end
      end

      subject { template.render }

      it { should == "Hello\nfrom yaml\n" }
    end
  end
end
