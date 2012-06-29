class HomeController < ApplicationController
  def index
  	@photos = FlickrService.new.fetch_photos
  end
end
