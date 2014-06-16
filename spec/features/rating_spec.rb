require 'spec_helper'

describe 'rating process', js: true do
  let!(:post) { FactoryGirl.create(:post) }
  let(:user) { FactoryGirl.create(:user) }
  let(:div) { page.first('.rateable') }

  include Warden::Test::Helpers
  Warden.test_mode!

  def login(user)
    login_as(user, scope: :user, run_callbacks: false)
  end

  context "when can rate" do
    before do
      login(user)
    end

    it 'creates a new rate, updates the div and disables it' do
      visit root_path

      div.allow_reload!

      old_body = page.body

      old_average = div["data-average"]

      div.click

      expect(old_body).to_not equal(page.body)
      expect(div.reload["data-average"]).to_not equal(old_average)
      expect(div.reload["class"]).to include('jDisabled')
    end
  end

  context "when cannot rate" do
    shared_examples "doing nothing" do
      it "does nothing" do
        visit root_path

        old_page = page

        div.click

        expect(old_page).to equal(page)
      end
    end

    context "not logged in" do
      it_behaves_like "doing nothing"
    end

    context "already rated" do
      before do
        FactoryGirl.create(:rate, rateable: post, rater: user)
        login(user)
      end

      it_behaves_like "doing nothing"
    end
  end
end
