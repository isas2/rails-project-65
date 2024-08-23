# frozen_string_literal: true

module Web
  module Admin
    class BulletinsController < ApplicationController
      before_action :authorize_admin
      # before_action :set_bulletin, only: %i[ show edit update destroy ]

      def index
        @bulletins = Bulletin.includes(:user, :category).order(created_at: :desc)
      end

      def index_moderated
        @bulletins = Bulletin.includes(:user, :category).order(created_at: :desc)
      end

      private

      def set_bulletin
        @bulletin = Bulletin.find(params[:id])
      end

      def bulletin_params
        params.require(:bulletin).permit(:title, :description, :user_id, :category_id, :image)
      end
    end
  end
end
