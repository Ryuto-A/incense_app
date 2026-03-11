# frozen_string_literal: true
require "rails_helper"

RSpec.describe "Contact page", type: :system do
  it "is accessible without login" do
    visit contact_path
    expect(page).to have_content("お問い合わせ")

    if Rails.configuration.x.contact_form_url.present?
      expect(page).to have_link("お問い合わせフォームへ")
    else
      expect(page).to have_content("未設定")
    end
  end
end
