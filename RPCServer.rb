require 'jimson'

class MyHandler
  extend Jimson::Handler

  def convert(data)
    receive = data
  end
end

server = Jimson::Server.new(MyHandler.new)
server.start # serve with webrick on http://0.0.0.0:8999/
