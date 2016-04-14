FactoryGirl.define do

  factory :user, class: User do
    sequence(:first_name) { |n| "First #{n}" }
    sequence(:last_name)  { |n| "First #{n}" }
    sequence(:email)      { |n| "first-#{n}@domain.com" }
  end

  factory :page, class: Page do

  end

end
