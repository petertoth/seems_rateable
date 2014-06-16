require 'spec_helper'

feature SeemsRateable::Builder do
  let(:rateable) { DummyModel.seems_rateable.create }
  let(:options) { {} }

  describe ".build" do
    it "initializes a new builder object and builds it" do
      SeemsRateable::Builder.should_receive(:new).with(rateable, kind_of(Hash)).and_call_original
      SeemsRateable::Builder.any_instance.should_receive(:build)
      SeemsRateable::Builder.build(rateable, options)
    end
  end

  describe "#build" do
    def rating(rateable, options)
      Capybara.string(SeemsRateable::Builder.new(rateable, options).build).first('div')
    end

    subject { rating(rateable, options) }

    describe "attributes" do
      its(['class']) { should include(SeemsRateable.config.default_selector_class) }
      its(['data-rateable-type']) { should eq(rateable.class.name) }
      its(['data-rateable-id']) { should eq(rateable.id.to_s) }
      its(['data-average']) { should_not be_nil }
      its(['data-dimension']) { should be_nil }

      context "with explicit class passed" do
        let(:klass) { 'stuff' }

        subject { rating(rateable, class: klass) }

        its(['class']) { should include(klass) }
      end

      context "with dimension" do
        let(:dimension) { 'quality' }
        let(:rateable) { DummyModel.seems_rateable(dimension).create }

        subject { rating(rateable, dimension: dimension) }

        its(['data-dimension']) { should eq(dimension) }
      end

      context "when disabled" do
        subject { rating(rateable, disabled: true) }

        its(['class']) { should include('jDisabled') }
      end
    end
  end
end
