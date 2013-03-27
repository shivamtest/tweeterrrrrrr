before do 
	get_consumer_token 
	get_request_token
	get_access_token
end


get '/' do
  # Look in app/views/index.erb
  erb :index
end



get '/request' do 
	redirect @request_token.authorize_url
end


get '/auth' do 
	store_access_token
	redirect '/'
end

post '/tweet' do 
	client.update(params[:tweet])
	redirect ('/')
end



helpers do 
	module Twitter
  class Client
    def connection
      @connection ||= Faraday.new(@endpoint, @connection_options.merge(:builder => @middleware)) do |f|
        f.headers = { "Connection" => "" }
      end
    end 
  end
end
end