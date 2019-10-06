class GameState
  class CheckWorldState < GameState
    def initialize(next_state=WaitingForPlayer)
      @next_state = next_state
      super()
    end
    def on_enter
      game.world.props.each(&:check_state)
      if game.world.grid.all?(&:empty?)
        game.next_level
      elsif game.player.stuck?
        game.player.die
      end
     if game.game_state == self && game.animation_manager.nothing_to_do?
        game.game_state = @next_state.new(game)
      end
    end
  end
end