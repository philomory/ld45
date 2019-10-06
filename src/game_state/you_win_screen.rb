class GameState
  class YouWinScreen < GameState

    FADE_IN_DURATION = 1000.0
    FADE_OUT_DURATION = 750.0

    def initialize(game)
      @game = game
      @message = "To Be Continued..."
      font_path = MediaManager.font_path('large')
      background_message = "to be continued"
      @level_image = Gosu::Image.from_text(background_message,44,font: font_path)
      @points = Array.new(30) { random_point }
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
      MediaManager.font('large').draw_rel(@message,center_x, center_y,14,0.5,0.5,1,1,color)
    end
    
    def fade_portion
      [(fade_out_time / FADE_OUT_DURATION),1.0].min
    end
    
    def fade_out_time
      @fade_start ? Gosu.milliseconds - @fade_start : 0
    end

    def handle_input(action)
      begin_fade_out if running_time > FADE_IN_DURATION
    end

    def begin_fade_out
      @fade_start ||= Gosu.milliseconds
    end
    
    def update
      finish if fade_portion >= 1
    end

    def load_message(key)
      path = File.join(DATA_ROOT,'text.yml')
      data = YAML.load_file(path)
      data[key]
    end
    
    def finish
      @game.game_state = GameState::CreditsScreen.new(@game)
    end
    
    def locked?
      fade_portion < 1
    end

  end
end