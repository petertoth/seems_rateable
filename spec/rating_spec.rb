require 'spec_helper'

describe SeemsRateable::Rating do
  let(:rated_rateable) { FactoryGirl.create(:post) }
  let(:unrated_rateable) { FactoryGirl.create(:post) }

  let(:stars) { [1, 5, 4, 3, 5] }

  let(:rates) { rated_rateable.rates }
  let(:no_rates) { unrated_rateable.rates }

  before do
    stars.each do |value|
      FactoryGirl.create(:rate, stars: value, rateable: rated_rateable)
    end
  end

  def rating(rates)
    SeemsRateable::Rating.new(rates)
  end

  subject { rating(rates) }

  describe "#rates" do
    subject { super().rates }

    it { should be_a(ActiveRecord::Relation) }
    its(:model) { should equal(SeemsRateable::Rate) }
  end

  describe "#stars" do
    it "plucks rates for stars" do
      subject.rates.should_receive(:pluck).with(:stars)
      subject.stars
    end
  end

  describe "#count" do
    it "returns length of the plucked stars array" do
      subject.stars.should_receive(:length)
      subject.count
    end
  end

  describe "#sum" do
    it "sums the plucked stars array" do
      subject.stars.should_receive(:inject).with(:+)
      subject.sum
    end
  end

  describe "average" do
    context "with any rates" do
      it "divides the sum by the length of stars" do
        sum = subject.sum
        count = subject.count

        subject.average.should == sum/count
      end
    end

    context "without any rate" do
      subject { rating(no_rates) }

      it "returns zero" do
        subject.average.should == 0
      end
    end
  end
end
