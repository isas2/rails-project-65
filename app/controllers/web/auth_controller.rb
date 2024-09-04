# frozen_string_literal: true

module Web
  class AuthController < ApplicationController
    def callback
      auth = request.env['omniauth.auth']
      name = auth.info['name'] || auth.info['nickname']
      # user = User.find_or_initialize_by(github_uid: auth['uid'])
      # user.name = auth.info['name'] || auth.info['nickname']
      # user.email = auth.info['email']
      # user.save
      user = User.find_or_create_by(email: auth.info['email'], name:)
      sign_in(user) if user.persisted?
      redirect_to root_path, notice: t('.success')
    end

    def delete
      sign_out
      redirect_to root_path, notice: t('.success')
    end
  end
end
