# frozen_string_literal: true

module Web
  class AuthController < ApplicationController
    def callback
      auth = request.env['omniauth.auth']
      name = auth.info['name'] || auth.info['nickname']
      email = auth.info['email']
      github_uid = auth['uid']

      user = User.find_by(github_uid:)
      user ||= User.create(github_uid:, email:, name:)
      user.update(email:, name:) if user.email != email || user.name != name
      sign_in(user) if user.persisted?
      redirect_to root_path
    end

    def delete
      sign_out
      redirect_to root_path
    end
  end
end
