class GameState
  class CreditsScreen < GameState

    FADE_IN_DURATION = 1000.0
    FADE_OUT_DURATION = 750.0

    def fullscreen?
      true
    end
  
    def draw_world?
      false
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
      MediaManager.image("credits").draw(0,0,11)
      draw_text("Programming, Art, Audio and Design",200)
      draw_text("Adam Gardner",250)
      draw_text("Additional Art",400)
      draw_text("Jessie",450)
      draw_text("Alagard and Romulus fonts by Pix3M",600)
    end
    
    def draw_text(msg,ypos)
      MediaManager.font('large').draw_rel(msg,center_x, ypos, 14,0.5,0.5,1,1,color)
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

    def finish
      $game.game_state = GameState::MainMenu.new
    end
    
    def locked?
      fade_portion < 1
    end

  end
end