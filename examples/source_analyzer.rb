#!/usr/bin/env ruby

require 'rubygems'
require 'sequel'
$: << File.dirname(__FILE__) + '/../lib'
require 'streamtter'

DB = Sequel.sqlite("#{Dir.pwd}/source_analyzer.db")
unless DB.table_exists?(:logs)
  DB.create_table :logs do
    [:status_id, :app_name, :app_url, :user_id, :user_name].each do |name|
      String name
    end
  end
end

username, password = *ARGV[0..1]
Streamtter.start(username, password) do |status|
  if /<a href="(.*)?">(.*)?<\/a>/ =~ status['source']
    app_url, app_name = $1, $2
    DB[:logs] << {
      :status_id => status['id'],
      :app_name => app_name,
      :app_url => app_url,
      :user_id => status['user']['id'],
      :user_name => status['user']['screen_name']
    }
  end
end
