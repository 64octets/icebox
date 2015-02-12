class LinksController < ApplicationController
  def index
    @links = Link.all
  end

  def new
    @link = Link.new
  end

  def show
    @link = Link.find(params[:id])
  end

  def create
    @link = Link.new(link_params)
    doc = Scraper.new(url: @link.url)
    @link.title = doc.title
    @link.body = doc.body
    if @link.save
      flash[:notice] = 'Link was successfully created'
      redirect_to links_path
    else
      flash.now[:error] = 'Something went wrong, please try again'
      render :new
    end
  end

  private

    def link_params
      params.require(:link).permit(:url)
    end
end
