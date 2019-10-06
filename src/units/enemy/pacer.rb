class Enemy::Pacer < Enemy  
  
  def initialize(properties)
    super
    @facing = (properties["facing"] || :north).to_sym
  end
  
  def make_your_move(&blk)
    move(@facing,&blk)
  end
  
  def ran_into(cell,direction)
    self.facing = -@facing unless cell.occupant&.player?
    super
  end
  
  def imagename
    frame = ((Gosu.milliseconds % 1000) / 500) + 1
    "pacer_#{@facing}_#{frame}"
  end
  
  def draw(*args)
    super
  end
  
end
