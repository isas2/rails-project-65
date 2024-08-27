# frozen_string_literal: true

require 'test_helper'

class Web::BulletinsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @bulletin = bulletins(:one)
    sign_in users(:one)
    @attrs = {
      title: Faker::Restaurant.name,
      description: Faker::Restaurant.description.truncate(1000),
      category_id: categories(:two).id,
      image: fixture_file_upload('file2.png', 'image/png')
    }
  end

  test 'should get index' do
    get bulletins_url
    assert_response :success
  end

  test 'should get new' do
    get new_bulletin_url
    assert_response :success
  end

  test 'should create bulletin' do
    assert_difference('Bulletin.count') do
      post bulletins_url, params: { bulletin: @attrs }
    end

    bulletin = Bulletin.find_by(@attrs.except(:image))
    assert_not_nil bulletin
    assert_have_state bulletin, :draft, on: :state
  end

  test 'should show bulletin' do
    get bulletin_url(@bulletin)
    assert_response :success
  end

  test 'should get edit' do
    get edit_bulletin_url(@bulletin)
    assert_response :success
  end

  test 'should update bulletin' do
    patch bulletin_url(@bulletin), params: { bulletin: @attrs }

    assert_not_equal Bulletin.find_by(@attrs.except(:image)).category, @bulletin.category
  end

  test 'should to_moderete bulletin' do
    patch to_moderate_bulletin_path(@bulletin)
    @bulletin.reload
    assert_have_state @bulletin, :under_moderation, on: :state
  end

  test 'should archived bulletin' do
    patch archive_bulletin_path(@bulletin)
    @bulletin.reload
    assert_have_state @bulletin, :archived, on: :state
  end
end
