class GameState
  class PauseMenu < Menu
    def setup_menu
      @title = "Level #{$game.level}: Paused"
      add_option("Resume") { $game.unpause }
      add_option("Restart Level") { $game.unpause; $game.restart_level }
      add_option("Options") { transition_to(GameState::ConfigMenu.new) }
      add_option("Return to Main Menu") { $game.paused = false; transition_to(GameState::MainMenu.new) }
    end
    
    def on_menu_button
      $game.unpause
    end
    
  end
end