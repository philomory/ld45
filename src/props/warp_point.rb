class WarpPoint < Prop
  
  register_type("Warp",self)
  
  attr_reader :tag, :partner
  def initialize(properties)
    raise if properties['tag'].nil?
    super
    @blocks_player = @blocks_enemy = false
    @tag = properties['tag']
  end
  
  def partner=(other)
    raise "#{self} already has a match!" unless @partner.nil?
    raise "#{other} does not share tag with #{self}" unless @tag == other.tag 
    @partner = other
  end
  
  def to_s
    "WarpPoint[#{@tag}]"
  end
  
  def imagename
    Gosu.milliseconds % 1000 >= 500 ? "warp_1" : "warp_2" 
  end

  def on_enter(unit)
    if @arriving == unit
      @arriving = nil
      undo_via { @cell.instance_variable_set(:@occupant,nil) }
    else
      if @partner.prepare_for_arrival(unit)
        undo_via { @cell.instance_variable_set(:@occupant,nil) }
        unit.position = @partner.cell
        #undo_via { prepare_for_arrival(unit) }
      end
    end
  end
  
  def prepare_for_arrival(unit)
    if @cell.occupant 
      player = [unit,@cell.occupant].select(&:player?).first
      player&.die
      return player
    else
      @arriving = unit
      return true
    end
  end
  
  def weapon_hit(weapon,dir,distance_remaining)
    @partner.send_weapon(weapon,dir,distance_remaining)
  end
  
  def send_weapon(bullet,dir,distance_remaining)
    if @cell.occupant
      @cell.occupant.attacked(bullet)
    else
      distance = 0
      target = ([dir] * distance_remaining).inject(@cell) do |cell,dir|
        distance += 1 
        next_cell = cell.neighbor_in_direction(dir)
        break next_cell unless next_cell.passable?(bullet)
        next_cell
      end
    
      anim = MovementAnimation.new(bullet,@cell,target,distance*100,false)

      $game.schedule_animation(anim) do
        target.weapon_hit(bullet,dir,distance_remaining-distance)
      end
    end
  end

  
end