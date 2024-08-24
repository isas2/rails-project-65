# frozen_string_literal: true

module Web
  module Admin
    class BulletinsController < ApplicationController
      before_action :authorize_admin
      before_action :set_bulletin, only: %i[archive reject publish]

      def index
        @bulletins = Bulletin.includes(:user, :category).order(created_at: :desc)
        @back_to_page = admin_bulletins_path
      end

      def index_moderated
        @bulletins = Bulletin.under_moderation.includes(:user, :category).order(created_at: :desc)
        @back_to_page = admin_root_path
      end

      def archive
        @bulletin.archive!
        redirect_to params[:back_to] || admin_root_path, notice: "Bulletin was successfully sent to archive."
      end

      def reject
        @bulletin.reject!
        redirect_to admin_root_path, notice: "Bulletin was successfully rejected."
      end

      def publish
        @bulletin.publish!
        redirect_to admin_root_path, notice: "Bulletin was successfully published."
      end

      private

      def set_bulletin
        @bulletin = Bulletin.find(params[:id])
      end
    end
  end
end
