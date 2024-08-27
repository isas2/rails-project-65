# frozen_string_literal: true

require 'test_helper'

class Web::Admin::CategoriesControllerTest < ActionDispatch::IntegrationTest
  setup do
    sign_in users(:admin)
    @category = categories(:one)
    @attrs = { name: Faker::Restaurant.unique.type }
  end

  test 'should get index' do
    get admin_categories_url
    assert_response :success
  end

  test 'should get new' do
    get new_admin_category_url
    assert_response :success
  end

  test 'should create category' do
    assert_difference('Category.count') do
      post admin_categories_url, params: { category: @attrs }
    end

    assert_not_nil Category.find_by(@attrs)
  end

  test 'should get edit' do
    get edit_admin_category_url(@category)
    assert_response :success
  end

  test 'should update category' do
    patch admin_category_url(@category), params: { category: @attrs }
    assert_not_equal Category.find(@category.id).name, @category.name
  end

  test 'should destroy category' do
    category = categories(:two)
    assert_difference('Category.count', -1) do
      delete admin_category_url(category)
    end

    assert_nil Category.find_by(id: category.id)
  end
end
