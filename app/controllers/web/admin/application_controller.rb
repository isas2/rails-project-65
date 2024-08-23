# frozen_string_literal: true

module Web
  class Admin::ApplicationController < ApplicationController
    def authorize_admin
      authorize :admin, :permit?
    end
  end
end
