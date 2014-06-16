FactoryGirl.define do
  factory :user do
    sequence :email do |i|
      "person#{i}@guerrillamail.com"
    end
  end
end
