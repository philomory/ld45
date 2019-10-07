require 'gosu'
require 'require_all'
require 'crack'

APP_ROOT = File.dirname(__FILE__)
SOURCE_ROOT = File.join(APP_ROOT,'src')
MEDIA_ROOT = File.join(APP_ROOT,'media')
DATA_ROOT = File.join(APP_ROOT,'data')
SETTINGS_FILE = File.expand_path("../../../settings.yml",APP_ROOT) #TODO: Should be user's Library/Preferences maybe?

require_all File.join(File.dirname(__FILE__),'src')

Game.play!

