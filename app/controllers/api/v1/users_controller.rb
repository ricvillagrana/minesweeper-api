class Api::V1::UsersController < ApplicationController
  # GET /api/v1/users
  #
  # returns an object with key +users+ containing an array of users.
  def index
    render json: { users: User.all }
  end

  # GET /api/v1/users/:id
  #
  # returns an object with key +user+ containing an user.
  def show
    render json: { user: User.find(params[:id]) }
  end

  # POST /api/v1/users
  #
  # receives an user object and creates it,
  # returns an object with key +user+ containing the created user.
  def create
    @user = User.create(user_params)

    render json: { user: @user }
  end

  # PUT /api/v1/users/:id
  #
  # receives an user object and updates it by its id,
  # returns an object with key +user+ containing the updated user.
  def update
    @user = User.find(params[:id])

    if @user.update!(user_params)
      render json: { user: @user }
    else
      render json: { errors: @user.errors }, status: :bad_request
    end
  end

  # DELETE /api/v1/users/:id
  #
  # receives an user id and destroys it by its id,
  # returns an object with key +user+ containing the deleted user.
  def destroy
    @user = User.find(params[:id])

    if @user.destroy
      render json: { user: @user }
    else
      render json: { errors: @user.errors }, status: :bad_request
    end
  end

  private

  def user_params
    params
      .require(:user)
      .permit(:name, :username)
  end
end
