require 'spec_helper'

describe SeemsRateable::RatesController do
  routes { SeemsRateable::Engine.routes }

  let(:user) { FactoryGirl.create(:user) }
  let(:article) { FactoryGirl.create(:post) }

  describe "POST #create" do
    def create_rate
      xhr :post, :create, valid_attributes(article)
    end

    def valid_attributes(rateable)
      {
        rate: {
          rateable_type: rateable.class.name,
          rateable_id: rateable.id,
          stars: rand(1..5),
          dimension: ['speed', 'quality', nil].sample
        }
      }
    end

    context "when valid" do
      before do
        controller.stub(:current_user).and_return(user)
      end

      it "creates a new rate" do
        expect { create_rate }.to change(SeemsRateable::Rate, :count).by(1)
      end

      it "assigns a newly created rate as @rate" do
        create_rate
        assigns(:rate).should be_a(SeemsRateable::Rate)
        assigns(:rate).should be_persisted
      end

      it "renders average rating as json" do
        create_rate
        expect(response.content_type).to eq('application/json')
        expect(response.status).to eq(200)
        expect(JSON.parse(response.body)).to have_key("average")
      end
    end

    context "when invalid" do
      context "when user is not signed in" do
        it "raises a NoCurrentRaterError error" do
          expect { create_rate }.to raise_error
        end
      end
    end
  end
end
