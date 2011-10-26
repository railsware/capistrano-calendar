require 'capistrano'
require 'capistrano/calendar/client'

require 'yaml'

module Helper
  def self.load_credentials!
    @credentials = YAML.load_file('.credentials.yml')
  rescue  Errno::ENOENT => e
    puts "Put your credentials into '.credentials.yml'. Example:"
    puts({ 
      :google => {
        :username => 'vasya.pukin@gmail.com',
        :password => '123456'
      }
    }.to_yaml)

    exit(1)
  end

  def self.credentials
    @credentials
  end
end

Helper.load_credentials!
