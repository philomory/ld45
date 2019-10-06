class GameState
  class ConfigMenu < Menu
    def setup_menu
      @title = "Options"
      add_option(->{"Fullscreen: #{$game.fullscreen? ? 'On' : 'Off'}"}) { $game.toggle_fullscreen! }
      add_slider("Music Volume:",0,Settings[:music],10) {|vol| MediaManager.music_volume = vol }
      add_slider("SFX Volume:",0,Settings[:sfx],10) {|vol| MediaManager.sfx_volume = vol }
      add_option("View/Customize Controls") { transition_to(GameState::ReviewInputBindings.new) }
      add_option("Back") { back }
    end
    
    def back
      transition_to(parent_menu)
    end
    
    def parent_menu
      $game.paused? ? GameState::PauseMenu.new : GameState::MainMenu.new
    end
  end
end