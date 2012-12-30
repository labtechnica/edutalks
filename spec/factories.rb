
FactoryGirl.define do

  factory :profile do
    name "Guest"
    description "Can only view homepage"
  end

  factory :user do
    sequence(:name)  { |n| "User #{n}" }
    sequence(:email) { |n| "user_#{n}@edutalks.com"}
    profile
    status :New
    password "foobar"
    password_confirmation "foobar"
  end
end