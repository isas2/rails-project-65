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
end
