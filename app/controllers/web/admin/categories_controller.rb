# frozen_string_literal: true

module Web
  module Admin
    class CategoriesController < ApplicationController
      before_action :authorize_admin
      before_action :set_category, only: %i[edit update destroy]

      def index
        @categories = Category.order(name: :asc)
      end

      def new
        @category = Category.new
      end

      def edit; end

      def create
        @category = Category.new(category_params)

        if @category.save
          redirect_to admin_categories_url, notice: t('.success')
        else
          render :new, status: :unprocessable_entity
        end
      end

      def update
        if @category.update(category_params)
          redirect_to admin_categories_url, notice: t('.success')
        else
          render :edit, status: :unprocessable_entity
        end
      end

      def destroy
        @category.destroy!
        redirect_to admin_categories_url, notice: t('.success')
      rescue ActiveRecord::DeleteRestrictionError
        redirect_to admin_categories_url, flash: { error: t('.error') }
      end

      private

      def set_category
        @category = Category.find(params[:id])
      end

      def category_params
        params.require(:category).permit(:name)
      end
    end
  end
end
