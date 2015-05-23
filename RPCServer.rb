require 'jimson'
require 'base64'
require 'mini_magick'

class MyHandler
  extend Jimson::Handler

  def convert(data, filename)
    # edit temporary path as you want
    temppath = 'your/temporary/path/here'
    # decode received data from base64
    File.open(temppath + filename, 'wb') do |file|
      file.write(Base64.decode64(data))
    end
    # convert to grayscape using ImageMagick and RMagick
    image = MiniMagick::Image.open(temppath + filename)
    image = image.colorspace("Gray")
    image.write(temppath + filename)

    # encode converted image
    f = File.open(temppath + filename, "rb")
    contents = Base64.encode64(f.read)
    f.close

    receive = contents
  end
end

server = Jimson::Server.new(MyHandler.new)
server.start # serve with webrick on http://0.0.0.0:8999/
