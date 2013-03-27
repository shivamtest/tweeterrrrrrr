helpers do 

	def get_consumer_token
		session[:oauth] ||= {}
		host = request.host
		host << ":9292" if request.host == "localhost"
	  consumer_key = ENV['TWITTER_KEY']
    consumer_secret = ENV['TWITTER_SECRET']
	  @consumer = OAuth::Consumer.new(consumer_key, consumer_secret, site: "http://api.twitter.com")
	end

	def get_request_token
		request_token = session[:oauth][:request_token]
		request_token_secret = session[:oauth][:request_token_secret]
		if request_token.nil? || request_token_secret.nil?
		  @request_token = @consumer.get_request_token(oauth_callback: "http://localhost:9292/auth")
		  session[:oauth][:request_token] = @request_token.token 
		  session[:oauth][:request_token_secret] = @request_token.secret
		 else
		 	@request_token = OAuth::RequestToken.new(@consumer, request_token, request_token_secret)
		 end
	end

	def get_access_token 
		access_token = session[:oauth][:access_token]
		access_token_secret = session[:oauth][:access_token_secret]
		unless access_token.nil? || access_token_secret.nil?
			@access_token = OAuth::AccessToken.new(@consumer, access_token, access_token_secret)
			 @client = Twitter::Client.new(consumer_key: ENV['TWITTER_KEY'],
     																consumer_secret: ENV['TWITTER_SECRET'],
	    														oauth_token: access_token,
	    													  oauth_token_secret: access_token_secret,
	    													  :endpoint => "http://api.twitter.com")
		end
		@client
	end


	def store_access_token
		access_token = @request_token.get_access_token(oauth_verifier: request.params[:oauth_verifier])
		session[:oauth][:access_token] = access_token.token 
		session[:oauth][:access_token_secret] = access_token.secret
	end
	def client
		@client
	end
end