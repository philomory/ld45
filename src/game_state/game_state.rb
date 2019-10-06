class GameState
  attr_reader :game
  def initialize(game = $game)
    @game = game 
  end
  
  def handle_input(action)
    @game.input_manager.queue_input(action)
  end
  
  def on_enter
  end
  
  def on_exit
  end
  
  def update
  end
  
  def draw
  end
  
  def next_state
    self
  end
  
  def scale_factor
    fullscreen? ? 1 : SCALE_FACTOR
  end
  
  
  def center_x
    @game.width / (scale_factor * 2)
  end
  
  def center_y
    @game.height / (scale_factor * 2)
  end
  
  def locked?
    false
  end
  
  def draw_world?
    true
  end
  
  def fullscreen?
    false
  end
  
  def needs_raw_input?
    false
  end

  def is_menu?
    false
  end
end