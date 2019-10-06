class GameState
  class TitleScreen < GameState
    
    def draw
      #MediaManager.image("title_screen").draw(0,0,11)
    end
    
    def handle_input(any)
      @game.game_state = GameState::FadeTransition.new(self,GameState::MainMenu.new(@game))
    end
    
    def draw_world?
      false
    end
    
  end
end