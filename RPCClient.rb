require 'jimson'
require 'base64'

def count_files(filepath)
  count = Dir[filepath].length
end

def file_name(file)
  result = file.split('.')[0]
end

def file_extensions(file)
  File.extname(file).delete('.')
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

# add time start
start = Time.now

Dir.foreach(imagepath) do |file|
  # skip reading the parent and current directories
  next if file == '.' or file == '..'
  # encode binary file to base64
  data = encode(imagepath + file)
  # call the 'convert' method on the RPC server and save the result
  conversion = client.convert(data, file)
  # write log on terminal
  puts "#{file} has been sent successfully"
  # get file name without extensions
  filename = file_name(file)
  # get file extensions
  extensions = file_extensions(file)
  # decode received data from base64
  File.open(destinationpath + filename + "_grayscale." + extensions, 'wb') do |f|
    f.write(Base64.decode64(conversion))
  end
end

# add time finish and calculate
finish = Time.now
difference = finish - start
# print total time
puts "Total time #{difference} seconds"
