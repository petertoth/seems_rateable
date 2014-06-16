FactoryGirl.define do
  factory :rate, class: SeemsRateable::Rate do
    association :rateable, factory: :post
    association :rater, factory: :user
    stars { rand(1..5) }
  end
end
