class MicropostsController < ApplicationController
  include SessionsHelper
  
  before_filter :signed_in_user, only: [:create, :destroy]
  before_filter :correct_user, only: [:destroy]

  def create
    @micropost = current_user.microposts.build(params[:micropost])
    if @micropost.save
      flash[:success] = "Micropost created!"
      redirect_to root_url
    else
      @feed_items = []
      render 'static_pages/home'
    end
  end

  def destroy
    if @micropost.destroy
      flash[:success] = "Micropost destroyed"
    else
      flash[:error] = "Micropost not destroyed"
    end
    redirect_to root_url
  end

  private
    def correct_user
      @micropost = current_user.microposts.find_by_id(params[:id])
      redirect_to root_url if @micropost.nil?
    end

end
