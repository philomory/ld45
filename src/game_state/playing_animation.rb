class GameState
  class PlayingAnimation < GameState
    
    def initialize(game,animation,&callback)
      @game, @animation, @callback = game, animation, callback
    end
    
    def on_enter
      @animation.play!(&@callback)
      input = @game.input_manager.queued_input.shift
      handle_input(input) if input
    end
        
    def draw
      @animation.draw
    end
    
    def update
      @animation.update
    end
    
    def handle_input(action)
      super
      @animation.finish if @animation.skippable?
    end
  end
end