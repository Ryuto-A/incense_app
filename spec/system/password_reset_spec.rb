require "rails_helper"

RSpec.describe "Password reset", type: :system do
  let!(:user) { User.create!(email: "user@example.com", password: "OldPass123!", password_confirmation: "OldPass123!") }

  before { ActionMailer::Base.deliveries.clear }

  it "resets password and redirects to root while signed in" do
    visit new_user_password_path
    fill_in "Email", with: "user@example.com"
    click_button "Send me reset password instructions"

    mail = ActionMailer::Base.deliveries.last
    url  = mail.body.encoded[/http[^"\s]+reset_password_token=[^"\s]+/]
    visit url

    fill_in "New password", with: "NewPass123!"
    fill_in "Confirm new password", with: "NewPass123!"
    click_button "Change my password"

    # ルートに居ること
    expect(page).to have_current_path(root_path, ignore_query: true)
    # ログイン済みUIの何か（ナビのユーザー名/ログアウトボタン）で確認
    expect(page).to have_content("ログアウト").or have_content(user.name.presence || "Incense Review App")
  end
end
