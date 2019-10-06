class Enemy::Stone < Enemy  
  
  def imagename
    "stone"
  end
  
  def can_push?(direction)
    @cell.neighbor_in_direction(direction).passable?(self)
  end
  
  def move(direction,&callback)
    target = @cell.neighbor_in_direction(direction)
    anim = MovementAnimation.new(self,@cell,target,$game.animation_duration)
    $game.schedule_animation(anim) do
      self.position = target
    end
  end
  
  def deadly?
    false
  end
  
  def attacked(*args)
  end
  
  def position=(target)
    super
    if @cell.terrain.collapsing?
      MediaManager.play_sfx("rock_in_hole")
      die
      @cell.terrain = Terrain::FilledHole
    end
  end
  
end
