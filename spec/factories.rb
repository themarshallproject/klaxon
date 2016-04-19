FactoryGirl.define do

  factory :page_snapshot do
    page { create(:page) }
    sequence(:sha2_hash) { |n| "#{n}-fake-#{SecureRandom.hex}" }
  end

  factory :subscription do
  end

  factory :slack_integration do
    channel "#klaxon"
    webhook_url "http://test-webhook.com/test-webhook"
  end

  factory :change do
  end

  factory :user do
    sequence(:first_name) { |n| "First #{n}" }
    sequence(:last_name)  { |n| "Last #{n}" }
    sequence(:email)      { |n| "first-#{n}@domain.com" }
  end

  factory :page do
    name "nyt homepage"
    url "http://www.nytimes.com/"
    css_selector "h2.story-heading"

    trait :with_snapshots do
      transient do
        snapshot_count 2
      end
      after(:create) do |page, evaluator|
        create_list(:page_snapshot, evaluator.snapshot_count, page: page)
      end
    end
  end

end
