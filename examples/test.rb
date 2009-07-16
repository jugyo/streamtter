#!/usr/bin/env ruby

$: << File.dirname(__FILE__) + '/../lib'
require 'streamtter'

username, password = *ARGV[0..1]
Streamtter.start(username, password) do |json|
  p json
end
