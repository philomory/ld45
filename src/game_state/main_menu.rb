class GameState
  class MainMenu < Menu
    def setup_menu
      @title = "Strangeness"
      #@background_image = MediaManager.image("main_menu")
      add_slider("Continue: Level",0,Settings[:max_level],Settings[:max_level], auto: false) {|level| $game.start_game(level) } if Settings[:max_level] > 0
      add_option("Start Game") { @game.start_game(0) }
      add_option("Options") { transition_to(GameState::ConfigMenu.new) }
      add_option("Credits") { transition_to(GameState::CreditsScreen.new) }
      add_option("Quit Game") { exit }
    end
    
    def on_menu_button
      exit
    end
    
    def draw
      super
      #MediaManager.image("menu_instructions.png").draw_rot($game.width/2,$game.height-50,14,0.5,0.5)
    end
  end
end