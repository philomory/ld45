class Barrier < Prop
  
  self.z_index=2
  
  register_type("Barrier",self)
  
  def initialize(properties)
    super
    @group = (properties["group"] || :default).to_sym
  end
  
  def blocks_player?
    !Trigger.activated?(@group)
  end
  
  def blocks_enemy?
    !Trigger.activated?(@group)
  end
  
  alias_method :blocks_enemy?, :blocks_player?
  alias_method :blocks_bullet?, :blocks_player?
  
  def imagename
    if blocks_player?
      Gosu.milliseconds % 1000 >= 500 ? "barrier_1" : "barrier_2" 
    else
      "empty"
    end
  end
  
  def check_state
    @cell.occupant.fry if @cell.occupant && blocks_player?
  end
  
end