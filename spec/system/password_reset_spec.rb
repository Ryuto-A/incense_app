require "rails_helper"

RSpec.describe "Password reset", type: :system do
  let!(:user) { User.create!(email: "user@example.com", password: "OldPass123!", password_confirmation: "OldPass123!") }

  before { ActionMailer::Base.deliveries.clear }

  it "resets password and redirects to root while signed in" do
    # 1) リセット要求ページへ
    visit new_user_password_path

    # ラベルではなく input の id を指定（日本語/英語に依存しない）
    fill_in "user_email", with: "user@example.com"

    # 送信ボタンはテキストに依存せず選択
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

    # 送信（ボタン文言に依存しない）
    find('input[type="submit"]').click

    # 4) ルートにリダイレクトされている
    expect(page).to have_current_path(root_path, ignore_query: true)

    # 5) サインイン済みの確認：ログアウトUIの存在で判定（リンク or フォーム、文言に依存しない）
    expect(page).to have_css("a[href='#{destroy_user_session_path}'], form[action='#{destroy_user_session_path}'] input[type='submit']")

    # 実際にログアウト（リンク or フォームのどちらでも対応）
    if page.has_css?("a[href='#{destroy_user_session_path}']")
      find("a[href='#{destroy_user_session_path}']").click
    elsif page.has_css?("form[action='#{destroy_user_session_path}'] input[type='submit']")
      find("form[action='#{destroy_user_session_path}'] input[type='submit']").click
    end

    # 念のため、旧パスではログインできず新パスでログインできることも検証（オプション）
    visit new_user_session_path
    fill_in "user_email",    with: "user@example.com"
    fill_in "user_password", with: "OldPass123!"
    find('input[type="submit"]').click
    # 旧パスは不可 → 再度ログインフォームが出る想定（フラッシュ文言は環境依存のため href で再検）
    expect(page).to have_current_path(new_user_session_path, ignore_query: true)

    fill_in "user_email",    with: "user@example.com"
    fill_in "user_password", with: "NewPass123!"
    find('input[type="submit"]').click
    expect(page).to have_current_path(root_path, ignore_query: true)
    expect(page).to have_css("a[href='#{destroy_user_session_path}'], form[action='#{destroy_user_session_path}'] input[type='submit']")
  end
end
