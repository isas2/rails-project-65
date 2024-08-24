# frozen_string_literal: true

module Web
  class BulletinsController < ApplicationController
    before_action :set_bulletin, only: %i[archive show edit to_moderate update]
    def index
      @bulletins = Bulletin.published.includes(:user, :category).order(created_at: :desc)
    end

    def profile
      @bulletins = current_user.bulletins.includes(:user, :category).order(created_at: :desc)
    end

    def to_moderate
      @bulletin.to_moderate!
      redirect_to profile_path, notice: "Bulletin was successfully sent to moderate."
    end

    def archive
      @bulletin.archive!
      redirect_to profile_path, notice: "Bulletin was successfully sent to archive."
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
        redirect_to bulletin_url(@bulletin), notice: "Bulletin was successfully created."
      else
        render :new, status: :unprocessable_entity
      end
    end

    def update
      if @bulletin.update(bulletin_params)
        redirect_to bulletin_url(@bulletin), notice: "Bulletin was successfully updated."
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
