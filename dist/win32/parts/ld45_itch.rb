#encoding: UTF-8
#!/usr/bin/env ruby

require 'gosu'
require 'require_all'
require 'crack'
require 'fileutils'

APP_ROOT = File.dirname(__FILE__)
SOURCE_ROOT = File.join(APP_ROOT,'src')
MEDIA_ROOT = File.join(APP_ROOT,'media')
DATA_ROOT = File.join(APP_ROOT,'data')
SETTINGS_DIR = File.join(ENV['APPDATA'],'strangeness')

FileUtils.mkdir_p SETTINGS_DIR unless File.directory?(SETTINGS_DIR)

SETTINGS_FILE = File.join(SETTINGS_DIR,'settings.yml')

require_all File.join(File.dirname(__FILE__),'src')

Game.play! #unless defined?(Ocra)