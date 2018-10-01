class UsersController < ApplicationController

  before_action :authorize
  before_action :set_user, only: [:show, :edit, :update, :destroy]

  # GET /users
  def index
    @users = User.all
  end

  # GET /users/1
  def show
    redirect_to edit_user_url(@user)
  end

  # GET /users/new
  def new
    @user = User.new
    @current_user = current_user
  end

  # GET /users/1/edit
  def edit
    @current_user = current_user
  end

  # POST /users
  def create
    @user = User.new(user_params)

    if @user.save
      UserMailer.welcome_email(user: @user, invited_by: current_user).deliver_later

      redirect_to users_url, notice: 'User was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /users/1
  def update
    if user_params[:is_admin] && !@user.is_admin && !current_user.is_admin
      redirect_to edit_user_url(@user), notice: 'You must be an admin to promote users.'
      return false
    end

    if @user.update(user_params)
      redirect_to users_url, notice: 'User was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /users/1
  def destroy
    unless current_user.is_admin
      redirect_to edit_user_url(@user), notice: 'You must be an admin to delete users.'
      return false
    end

    @user.subscriptions.destroy_all
    @user.destroy
    redirect_to users_url, notice: 'User was successfully deleted.'
  end

  # DELETE /users/1/pages/6-some-page-title
  def unsubscribe
    user = User.find(params[:user_id])
    page_id = params[:page_id].split('-')[0].to_i
    page = Page.find(page_id)


    if user.id != current_user.id && !current_user.is_admin
      return redirect_to edit_user_url(user), error: "You don't have permission to edit this users subscriptions."
    end

    if !user.present? || !page.present?
      return redirect_to edit_user_url(user), error: "Something went wrong. User or page was not found."
    end

    user.unsubscribe(page)
    redirect_to edit_user_url(user), notice: 'Subscription successfully removed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def user_params
      params.require(:user).permit(:first_name, :last_name, :email, :is_admin)
    end
end
