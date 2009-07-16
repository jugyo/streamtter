require 'rubygems'
require "socket"
require 'base64'
require 'json'

class Streamtter
  attr_accessor :username, :password

  def self.start(*args, &block)
    self.new(*args).start(&block)
  end

  def initialize(username, password)
    @username = username
    @password = password
  end

  def start(&block)
    s = TCPSocket.open("stream.twitter.com", 80)
    auth = Base64.encode64("#{username}:#{password}")
    s.write <<-EOS
GET /spritzer.json HTTP/1.1
Host: stream.twitter.com
Authorization: Basic #{auth}
    EOS

    begin
      while str = s.gets
        json = JSON.parse(str) rescue nil
        block.call(json) if json
      end
    ensure
      s.close
    end
  end
end
