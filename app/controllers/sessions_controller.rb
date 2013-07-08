class SessionsController < ApplicationController
  def index
  end

  def create
    if Misc.new.auth params[:password]
      session[:login] = true
      session[:user_id] = params[:user]
      session
      redirect_to controller: :page, action: :index
    else
      redirect_to action: :index   
    end
  end

  def destroy
    session[:login] = nil
    session[:user_id] = nil
    redirect_to action: :index
  end
end
