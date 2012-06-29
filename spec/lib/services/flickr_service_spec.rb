require 'spec_helper'

describe FlickrService do
	it "connects to flickr" do
	  FlickrService.new.should be_connected
	end

	it "fetches images" do
	  FlickrService.new.fetch_photos.should_not be_empty
	end
end
