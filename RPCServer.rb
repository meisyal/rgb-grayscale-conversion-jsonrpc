require 'jimson'
require 'base64'
require 'mini_magick'

class MyHandler
  extend Jimson::Handler

  def convert(data, file)
    # edit temporary path as you want
    temppath = 'your/temporary/path/here'
    # decode received data from base64
    File.open(temppath + file, 'wb') do |f|
      f.write(Base64.decode64(data))
    end
    # convert to grayscape using ImageMagick and RMagick
    image = MiniMagick::Image.open(temppath + file)
    image = image.colorspace("Gray")
    image.write(temppath + file)

    # encode converted image
    f = File.open(temppath + file, "rb")
    contents = Base64.encode64(f.read)
    f.close

    receive = contents
  end
end

server = Jimson::Server.new(MyHandler.new)
server.start # serve with webrick on http://0.0.0.0:8999/
