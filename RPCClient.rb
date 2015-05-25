require 'jimson'
require 'base64'
require 'thread'

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

# define worker here
client_array = Array.new
client_array << Jimson::Client.new("http://www.example.com:8999") # the URL for the JSON-RPC 2.0 server to connect to

# define source and destination path
imagepath = 'your/image/path/here'
destinationpath = 'your/destination/image/path/here'

# add time start
start = Time.now

# create an item queue
item_queue = Queue.new
# read file on directory and push them to queue
Dir.foreach(imagepath) do |i|
  # skip reading the parent and current directories
  next if i == '.' or i == '..'
  item_queue.push(i)
end

# create a thread array
thread_array = Array.new

# start worker using thread
client_array.each do |client|
  new_thread = Thread.new do
    # loop until there are no more things to do
    until item_queue.empty?
      # pop with the non-blocking flag set, this raises
      # an exception if the queue is empty, in which case
      # item will be set to nil
      item = item_queue.pop(true) rescue nil
      if item
        # write log on terminal
        puts item
        # encode binary file to base64
        data = encode(imagepath + item)
        conversion = client.convert(data)
        # write log on terminal if image has been sent
        puts "#{item} has been sent successfully"
        # get file name without extensions
        filename = file_name(item)
        # get file extensions
        extensions = file_extensions(item)
        # decode received data from base64
        File.open(destinationpath + filename + "_grayscale." + extensions, 'wb') do |f|
          f.write(Base64.decode64(conversion))
        end
      end
    end
  end
  thread_array << new_thread
end

# synchronize all threads
thread_array.each { |t| t.join }

# add time finish and calculate
finish = Time.now
difference = finish - start
# print total time
puts "Total time #{difference} seconds"
