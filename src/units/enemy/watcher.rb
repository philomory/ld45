class Enemy::Watcher < Enemy  
  
  
  attr_reader :weapon
  def initialize(properties)
    super
    @weapon = Weapon.new("beam")
    @facing = (properties["facing"] || :north).to_sym
  end
  
  def make_your_move(&blk)
    check_line_of_sight
    rotate
    check_line_of_sight
    blk.call if blk
  end
  
  def rotate
    @facing = ~@facing
    undo_via {@facing = -~@facing}
  end
  
  def range
    5
  end
  
  def check_line_of_sight
    distance = 0
    target = ([@facing] * range).inject(@cell) do |cell,dir|
      distance += 1 
      next_cell = cell.neighbor_in_direction(dir)
      break next_cell if next_cell.occupant&.player?
      return false unless next_cell.passable?(weapon)
      next_cell
    end
    return false unless target.occupant&.player?
    bullet = @weapon.bullet(@facing)
    
    anim = MovementAnimation.new(bullet,@cell.neighbor_in_direction(@facing),target,distance*25,false)
    $game.schedule_animation(anim) do
      target.occupant.attacked(nil) if target.occupant
    end
  end
  
  
  def imagename
    frame = ((Gosu.milliseconds % 1000) / 500) + 1
    "watcher_#{@facing}_#{frame}"
  end
  
  def draw(*args)
    super
  end
  
end
