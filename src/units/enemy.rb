class Enemy < Unit
  self.z_index = 1
  
  
  def self.new(*args)
    if self == Enemy
      self.const_get(args.shift).new(*args)
    else
      super
    end
  end

  def initialize(*args)
    super()
    @ready_to_move = false
    @turns_stunned = 0
  end

  def ready_to_move!
    @ready_to_move = true
  end
  
  def ready_to_move?
    @ready_to_move
  end
  
  def make_your_move!(&callback)
    make_your_move(&callback) unless stunned?
    end_turn
  end
  
  def make_your_move
  end
  
  def die
    @cell.occupant = nil
    $game.enemy_died(self)
    undo_via { @cell.occupant = self }
  end
  
  def ran_into(cell,direction,&callback)
    if cell.occupant && cell.occupant.player?
      attack(cell.occupant)
    end
    callback.call if callback
  end
  
  def attack(player)
    player.attacked(self)
    self.position = player.cell
  end
  
  def attacked(weapon)
    old_stunned = @turns_stunned
    @turns_stunned = 4
    undo_via { @turns_stunned = old_stunned }
    MediaManager.play_sfx("enemy_stunned")
  end
  
  def stunned?
    @turns_stunned > 0
  end
  
  def draw(xpos,ypos)
    super
    draw_stars(xpos,ypos) if stunned? 
  end
  
  def draw_stars(xpos,ypos)
    MediaManager.image(star_image).draw(xpos,ypos, z_index)
  end
  
  def star_image
    frame = ((Gosu.milliseconds % 1000) / 500) + 1
    "star_#{[@turns_stunned,3].min}_#{frame}"
  end
  
  def end_turn
    old_ready = @ready_to_move
    old_stunned = @turns_stunned
    @ready_to_move = false
    @turns_stunned -= 1 if stunned?
    undo_via { @ready_to_move = old_ready; @turns_stunned = old_stunned }
  end
  
  def can_push?(direction)
    false
  end
  
  def deadly?
    true
  end
  
  
end
