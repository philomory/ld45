class Enemy::Racer < Enemy  
  
  def initialize(properties)
    super
    @facing = (properties["facing"] || :north).to_sym
  end
  
  def make_your_move(&blk)
    if can_move?(@facing)
      move(@facing,&blk)
    elsif can_move?(-@facing)
      self.facing = -@facing
      make_your_move(&blk)
    else
      self.facing = -@facing
    end
  end
  
  def move(direction,&callback)
    target1 = @cell.neighbor_in_direction(direction)
    target2 = target1.neighbor_in_direction(direction)
    if target1.passable?(self) && target2.passable?(self)
      anim = MovementAnimation.new(self,@cell,target2,$game.animation_duration)
      $game.schedule_animation(anim) { self.position = target2; callback.call if callback }
    elsif target1.passable?(self)
      anim = MovementAnimation.new(self,@cell,target1,$game.animation_duration)
      $game.schedule_animation(anim) { self.position = target1; ran_into(target2,direction,callback) }
    else
      ran_into(target1,direction,&callback)
    end
  end
  
  def can_move?(dir)
    @cell.neighbor_in_direction(dir).passable?(self)
  end
  
  def ran_into(cell,direction)
    super
    self.facing = -@facing
  end
  
  def imagename
    frame = ((Gosu.milliseconds % 1000) / 500) + 1
    "racer_#{@facing}_#{frame}"
  end
  
  def draw(*args)
    super
  end
  
end
