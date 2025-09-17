# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Static pages', type: :system do
  # rack_test: ステータスコード検証や current_path の挙動が安定
  before { driven_by(:rack_test) }

  it 'allows direct access to /terms and /privacy when logged out' do
    visit terms_path
    expect(page).to have_current_path(terms_path, ignore_query: true)

    visit privacy_path
    expect(page).to have_current_path(privacy_path, ignore_query: true)
  end

  it 'is reachable from footer nav' do
    visit root_path

    within('footer') do
      find("a[href='#{terms_path}']").click
    end
    expect(page).to have_current_path(terms_path, ignore_query: true)

    visit root_path
    within('footer') do
      find("a[href='#{privacy_path}']").click
    end
    expect(page).to have_current_path(privacy_path, ignore_query: true)
  end
end
