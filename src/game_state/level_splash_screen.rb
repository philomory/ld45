class GameState
  class LevelSplashScreen < GameState

    FADE_IN_DURATION  = 1000.0
    FADE_OUT_DURATION = 750.0
    QUICK_FADE_OUT_DURATION = 250.0

    def initialize(game,&blk)
      @blk = blk
      @game = game
      level = @game.level
      message = "Level: #{level}" #load_message(level)
      font_path = MediaManager.font_path('large')
      @message_image = Gosu::Image.from_text(message, 44, width: 896, font: font_path, retro: true, align: :center)
      background_message = level == 0 ? message : "Level #{level}"
      @level_image = Gosu::Image.from_text(background_message,44,font: font_path, retro: true)
      @points = Array.new(50) { random_point }
      @fade_out_duration = FADE_OUT_DURATION
    end
    
    
    def random_point
      x = rand(0..@game.width)
      y = rand(0..@game.height)
      c = rand * rand * 0.5
      [x,y,c]
    end
    
    def fullscreen?
      true
    end
  
    def on_enter
      @start_time = Gosu.milliseconds
    end
  
    def running_time
      @start_time ? Gosu.milliseconds - @start_time : 0
    end
  
    def portion
      [(running_time / FADE_IN_DURATION),1.0].min
    end
  
    def color(alpha = portion)
      ((alpha * 0xFF * (1.0 - fade_portion)).floor * 0x01000000 + 0x00FFFFFF)
    end
  
    def draw
      bg_color = (0xEE * (1.0 - fade_portion)).floor * 0x01000000
      Gosu.draw_rect(0,0,@game.width,@game.height,bg_color,11)
      @points.each {|x,y,c| @level_image.draw_rot(x,y,13,0,0.5,0.5,1,1,color(c)) }
      @message_image.draw_rot(center_x, center_y,14,0,0.5,0.5,1,1,color)
    end
    
    def fade_portion
      [(fade_out_time / @fade_out_duration),1.0].min
    end
    
    def fade_out_time
      @fade_start ? Gosu.milliseconds - @fade_start : 0
    end

    def handle_input(action)
      @fade_out_duration = QUICK_FADE_OUT_DURATION
      begin_fade_out
    end

    def begin_fade_out
      @fade_start ||= Gosu.milliseconds
    end
    
    def update
      begin_fade_out if running_time > FADE_IN_DURATION + 1000 && @fade_start.nil?
      finish if fade_portion >= 1
    end

    def load_message(key)
      path = File.join(DATA_ROOT,'text.yml')
      data = YAML.load_file(path)
      data[key]
    end
    
    def finish
      @blk.call
    end
    
    def locked?
      fade_portion < 1
    end

  end
end