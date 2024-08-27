# frozen_string_literal: true

module Web
  class BulletinsController < ApplicationController
    before_action :set_bulletin, only: %i[archive show edit to_moderate update]
    def index
      @search = Bulletin.ransack(params[:q])
      @bulletins = @search.result.published.page(params[:page]).per(20)
                          .includes(:user, :category).order(created_at: :desc)
    end

    def profile
      @search = current_user.bulletins.ransack(params[:q])
      @bulletins = @search.result.page(params[:page]).per(20)
                          .includes(:user, :category).order(created_at: :desc)
    end

    def to_moderate
      @bulletin.to_moderate!
      redirect_to profile_path, notice: t('.success')
    end

    def archive
      @bulletin.archive!
      redirect_to profile_path, notice: t('.success')
    end

    def show; end

    def new
      authorize Bulletin
      @bulletin = current_user.bulletins.build
    end

    def edit; end

    def create
      authorize Bulletin
      @bulletin = current_user.bulletins.build(bulletin_params)

      if @bulletin.save
        redirect_to bulletin_url(@bulletin), notice: t('.success')
      else
        render :new, status: :unprocessable_entity
      end
    end

    def update
      if @bulletin.update(bulletin_params)
        redirect_to bulletin_url(@bulletin), notice: t('.success')
      else
        render :edit, status: :unprocessable_entity
      end
    end

    private

    def set_bulletin
      @bulletin = Bulletin.find(params[:id])
      authorize @bulletin
    end

    def bulletin_params
      params.require(:bulletin).permit(:title, :description, :category_id, :image)
    end
  end
end
