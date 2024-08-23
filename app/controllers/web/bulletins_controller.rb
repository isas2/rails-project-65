# frozen_string_literal: true

module Web
  class BulletinsController < ApplicationController
    before_action :set_bulletin, only: %i[show edit update]
    def index
      @bulletins = Bulletin.includes(:user, :category).order(created_at: :desc)
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

      respond_to do |format|
        if @bulletin.save
          format.html { redirect_to bulletin_url(@bulletin), notice: "Bulletin was successfully created." }
          format.json { render :show, status: :created, location: @bulletin }
        else
          format.html { render :new, status: :unprocessable_entity }
          format.json { render json: @bulletin.errors, status: :unprocessable_entity }
        end
      end
    end

    def update
      respond_to do |format|
        if @bulletin.update(bulletin_params)
          format.html { redirect_to bulletin_url(@bulletin), notice: "Bulletin was successfully updated." }
          format.json { render :show, status: :ok, location: @bulletin }
        else
          format.html { render :edit, status: :unprocessable_entity }
          format.json { render json: @bulletin.errors, status: :unprocessable_entity }
        end
      end
    end

    private

    def set_bulletin
      @bulletin = Bulletin.find(params[:id])
      authorize @bulletin
    end

    def bulletin_params
      params.require(:bulletin).permit(:title, :description, :user_id, :category_id, :image)
    end
  end
end
