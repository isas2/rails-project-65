# frozen_string_literal: true

module Web
  module Admin
    class BulletinsController < ApplicationController
      before_action :authorize_admin
      before_action :set_bulletin, only: %i[archive reject publish]

      def index
        @search = Bulletin.ransack(params[:q])
        @bulletins = @search.result.page(params[:page]).per(20)
                            .order(created_at: :desc)
        @back_to_page = admin_bulletins_path
      end

      def index_moderated
        @bulletins = Bulletin.under_moderation.page(params[:page]).per(20)
                             .order(created_at: :desc)
        @back_to_page = admin_root_path
      end

      def archive
        if @bulletin.may_archive?
          @bulletin.archive!
          redirect_to params[:back_to] || admin_root_path, notice: t('.success')
        else
          redirect_to params[:back_to] || admin_root_path, flash: { error: t('.error') }
        end
      end

      def reject
        if @bulletin.may_reject?
          @bulletin.reject!
          redirect_to admin_root_path, notice: t('.success')
        else
          redirect_to admin_root_path, flash: { error: t('.error') }
        end
      end

      def publish
        if @bulletin.may_publish?
          @bulletin.publish!
          redirect_to admin_root_path, notice: t('.success')
        else
          redirect_to admin_root_path, flash: { error: t('.error') }
        end
      end

      private

      def set_bulletin
        @bulletin = Bulletin.find(params[:id])
      end
    end
  end
end
