class Prop < GameObject
  
  self.z_index = 2
  
  SPECIFIC_TYPES = {}
  
  def self.register_type(key,klass)
    SPECIFIC_TYPES[key] = klass
  end
  
  def self.new(*args)
    if self == Prop
      type, properties = args
      if SPECIFIC_TYPES.has_key?(type)
        SPECIFIC_TYPES[type].new(properties)
      else
        raise "Unknown Prop Type: #{type}"
      end
    else
      super
    end
  end
  
  attr_reader :pushable, :blocks_player, :blocks_enemy, :blocks_bullet, :blocks_boulder, :cell
  def initialize(properties)
    @pushable = false
    @blocks_player = @blocks_enemy = @blocks_bullet = true
  end
  
  %i{pushable blocks_player blocks_enemy blocks_bullet}.each do |prop|
    alias_method :"#{prop}?", prop 
  end
  
  def position=(new_cell)
    #raise new_cell.to_s if new_cell && new_cell.blocked?(self)
    @cell.prop = nil if @cell
    @cell = new_cell
    @cell.prop = self if @cell
  end
    
  def move(direction,&callback)
    target = @cell.neighbor_in_direction(direction)
    anim = MovementAnimation.new(self,@cell,target,$game.animation_duration)
    $game.schedule_animation(anim) do
      self.position = target
    end
  end
  
  def imagename
    @imagename || self.class.name.downcase
  end
  
  def on_enter(unit)
  end
  
  def can_push?(direction)
    pushable? && @cell.neighbor_in_direction(direction).room_for_prop?(self)
  end
  
  def passable?(passer)
    case passer
    when Player then !blocks_player?
    when Enemy then !blocks_enemy?
    when Bullet, Weapon then !blocks_bullet?
    else raise ArgumentError
    end
  end
  
  def weapon_hit(weapon,dir,remaining_distance)
  end
  
end