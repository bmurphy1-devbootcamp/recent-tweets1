require 'pry'

get '/' do
  erb :index
end

get '/:username' do
  u = CLIENT.user(params[:username])
  @user = TwitterUser.find_or_create_by(username: u.username)
  if @user.tweets.empty? || @user.tweets_stale?
    @user.fetch_tweets!
  end
  @tweets = @user.tweets.order(created_at: :asc).limit(10)
  erb :tweets
end

