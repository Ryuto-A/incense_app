# spec/system/password_reset_spec.rb
require "rails_helper"

RSpec.describe "Password reset", type: :system do
  # 参照されない let! を避ける
  let(:user) do
    User.create!(
      email: "user@example.com",
      password: "OldPass123!",
      password_confirmation: "OldPass123!"
    )
  end

  before do
    ActionMailer::Base.deliveries.clear
    user # ← 必要時点で生成
  end

  # rubocop:disable RSpec/ExampleLength, RSpec/MultipleExpectations
  it "resets password and redirects to root while signed in" do
    # 1) リセット要求ページへ
    visit new_user_password_path

    # ラベルではなく input の id を指定（日本語/英語に依存しない）
    fill_in "user_email", with: user.email

    # 送信ボタンはテキストに依存しない
    find('input[type="submit"]').click

    # メールが1通届くこと
    expect(ActionMailer::Base.deliveries.size).to eq(1)

    # 2) メール本文からリセットURL抽出
    mail = ActionMailer::Base.deliveries.last
    reset_url = mail.body.encoded[/http[^"\s]+reset_password_token=[^"\s]+/]
    expect(reset_url).to be_present

    # 3) リセットページで新パスワードを設定
    visit reset_url
    fill_in "user_password",              with: "NewPass123!"
    fill_in "user_password_confirmation", with: "NewPass123!"
    find('input[type="submit"]').click

    # 4) ルートにリダイレクトされている
    expect(page).to have_current_path(root_path, ignore_query: true)

    # 5) サインイン済みの確認：ログアウトUIの存在（リンク or フォーム）
    logout_link   = "a[href='#{destroy_user_session_path}']"
    logout_button = "form[action='#{destroy_user_session_path}'] input[type='submit']"
    expect(page).to have_css("#{logout_link}, #{logout_button}")

    # 実際にログアウト（リンク or フォームのどちらでも対応）
    if page.has_css?(logout_link)
      find(logout_link).click
    elsif page.has_css?(logout_button)
      find(logout_button).click
    end

    # 旧パスではログイン不可
    visit new_user_session_path
    fill_in "user_email",    with: user.email
    fill_in "user_password", with: "OldPass123!"
    find('input[type="submit"]').click
    expect(page).to have_current_path(new_user_session_path, ignore_query: true)

    # 新パスでログインOK
    fill_in "user_email",    with: user.email
    fill_in "user_password", with: "NewPass123!"
    find('input[type="submit"]').click
    expect(page).to have_current_path(root_path, ignore_query: true)
    expect(page).to have_css("#{logout_link}, #{logout_button}")
  end
  # rubocop:enable RSpec/ExampleLength, RSpec/MultipleExpectations
end
