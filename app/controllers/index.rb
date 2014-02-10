require 'debugger'

get '/' do
  erb :index
end

get '/:username' do
  erb :user_tweets
end

post '/tweets' do
  u = CLIENT.user(params["username"])
  @user = TwitterUser.find_or_create_by(username: u.username)
  if @user.tweets.empty? || @user.tweets_stale?
    @user.fetch_tweets!
  end
  @tweets = @user.tweets.order(created_at: :asc)
  erb :_tweets
end
