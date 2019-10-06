require 'yaml'

module MediaManager
  class << self
    # def image(name)
    #   @images ||= {}
    #   @images[name] ||= begin
    #                       filename = "#{name}.png"
    #                       path = File.join(MEDIA_ROOT,'images',filename)
    #                       Gosu::Image.new(path, retro: true)
    #                     end
    # end
    #
    # def setup
    #   tilepath = File.join(MEDIA_ROOT,'images','basictiles_2.png')
    #   tiles = Gosu::Image.load_tiles(tilepath,16,16,retro: true)
    # end
  
    def image(name)
      @images ||= {}
      @images[name] ||= _load_image_named(name)
    end

    def animation_frames(name)
      @animations ||= {}
      @animations[name] ||= _load_animation_named(name)
    end

    def font(name)
      @fonts ||= {}
      @fonts[name] ||= _load_font_named(name)
    end
    
    def font_path(name)
      @font_paths ||= {}
      @font_paths[name] ||= File.join(MEDIA_ROOT,'fonts',_font_map[name]['path'])
    end
    
    def tileset(name)
      _tiles(name)
    end
    
    def sfx(name)
      @sfx ||= {}
      @sfx[name] ||= _load_sfx_named(name)
    end
    
    def play_sfx(name)
      sfx(name).play(Settings[:sfx]/10.0) if sfx?
    end
    
    def sfx_volume=(vol)
      Settings[:sfx] = vol
      play_sfx('pickup_key')
    end
    
    def sfx?
      return false
      Settings[:sfx] > 0
    end
  
    def song(name)
      @songs ||= {}
      @songs[name] ||= _load_song_named(name)
    end
  
    def song_for_level(level)
      case level
      when  0..5  then "oceans"
      when  6..10 then "ghost"
      when 11..15 then "cheese"
      when 16..20 then "matrix"
      else "oceans"
      end
    end
    
    def play_song_for_level(level)
      name = song_for_level(level)
      play_music(name) if song(name) && music? && Gosu::Song.current_song != song(name)        
    end
  
    def play_music(name=nil)
      return
      name ||= song_for_level($game.level)
      song = song(name)
      song.volume = Settings[:music] / 10.0
      song.play(true)
    end
    
    def music_volume=(vol)
      Gosu::Song.current_song&.volume = (vol / 10.0)
      Settings[:music] = vol
    end
      
    def music?
      Settings[:music] > 0
    end
    
    def toggle_music
      #Settings.set_key_path(:music, !Settings[:music])
      #Settings[:music] ? play_music : stop_music
    end
  
    private
    
    def _load_animation_named(name)
      fname = _animation_map[name] || "#{name}.png"
      _tiles(fname)
    end

    def _animation_map
      @_animation_map ||= YAML.load_file(File.join(DATA_ROOT,'animations.yml'))
    end

    def _load_sfx_named(name)
      fname = _sfx_map[name] || "#{name}.wav"
      path = File.join(MEDIA_ROOT,"sfx",fname)
      Gosu::Sample.new(path)
    end
    
    def _sfx_map
      @_sfx_map ||= YAML.load_file(File.join(DATA_ROOT,'sfx.yml'))
    end
    
    def _load_song_named(name)
      fname = _song_map[name]
      if fname
        path = File.join(MEDIA_ROOT,"music",fname)
        song = Gosu::Song.new(path)
        song.volume = 0.75
        song
      end
    end
    
    def _song_map
      @_song_map ||= YAML.load_file(File.join(DATA_ROOT,'music.yml'))
    end
    
    def _pick_random_song
      _song_map.keys.sample
    end
    
    def _load_font_named(name)
      data = _font_map[name]
      path = File.join(MEDIA_ROOT,'fonts',data['path'])
      Gosu::Font.new(data['size'],name: path)
    end
    
    def _font_map
      @_font_map ||= YAML.load_file(File.join(DATA_ROOT,'fonts.yml'))
    end
  
    def _load_image_named(name)
      data = _mapping[name] || {'image' => name}
      if data.has_key?('set')
        _tiles(data['set'])[data['index']]
      elsif data.has_key?('image')
        path = File.join(MEDIA_ROOT,'images',data['image'])
        Gosu::Image.new(path,retro: true)
      end
    end
  
    def _mapping
      @_mapping ||= YAML.load_file(File.join(DATA_ROOT,'tileset.yml'))
    end
  
    def _tiles(set)
      @_tiles ||= {}
      @_tiles[set] ||= _load_tiles(set)
    end
  
    def _load_tiles(set)
      path = File.join(MEDIA_ROOT,'tilesets',set)
      Gosu::Image.load_tiles(path,32,32,retro: true)
    end
  end
  
end