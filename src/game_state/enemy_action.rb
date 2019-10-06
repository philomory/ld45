class GameState
  class EnemyAction < GameState
    
    
    
    def first_time?
      !@already_run
    end
    
    def on_enter
      if first_time? && game.enemies.any?
        setup_turn
      elsif game.enemies.none?(&:ready_to_move?)
        game.game_state = CheckWorldState.new(WaitingForPlayer)
      end
    end
    
    def setup_turn
      @already_run = true
      @last_move = 0
      game.enemies.each(&:ready_to_move!)
    end
    
    DELTA = 50

    def update
      game.enemies.select(&:ready_to_move?).each {|enemy| enemy.make_your_move! }
      game.game_state = CheckWorldState.new(WaitingForPlayer) if game.animation_manager.nothing_to_do?
    end
    
    # def update
    #   if Gosu.milliseconds > @last_move + DELTA
    #     @last_move = Gosu.milliseconds
    #     if game.enemies.any?(&:ready_to_move?)
    #       move_next_enemy
    #     else
    #       game.game_state = GameState::WaitingForPlayer.new(game)
    #     end
    #   end
    # end
    
    def move_next_enemy
      enemy = game.enemies.select(&:ready_to_move?).first
      enemy.make_your_move! { game.game_state = self }
    end
    
    def next_state
      self
    end
    
    def animation_duration
      50
    end
    
  end
end