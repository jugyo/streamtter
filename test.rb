require 'rubygems'
require "socket"
require 'base64'
require 'json'
 
username, password = *ARGV[0..1]
 
s = TCPSocket.open("stream.twitter.com", 80)
auth = Base64.b64encode("#{username}:#{password}")
s.write <<EOS
GET /spritzer.json HTTP/1.1
Host: stream.twitter.com
Authorization: Basic #{auth}
EOS
 
begin
  while str = s.gets
    json = JSON.parse(str) rescue nil
    p json if json
  end
ensure
  s.close
end
