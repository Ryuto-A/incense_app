# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Home recommendations", type: :request do
  it "shows empty state when there are no favorites in recent period" do
    get root_path
    expect(response).to have_http_status(:ok)
    expect(response.body).to include("今週のおすすめはまだありません")
  end
end
