# frozen_string_literal: true

require 'test_helper'

class Web::Admin::BulletinsControllerTest < ActionDispatch::IntegrationTest
  setup do
    sign_in users(:admin)
    @bulletin = bulletins(:one)
  end

  test 'should get admin index' do
    get admin_bulletins_url
    assert_response :success
  end

  test 'should get admin moderated' do
    get admin_root_path
    assert_response :success
  end

  test 'should admin archived bulletin' do
    patch archive_admin_bulletin_path(@bulletin)
    @bulletin.reload
    assert_have_state @bulletin, :archived, on: :state
  end

  test 'should admin rejected bulletin' do
    @bulletin.to_moderate!

    patch reject_admin_bulletin_path(@bulletin)
    @bulletin.reload
    assert_have_state @bulletin, :rejected, on: :state
  end

  test 'should admin published bulletin' do
    @bulletin.to_moderate!

    patch publish_admin_bulletin_path(@bulletin)
    @bulletin.reload
    assert_have_state @bulletin, :published, on: :state
  end
end
