# frozen_string_literal: true

module ApplicationHelper
  def get_flash_class_for(type)
    {
      success: 'alert-success',
      error: 'alert-danger',
      alert: 'alert-warning',
      notice: 'alert-info'
    }[type.to_sym]
  end

  def active_moderation
    params[:action] == 'index_moderated' ? ' active' : ''
  end

  def active_bulletins
    check = params[:action] != 'index_moderated' && params[:controller].include?('bulletins')
    check ? ' active' : ''
  end

  def active_categories
    params[:controller].include?('categories') ? ' active' : ''
  end
end
