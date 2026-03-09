require 'rails_helper'

RSpec.describe Subscription do
  it "allows a user to subscribe multiple times (without dupes) then unsubscribe" do
    user = create(:user)
    page = create(:page)

    # should create a subscription the first time
    expect { user.subscribe(page) }.to change(described_class, :count).by(1)

    # but not the second time (uses first_or_create to prevent dup'd edges)
    expect { user.subscribe(page) }.not_to change(described_class, :count)

    # confirm user is watching page
    expect(user.watching).to include(page)

    # now unsubscribe
    user.unsubscribe(page)
    expect(user.watching).not_to include(page)
  end

  it "allows a slack channel to subscribe to a page" do
    slack_integration = create(:slack_integration)
    page = create(:page)

    slack_integration.subscribe(page)

    expect(slack_integration.watching).to include(page)
  end
end
