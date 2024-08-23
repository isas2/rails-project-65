# frozen_string_literal: true

require 'test_helper'

class BulletinsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @bulletin = bulletins(:one)
    sign_in users(:admin)
    @attrs = {
      title: Faker::Restaurant.name,
      description: Faker::Restaurant.description,
      user_id: users(:two).id,
      category_id: categories(:two).id,
      image: fixture_file_upload('file1.jpg', 'image/jpg')
    }
  end

  # test "should get index" do
  #   get bulletins_url
  #   assert_response :success
  # end
  #
  # test "should update bulletin" do
  #   patch bulletin_url(@bulletin), params: { bulletin: @attrs }
  #   assert_redirected_to bulletin_url(@bulletin)
  # end
end
