class ApiController < ApplicationController
  def create_cache
    Comic.find(params[:id]).delay.create_cache
    render text: 'true'
  end
end
