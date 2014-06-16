require 'spec_helper'

describe SeemsRateable::Models::ActiveRecordExtension do
  describe "#seems_rateable" do
    subject { DummyModel.seems_rateable.new }

    context "without any dimension" do
      it { should have_many(:_rates).class_name(SeemsRateable::Rate) }
      it { should have_many(:_raters).through(:_rates).dependent(:destroy) }
    end

    context "with dimensions" do
      dimensions = [:speed, :quality]
      let(:dimensions) { dimensions }

      subject { DummyModel.seems_rateable(*dimensions).new }

      dimensions.each do |dimension|
        it { should have_many(:"#{dimension}_rates").conditions(dimension: dimension) }
        it { should have_many(:"#{dimension}_raters").through(:"#{dimension}_rates") }
      end
    end

    it { should be_a(SeemsRateable::Models::ActiveRecordExtension::Rateable) }
  end

  describe "#seems_rateable_rater" do
    subject { DummyModel.seems_rateable_rater.new }

    it { should have_many(:rates_given).class_name(SeemsRateable::Rate) }
    it { should be_a(SeemsRateable::Models::ActiveRecordExtension::Rater) }
  end

  describe SeemsRateable::Models::ActiveRecordExtension::Rateable do
    subject do
      Class.new.send(:include, SeemsRateable::Models::ActiveRecordExtension::Rateable).new
    end

    %w[rates raters].each do |method|
      describe "##{method}" do
        context "valid dimension" do
          context "no dimension" do
            it "sends _#{method}" do
              subject.should_receive(:"_#{method}")
              subject.send method
            end
          end

          context "existent dimension" do
            let(:dimension) { 'quality' }

            before do
              subject.stub(dimension + '_' + method).and_return(true)
            end

            it "sends quality_rates" do
              subject.should_receive(:"#{dimension}_#{method}")
              subject.send method, dimension
            end
          end

          context "non-existent dimension" do
            it "raises NonExistentDimension error" do
              expect { subject.send method, "foo" }.to raise_error
            end
          end
        end
      end
    end

    describe "#rating" do
      let(:rates) { SeemsRateable::Rate.all }

      before do
        subject.stub(:rates).and_return(rates)
      end

      it "initializes a SeemsRateable::Rating instance with its rates" do
        subject.rating.should be_a(SeemsRateable::Rating)
        subject.rating.rates.should == rates
      end
    end

    describe "#rated_by" do
      context "when passed rater is nil" do
        it "returns does not query the database and returns nil" do
          subject.rated_by?(nil).should be_nil
        end
      end

      context "when passed rater is not nil" do
        before do
          subject.stub(:raters).and_return([])
        end

        let(:rater) { "a random guy" }

        it "checks wheter its raters includes the rater" do
          subject.raters.should_receive(:include?).with(rater)
          subject.rated_by?(rater)
        end
      end
    end
  end
end
