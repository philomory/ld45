class Portal < Prop
  
  register_type("Portal",self)
  
  def initialize(properties)
    super
    @blocks_player = false
  end
  
  def imagename
    Gosu.milliseconds % 1000 >= 500 ? "portal_1" : "portal_2" 
  end

  def on_enter(unit)
    $game.next_level if unit.player?
  end
  
end