# frozen_string_literal: true

module AuthConcern
  extend ActiveSupport::Concern

  def self.included(base)
    base.helper_method :current_user
    base.helper_method :user_signed_in?
  end

  def sign_in(user)
    session[:user_id] = user.id
  end

  def sign_out
    session.delete(:user_id)
    session.clear
  end

  def user_signed_in?
    current_user.present?
  end

  def current_user
    @current_user ||= User.find_by(id: session[:user_id])
  end
end
