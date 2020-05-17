require 'test_helper'

class Api::V1::UsersControllerTest < ActionDispatch::IntegrationTest
  test 'GET /users succeed' do
    get api_v1_users_url
    assert_response :success
    assert_equal(response.parsed_body['users'].count, User.count)
  end

  test 'GET /users response contain same amount of users than the model' do
    get api_v1_users_url
    assert_equal(response.parsed_body['users'].count, User.count)
  end

  test 'GET /users/:id response with the correct user' do
    user = User.all.sample

    get api_v1_user_url(user.id)
    assert_equal(response.parsed_body['user']['id'], user.id)
  end

  test 'POST /users/ response with the created user' do
    user = { name: 'John Doe', username: 'jdoe' }

    post api_v1_users_url, params: { user: user }
    assert_equal(response.parsed_body['user']['id'], User.find_by(username: 'jdoe').id)
  end

  test 'PUT /users/:id response with the updated user' do
    user        = User.all.sample
    user_params = { name: 'John Doe Perez' }

    put api_v1_user_url(user.id), params: { user: user_params }
    assert_equal(response.parsed_body['user']['name'], user_params[:name])
    assert_equal(User.find(user.id).name, user_params[:name])
  end

  test 'PUT /users/:id with nil name and response with error' do
    user        = User.all.sample
    user_params = { name: nil }

    put api_v1_user_url(user.id), params: { user: user_params }
    assert_response :bad_request
    assert_equal(response.parsed_body['errors']['name'].first, 'can\'t be blank')
  end

  test 'DELETE /users/:id deletes the user' do
    user = User.create(name: 'John', username: 'unique_one')

    delete api_v1_user_url(user.id)
    assert_equal(response.parsed_body['user']['name'], user.name)
  end
end
