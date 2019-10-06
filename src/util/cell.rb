class Cell
  attr_reader :x, :y
  attr_accessor :prop, :trigger, :left_edge, :right_edge, :top_edge, :bottom_edge
  attr_reader :occupant, :terrain, :decoration
  
  def undo_via(&blk)
    UndoManager.undo_via(&blk)
  end
  
  def initialize(x,y,grid)
    @x, @y, @grid = x, y, grid
    @worked = false
  end

  def player_starts_here!
    edges.each(&:player_starts_adjacent!)
  end
  
  def arriving!(unit)
    edges.each(&:player_arriving!) if unit.player?
  end

  def leaving!(unit)
    edges.each(&:player_leaving!) if unit.player?
  end

  def occupant=(unit)
    old_occupant = @occupant
    occupant_left(@occupant) if @occupant
    @occupant = unit
    @prop.on_enter(unit) if @prop && unit
    terrain_collapse! if unit && unit.causes_collapse?
    undo_via { @occupant = old_occupant }
  end

  def occupied?
    !!occupant
  end
  
  def occupant_left(occupant)
  #  terrain_collapse! if terrain.collapsing? && occupant.causes_collapse?
  end

  def terrain_collapse!
    # MediaManager.play_sfx("crumble")
    self.terrain = Terrain::Empty
    self.decoration = nil
  end

  def empty?
    @terrain == Terrain::Empty || @terrain.nil? || (@terrain.respond_to?(:tag) && @terrain.tag == "empty")
  end
  
  def terrain=(ter)
    old_ter = @terrain
    @terrain = ter
    undo_via { @terrain = old_ter }
  end

  def decoration=(dec)
    old_dec = @decoration
    @decoration = dec
    undo_via { @decoration = old_dec }
  end
  
  def draw
    terrain.draw(xpos,ypos,0)
    decoration.draw(xpos,ypos,2) if decoration
    trigger.draw(xpos,ypos) if trigger
    occupant.draw(xpos,ypos) if occupant && !occupant.animating?
    prop.draw(xpos,ypos) if prop && !prop.animating?
  end
  
  def xpos
    x*TILE_WIDTH
  end
  
  def ypos
    y*TILE_HEIGHT
  end
  
  def edge_in_direction(direction)
    case direction
    when :west then left_edge
    when :east then right_edge
    when :north then top_edge
    when :south then bottom_edge
    else raise "Bad direction: #{direction}"
    end
  end

  def edges
    [left_edge,right_edge,top_edge,bottom_edge].compact
  end

  def passable_in_direction?(dir)
    edge = edge_in_direction(dir)
    edge && edge.passable?
  end

  def passable?(passer)
    terrain.passable?(passer) && occupant.nil? && (prop.nil? || prop.passable?(passer))
  end
  
  def weapon_hit(weapon,dir,remaining_distance)
    if occupant
      occupant.attacked(weapon)
    elsif prop && !prop.passable?(weapon)
      prop.weapon_hit(weapon,dir,remaining_distance)
    end
  end

  def blocked?(passer)
    !passable?(passer)
  end
  
  def neighbor_in_direction(dir)
    case dir
    when :north then north
    when :south then south
    when :east then east
    when :west then west
    else raise "Invalid Direction: #{dir.inspect}"
    end
  end
  
  def north; @grid[x,y-1] end
  def south; @grid[x,y+1] end
  def east;  @grid[x+1,y] end
  def west;  @grid[x-1,y] end
  
  def valence(radius)
    @grid.valence(x,y,radius)
  end
  
  def around(radius)
    @grid.around(x,y,radius)
  end
  
  class OutOfBounds < Cell
    def terrain
      Terrain::OutOfBounds
    end
    def room_for_prop?(*args)
      false
    end
  end
  
end