class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name])
    devise_parameter_sanitizer.permit(:account_update, keys: [:name])
  end

  def after_resetting_password_path_for(_resource)
    incense_reviews_path # 例: 任意のパスに変更
  end

  private

  # 相対パスだけを許可（オープンリダイレクト対策）
  def safe_redirect_path(path)
    return nil if path.blank?
    uri = URI.parse(path)
    # ホストなし（相対）＆パスある → OK
    return path if uri.host.nil? && uri.path.present?
  rescue URI::InvalidURIError
    nil
  end

  def after_sign_in_path_for(resource)
    # 1) 明示的な redirect_to パラメータ（相対パスのみ許可）
    if (p = safe_redirect_path(params[:redirect_to]))
      return p
    end
    # 2) Devise が保存している “戻り先”
    stored_location_for(resource) || super
  end
end
