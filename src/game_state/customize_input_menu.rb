class GameState
  class CustomizeInputMenu < GameState
    
    def draw_world?
      false
    end
  
    def fullscreen?
      true
    end
  
    def needs_raw_input?
      true
    end

    def initialize
      super
      @needed_actions = InputManager.current_manager.bind_list
      @bindings = {}
    end
    
    def current_input_description
      @needed_actions.values.first
    end
    
    def draw
      draw_text("Press a button/key for:",center_y - 100,1)
      draw_text(current_input_description,center_y,1)
      if @error
        draw_text("You've already assigned that key",center_y+100,1)
        draw_text("to another action",center_y+150,1)
      end
    end

    def draw_text(msg,ypos,scale)
      MediaManager.font('large').draw_rel(msg,center_x, ypos, 14,0.5,0.5,scale,scale)
    end
    
    def button_down(id)
      if @bindings.values.include?(id)
        MediaManager.play_sfx("buzzer")
        @error = true
      else
        action = @needed_actions.keys.first
        @needed_actions.delete(action)
        @bindings[action] = id
        @error = false
        finish if @needed_actions.empty?
      end
    end
    
    def finish
      InputManager.current_manager.bindings = @bindings
      $game.game_state = GameState::FadeTransition.new(self,GameState::ConfirmInputBindings.new)    
    end
      
    
  end
end