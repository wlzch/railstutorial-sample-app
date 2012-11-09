class UsersController < ApplicationController
  include SessionsHelper
  before_filter :signed_in_user, only: [:index, :edit, :update, :destroy]
  before_filter :cannot_register, only: [:new, :create]
  before_filter :correct_user, only: [:edit, :update]
  before_filter :admin_user, only: :destroy

  def index
    @users = User.paginate(page: params[:page])
  end

  def new
    @user = User.new
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user and not params[:user].nil? and @user.authenticate(params[:user][:password])
      if @user.update_attributes(params[:user])
        sign_in @user
        flash[:success] = 'You have successfully updated your profile'
        redirect_to @user
      else
        render 'edit'
      end
    else 
      flash[:error] = "Password doesn't match"
      render 'edit'
    end
  end

  def show
    @user = User.find(params[:id])
    @microposts = @user.microposts.paginate(page: params[:page])
  end

  def create
    @user = User.new(params[:user])
    if @user.save
      sign_in @user
      flash[:success] = 'Welcome to the Sample App'
      redirect_to @user
    else
      render 'new'
    end
  end

  def destroy
    @user = User.find(params[:id])
    if @user.admin?
      flash[:error] = 'User cannot be deleted'
    else
      @user.destroy
      flash[:success] = 'User destroyed.'
    end
    redirect_to users_url
  end

  private
    def cannot_register
      if signed_in?
        redirect_to root_path
      end
    end

    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_path) unless current_user?(@user)
    end

    def admin_user
      redirect_to root_path unless current_user.admin?
    end

end
