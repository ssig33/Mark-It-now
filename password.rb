#!/usr/bin/env ruby
require 'digest/sha1'
require 'yaml'
print 'Input your user name: '
name = gets.chomp
print 'Input your password: '
str = gets.chomp
salt = rand(256**16).to_s(16) + rand(256**16).to_s(16)
10000.times{str = Digest::SHA1.hexdigest("--#{salt}--#{str}--")}
password = str

config = YAML.load_file("config/config.yml") rescue {}
config['users'] = {} unless config['users']
config['users'].merge!({name => {'password' => password, 'salt' => salt}})

YAML.dump config, open("config/config.yml", 'w')
