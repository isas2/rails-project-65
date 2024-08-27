# frozen_string_literal: true

class SetAdmin < ActiveRecord::Migration[7.1]
  def change
    User.find_by(email: 'is.as.001@yandex.ru')&.update(admin: true)
  end
end
