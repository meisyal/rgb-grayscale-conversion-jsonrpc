require 'jimson'
require 'base64'
require 'mini_magick'

class MyHandler
  extend Jimson::Handler

  def convert(data, file)
    # print the time when image is sent
    puts "Image received #{Time.now}"

    # decode received data from base64 and
    # convert to grayscape using ImageMagick and RMagick
    image = MiniMagick::Image.read(Base64.decode64(data))
    image = image.colorspace("Gray")

    # encode converted image (blob)
    contents = Base64.encode64(image.to_blob)
    puts "Image sent #{Time.now}"
    receive = contents
  end
end

server = Jimson::Server.new(MyHandler.new)
server.start # serve with webrick on http://0.0.0.0:8999/
