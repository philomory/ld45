class AnimationManager
  def initialize(game)
    @game = game
    @scheduled_animations = {}
  end
  
  def schedule_animation(animation,&callback)
    @scheduled_animations[animation] =  callback
  end
  
  def total_animation
    ConcurrentAnimation.new(@scheduled_animations)
  end
  
  def play_if_pending!
    if @scheduled_animations.any?
      after = @game.game_state.next_state
      animations = total_animation
      @scheduled_animations = {}
      @game.game_state = GameState::PlayingAnimation.new(@game,animations) { @game.game_state = after}
    end
  end
  
  def nothing_to_do?
    @scheduled_animations.empty?
  end

end