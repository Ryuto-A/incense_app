# frozen_string_literal: true

class PagesController < ApplicationController
  # ApplicationController 側で authenticate_user! を強制していても安全に無効化
  skip_before_action :authenticate_user!, raise: false

  def terms; end
  def privacy; end
end
