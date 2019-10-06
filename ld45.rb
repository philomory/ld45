#!/usr/bin/env ruby

require 'bundler/setup'

Bundler.require(:default)

APP_ROOT = File.dirname(__FILE__)
SOURCE_ROOT = File.join(APP_ROOT,'src')
MEDIA_ROOT = File.join(APP_ROOT,'media')
DATA_ROOT = File.join(APP_ROOT,'data')
SETTINGS_FILE = File.join(APP_ROOT,'settings.yml')

require_all File.join(File.dirname(__FILE__),'src')

Game.play!