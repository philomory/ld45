class UndoManager

  def self.default_tracker
    @default_tracker ||= self.new
  end
  
  def initialize
    @stack = [Turn.new]
  end
  
  def start_turn!
    @stack.push(Turn.new)
  end
  
  def current_turn
    @stack.last
  end
  
  def record(change)
    current_turn.record(change)
  end
  
  def undo_via(&blk)
    record(blk)
  end
  
  def undo_turn!
    @stack.pop&.undo!
    $game.game_state = GameState::WaitingForPlayer.new
  end
  
  def level_start!
    @stack = [Turn.new]
  end

  def null_turn!
    @stack.pop
  end
  
  
  self.instance_methods(false).each do |method|
    define_singleton_method(method) do |*args,&blk|
      default_tracker.public_send(method,*args,&blk)
    end
  end
  
  class Turn
    def initialize
      @changes = []
    end
    
    def record(change)
      @changes.unshift change
    end
    
    def undo!
      @changes.each(&:call)
    end
  end
    
end