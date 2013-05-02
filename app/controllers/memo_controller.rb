class MemoController < ApplicationController
  def get_memo
    c = Comic.where(id: params[:id]).first.pages.where(page: params[:page]).first
    render text: c.memo
  end

  def post_memo
    c = Comic.where(id: params[:id]).first.pages.where(page: params[:page]).first
    c.memo = params[:memo]
    c.save
    render text: true
  end
end
