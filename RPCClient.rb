require 'jimson'
require 'base64'

def count_files(filepath)
  count = Dir[filepath].length
end

def file_extensions(filename)
  File.extname(filename).delete('.')
end

def encode(filepath)
  f = File.open(filepath, "rb")
  contents = Base64.encode64(f.read)
  f.close

  return contents
end

client = Jimson::Client.new("http://www.example.com:8999") # the URL for the JSON-RPC 2.0 server to connect to

imagepath = 'your/image/path/here'
destinationpath = 'your/destination/image/path/here'

Dir.foreach(imagepath) do |filename|
  # skip reading the parent and current directories
  next if filename == '.' or filename == '..'
  # encode binary file to base64
  data = encode(imagepath + filename)
  # call the 'convert' method on the RPC server and save the result
  result = client.convert(data, filename)
  # write log on terminal
  puts filename
  # decode received data from base64
  File.open(destinationpath + "grayscale_" + filename, 'wb') do |f|
    f.write(Base64.decode64(result))
  end
end
