class InvitesController < ApplicationController
  def new
    @user = User.find_by(invite_token: params[:token])
    unless params[:token].present? && @user.present?
      redirect_to root_path, error: 'Invalid invitation code'
    end
  end

  def create
    @user = User.find_by(invite_token: params[:user][:token])
    if @user && @user.update(user_params)
      @user.update_columns(invite_token: nil, accepted_invite_at: Time.current)
      sign_in(@user)
      flash[:success] = 'Invite accepted. Welcome to Hotwired ATS!'
      redirect_to root_path
    else
      render :new
    end
  end

  private

  def user_params
    params.require(:user).permit(:first_name, :last_name, :password)
  end
end