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
  end

  # GET /users/1/edit
  def edit
  end

  # POST /users
  def create
    @user = User.new(user_params)

    user_domain = @user.email.strip.split('@')[-1].downcase

    approved_domains = (ENV['APPROVED_USER_DOMAINS'] || '').strip.downcase.split(',')
    approve_any_domain = approved_domains.length == 0
    domain_is_approved = approved_domains.include?(user_domain)

    if approve_any_domain or domain_is_approved
      if @user.save
        UserMailer.welcome_email(user: @user, invited_by: current_user).deliver_later
        redirect_to users_url, notice: 'User was successfully created.'
      else
        render :new
      end
    else
      redirect_to users_url, notice: 'User\'s email address belongs to non-approved domain.'
    end

  end

  # PATCH/PUT /users/1
  def update
    if @user.update(user_params)
      redirect_to users_url, notice: 'User was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /users/1
  def destroy
    @user.destroy
    redirect_to users_url, notice: 'User was successfully deleted.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def user_params
      params.require(:user).permit(:first_name, :last_name, :email)
    end
end
