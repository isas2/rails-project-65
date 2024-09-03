# frozen_string_literal: true

class Web::AuthControllerTest < ActionDispatch::IntegrationTest
  test 'check github auth' do
    sign_in users(:one)
    assert_response :redirect
    assert signed_in?
  end

  test 'should create user' do
    auth_hash = {
      provider: 'github',
      uid: '12345',
      info: {
        email: Faker::Internet.email,
        name: Faker::Name.first_name
      }
    }
    OmniAuth.config.mock_auth[:github] = OmniAuth::AuthHash::InfoHash.new(auth_hash)
    get callback_auth_url('github')

    assert_response :redirect
    assert User.find_by(email: auth_hash[:info][:email].downcase)
    assert signed_in?
  end

  test 'check logout' do
    sign_in users(:one)
    delete logout_path
    assert_not signed_in?
  end
end
