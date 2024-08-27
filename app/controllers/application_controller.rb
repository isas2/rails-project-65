# frozen_string_literal: true

class ApplicationController < ActionController::Base
  include Pundit::Authorization

  helper_method :current_user
  helper_method :user_signed_in?

  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id].present?
  end

  def user_signed_in?
    !!current_user
  end

  private

  def user_not_authorized
    redirect_to (request.referer || root_path), alert: t('pundit.not_authorized')
  end
end
