class PageViewsController < ApplicationController
  def index
  end

  def top_urls
    # binding.pry
    render json: PageView.top_urls
  end

  def top_referrers
    render json: PageView.top_referrers
  end
end
