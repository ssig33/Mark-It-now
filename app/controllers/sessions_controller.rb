class SessionsController < ApplicationController
  def index
  end

  def create
    if Misc.new.auth params[:user], params[:password]
      session[:login] = true
      session.map{|x|x}
      redirect_to controller: :page, action: :index
    else
      redirect_to action: :index   
    end
  end
end
