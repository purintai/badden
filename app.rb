require 'bundler'
Bundler.require

class App < Sinatra::Base
  configure :development do
    register Sinatra::Reloader
  end

  before do
    Redis.current.lpush('access', "#{Time.now.iso8601} : #{request.fullpath}")
  end

  get '/*' do
    @access_logs = Redis.current.lrange('access', 0, 20)
    haml :index
  end
end
