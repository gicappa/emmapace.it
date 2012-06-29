class FlickrService 
	def initialize()
		FlickRaw.api_key="99bfacd3697b8d869b4c0e4cf24b5da0"
		FlickRaw.shared_secret="ce8b9d7cd6884799"


	end
	
	def connected?
		true
	end
	
	def fetch_photos
		list   = flickr.photos.getRecent
		photos = []
		list.each_with_index do |photo,i|
			photoInfo = flickr.photos.getInfo(:photo_id => photo.id, :secret => photo.secret)
			photos << FlickRaw.url_b(photoInfo)
			break if i == 4
		end
		photos
	end

end