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

  def check_active(controller, moderated: false)
    check = if moderated
              params[:action] == 'index_moderated'
            else
              params[:action] != 'index_moderated' && params[:controller].include?(controller)
            end
    check ? ' active' : ''
  end
end
