class PageController < ApplicationController
  before_filter :login
  def index
    #Recent.order("id desc").offset(31).delete_all if Recent.count > 30
    @recents = Recent.includes(page: :comic).where(user_id: session[:user_id]).order("id desc").limit(25)+RecentAozora.where(user_id: session[:user_id]).order('id desc').limit(25) + RecentTxt.where(user_id: session[:user_id]).order("id desc").limit(25)
    @recents.each{|x| x.destroy if x.page == nil}
    @recents.sort!{|a,b| -a.created_at.to_i <=> -b.created_at.to_i}
  end

  def read
    @comic = Comic.find(params[:id])
    @comic.delay.create_cache
    @info = (Hash[*@comic.pages.map{|x| [(x.page+1).to_s, x.portlait]}.flatten]).to_json
    logger.debug render_to_string(layout:false)
    render layout:false if request.xhr?
  end

  def text
    @comic = Comic.find(params[:id])
    @txt = Txt.new(@comic.full_path).page(params[:page])
    RecentTxt.where(comic_id: params[:id]).destroy_all
    RecentTxt.create comic_id: params[:id], page: params[:page].to_i, user_id: session[:user_id]
    render layout:false if request.xhr?
  end

  def search
    raise unless request.xhr?
    @search = Comic.search(params[:id])
    render json: {html: render_to_string(layout: false), query: params[:id]}
  end

  def image
    @comic = Comic.find(params[:id])
    image, type, portlait = @comic.page params[:page]
    if type
      send_data image, type: type
    else
      redirect_to image and return
    end
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
    render json: {portlait: portlait} and return
  rescue
    render json: {portlait: false} and return
  end

  def scan
    Comic.scan
    redirect_to action: :index
  end

  def aozora
    Recent.includes(:page).where(user_id: session[:user_id], 'pages.comic_id' => params[:id]).destroy_all rescue nil
    RecentAozora.where(user_id: session[:user_id], comic_id: params[:id]).destroy_all rescue nil
    RecentAozora.create(user_id: session[:user_id], comic_id: params[:id], page: params[:page].to_i)
    @comic = Comic.find(params[:id])
    render layout: params[:remote]!='remote'
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
    Recent.includes(:page).where(user_id: session[:user_id], 'pages.comic_id' => params[:id]).destroy_all rescue nil
    RecentAozora.where(user_id: session[:user_id], comic_id: params[:id]).destroy_all rescue nil
    Recent.create page_id: Page.where(comic_id: params[:id], page: params[:page].to_i).first.id, user_id: session[:user_id]
    render json: {result: true}
  end
end
