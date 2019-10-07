class GameState
  class WaitingForPlayer < GameState
    
    def on_enter
      input = @game.input_manager.queued_input.shift
      handle_input(input) if input
    end
        
    def handle_input(action)
      case action
      when :pause then $game.pause
      when :restart then $game.restart_level
      when :north, :south, :east, :west
        UndoManager.start_turn!
        game.player.move(action) { game.game_state = CheckWorldState.new }
      when /throw_(?<dir>\w+)/
        UndoManager.start_turn!
        game.player.throw_weapon($~[:dir].to_sym) { game.game_state = CheckWorldState.new }
      when :wait
        if game.waiting_allowed?
          UndoManager.start_turn!
          game.game_state = CheckWorldState.new
        else
          MediaManager.play_sfx("buzzer")
        end
      when :undo
        UndoManager.undo_turn!
      end
    end  
    def next_state
      CheckWorldState.new
    end
    
    def animation_duration
      100
    end
  end
end
