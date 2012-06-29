require 'spec_helper'

describe FlickrService do
	it "connects to flickr" do
	  FlickrService.new.should be_connected
	end
end
