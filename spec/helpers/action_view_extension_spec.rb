require 'spec_helper'

describe SeemsRateable::Helpers::ActionViewExtension, type: :feature do
  let(:user) { FactoryGirl.create(:user) }
  let(:rateable) { DummyModel.create }
  let(:view) { DummyView.new }

  describe "#rating_for" do
    context "valid rateable object" do
      before do
        DummyModel.seems_rateable
      end

      it "builds a new voting" do
        SeemsRateable::Builder.should_receive(:build).with(rateable, an_instance_of(Hash))
        view.rating_for rateable
      end

      describe "disabled rating" do
        shared_examples "passing disabled true" do |options={}|
          it "passes disabled: true as an option" do
            SeemsRateable::Builder.should_receive(:build).with(rateable, hash_including(disabled: true))
            view.rating_for rateable, options
          end
        end

        context "when no current rater" do
          it_behaves_like "passing disabled true"
        end

        context "when user has already rated" do
          let(:rate) { FactoryGirl.create(:rate, rateable: rateable) }

          before do
            DummyView.stub(:current_rater).and_return(rate.rater)
          end

          it_behaves_like "passing disabled true"
        end

        context "when it is given explicitly" do
          before do
            DummyView.stub(:current_rater).and_return(user)
          end

          it_behaves_like "passing disabled true", disabled: true
        end
      end
    end

    context "invalid rateable object" do
      it "raises an InvalidRateableError" do
        expect {
          view.rating_for "wtf?"
        }.to raise_error(SeemsRateable::Errors::InvalidRateableError)
      end
    end
  end
end
