require 'pry'
class GameState
  class PlayerDiedState < GameState

    FADE_IN_DURATION  = 250.0
    FADE_OUT_DURATION = 250.0

    #DEATH_MESSAGES = YAML.load_file(File.join(DATA_ROOT,"death.yml"))

    def initialize(*args)
      super
      @locked = true

      font_path = MediaManager.font_path('large')
      message1 = "Undo: Z"
      message2 = "Restart: R"
      
      @message1 = Gosu::Image.from_text(message1, 44, font: font_path, retro: true)
      @message2 = Gosu::Image.from_text(message2, 44, font: font_path, retro: true)
    end
    

    def handle_input(action)
      case action
      when :undo then begin_fade_out { UndoManager.undo_turn! }
      when :restart then begin_fade_out { $game.restart_level }
      end
    end
    
    def draw
      Gosu.draw_rect(0,0,$game.width,$game.height,bg_color,11)
      @message1.draw_rot(100, center_y,14,0,0.0,0.5,1,1,color)
      @message2.draw_rot($game.width-100, center_y,14,0,1.0,0.5,1,1,color)
    end
    
    def next_state
      self
    end
    
    def locked?
      @locked
    end
    
    def draw_world?
      true
    end
    
    def fullscreen?
      true
    end
    
    def on_enter
      InputManager.clear_queue!
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
  
    def bg_color
      bg_color = (0x40 * (1.0 - fade_portion)).floor * 0x01000000
    end
  
    def fade_portion
      [(fade_out_time / FADE_OUT_DURATION),1.0].min
    end
    
    def fade_out_time
      @fade_start ? Gosu.milliseconds - @fade_start : 0
    end

    def begin_fade_out(&and_then)
      @locked = false
      @follow_up = and_then
      @fade_start ||= Gosu.milliseconds
    end
    
    def update
      finish if fade_portion >= 1
    end
    
    def finish
      @follow_up.call
    end

  end
end