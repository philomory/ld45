class GameState
  class ControlStyleMenu < Menu
    def setup_menu
      @title = "Choose Control Style"
      add_option("Hold Modifier to Throw") { InputManager.input_style = :modifier; show_config }
      add_option("Dedicated Throw Controls") { InputManager.input_style = :separate; show_config }
      add_option("Back") { back }
    end
    
    
    def back
      transition_to(GameState::ConfigMenu.new)
    end
    
    def show_config
      transition_to(GameState::ReviewInputBindings.new)
    end
    
    def draw
      super
      MediaManager.font("small").draw_rel(description,center_x,550,14,0.5,0.5)
    end

    DESCRIPTIONS = ["Hold a modifier key and press a direction to throw a rock", "Separate direction keys for movement and throwing rocks",""].freeze

    def description
      DESCRIPTIONS[@position]
    end
      
    
  end
end