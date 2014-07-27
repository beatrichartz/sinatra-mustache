require 'spec_helper'

describe Tilt::MustacheTemplate do
  describe 'registered for mustache files' do
    subject { Tilt::MustacheTemplate }

    it { is_expected.to eq(Tilt['test.mustache']) }
    it { is_expected.to eq(Tilt['test.html.mustache']) }
  end

  describe '#render' do
    let(:template) { Tilt::MustacheTemplate.new { |t| 'Hello {{ someone }}!'} }

    context 'without locals or a scope' do
      subject { template.render }

      it { is_expected.to eq('Hello !') }
    end

    context 'with locals' do
      subject { template.render(Object.new, :someone => 'World') }

      it { is_expected.to eq('Hello World!') }
    end

    context 'with an objects scope' do
      let(:scope) do
        scope = Object.new
        scope.instance_variable_set(:@someone, 'World')
        scope
      end

      subject { template.render(scope) }

      it { is_expected.to eq('Hello World!') }
    end

    context 'methods of the scope' do
      let(:template) do
        Tilt::MustacheTemplate.new do |t|
          'Hello, I am {{ name.Moto.Tantra }} and these are my friends {{ friends.Hazy.Lazy.Crazy }}! Come and join us for a {{ sour_drink.Whiskey }} or just a {{ random_drink }}'
        end
      end

      let(:scope) do
        scope = Object.new
        def scope.name first_name, last_name
          [first_name, last_name].join ' '
        end
        def scope.friends *friends
          friends.join ' & '
        end
        def scope.sour_drink type
          "#{type} Sour"
        end
        def scope.random_drink
          "Beer"
        end
        scope
      end

      subject { template.render(scope) }

      it { is_expected.to eq("Hello, I am Moto Tantra and these are my friends Hazy &amp; Lazy &amp; Crazy! Come and join us for a Whiskey Sour or just a Beer") }
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
        expect(subject).to eq('Beer is great but Whisky is greater.')
      end
      context "with locals evaluating to false" do
        let(:locals) { { :beer => 'great', :whisky => nil } }
        it 'locals should still have precedence' do
          expect(subject).to eq('Beer is great but Whisky is .')
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
        expect(subject).to eq("The best beer is Gulp. The second best beer is German Schluck.  The worst Whisky is Rotten Brew. The best Whisky is Barley Pure. ")
        expect(data.keys.map(&:to_s).sort).to eq(%W(beers whiskies))
      end
    end

    context "when locals are changing for the same template" do
      let(:template) {
        Tilt::MustacheTemplate.new {
          'Beer is {{ beer }} but Whisky is {{ whisky }}.'
        }
      }
      context "first time rendering" do
        let(:first_locals) { { :beer => 'great', :whisky => 'greater' } }
        subject { template.render(Object.new, first_locals) }
        it 'should render fine' do
          expect(subject).to eq('Beer is great but Whisky is greater.')
        end
      end
      context "second time rendering with changed locals" do
        let(:second_locals) { { :beer => 'nice', :whisky => 'the best' } }
        subject { template.render(Object.new, second_locals) }
        it 'should render fine' do
          expect(subject).to eq('Beer is nice but Whisky is the best.')
        end
      end
    end

    context 'passing a block' do
      let(:template) { Tilt::MustacheTemplate.new { |t| 'Hello {{ yield }}!'} }
      subject { template.render { 'World' } }

      it { is_expected.to eq('Hello World!') }
    end

    context 'with a template that has yaml front matter' do
      let(:template) do
        Tilt::MustacheTemplate.new do
          File.read(File.dirname(__FILE__) + '/views/yaml.mustache')
        end
      end

      subject { template.render }

      it { is_expected.to eq("Hello\nfrom yaml\n") }
    end
  end
end
