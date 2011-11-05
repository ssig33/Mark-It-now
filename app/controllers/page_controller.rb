class PageController < ApplicationController
  before_filter :login
  def index
    #Recent.order("id desc").offset(31).delete_all if Recent.count > 30
    @recents = Recent.includes(page: :comic).order("id desc").limit(50)
  end

  def read
    @comic = Comic.find(params[:id])
    render layout:false if request.xhr?
  end

  def search
    raise unless request.xhr?
    @search = Comic.search(params[:id])
    render json: {html: render_to_string(layout: false)}
  end

  def image
    @comic = Comic.find(params[:id])
    image, type, portlait = @comic.page params[:page]
    send_data image, type: type
  end

  def img_from_name
    logger.debug params
    @comic = Comic.find(params[:id])
    image, type, portlait = @comic.from_name(params[:name])
    send_data image, type: type
  end

  
  def info
    comic = Comic.find(params[:id])
    portlait = comic.pages.where(page: params[:page].to_i-1).first.portlait
    render json: {portlait: portlait}
  end

  def scan
    Comic.scan
    redirect_to action: :index
  end

  def aozora
    @comic = Comic.find(params[:id])
  end

  def change_bound
    comic = Comic.find(params[:id])
    if comic.left
      comic.left = nil
    else
      comic.left = true
    end
    comic.save
    render json: {result: true}
  end

  def save_recent
    Recent.includes(:page).where('pages.comic_id' => params[:id]).destroy_all rescue nil
    Recent.create page_id: Page.where(comic_id: params[:id], page: params[:page].to_i).first.id
    render json: {result: true}
  end
end
