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


require 'flickraw'

FlickRaw.api_key="... Your API key ..."
FlickRaw.shared_secret="... Your shared secret ..."

token = flickr.get_request_token
auth_url = flickr.get_authorize_url(token['oauth_token'], :perms => 'delete')

puts "Open this url in your process to complete the authication process : #{auth_url}"
puts "Copy here the number given when you complete the process."
verify = gets.strip

begin
  flickr.get_access_token(token['oauth_token'], token['oauth_token_secret'], verify)
  login = flickr.test.login
  puts "You are now authenticated as #{login.username} with token #{flickr.access_token} and secret #{flickr.access_secret}"
rescue FlickRaw::FailedResponse => e
  puts "Authentication failed : #{e.msg}"
end