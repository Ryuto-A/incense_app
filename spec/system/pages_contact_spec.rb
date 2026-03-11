# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Contact page", type: :system do
  it "is accessible without login" do
    visit contact_path
    expect(page).to have_content("お問い合わせ")
    expect(page).to have_link("お問い合わせフォームへ")
  end
end
