class Pickup < Prop
  
  def initialize(properties)
    super
    @blocks_player = @blocks_enemy = @blocks_bullet = false
  end

  def on_enter(unit)
    return unless unit.player?
    pickup!
    @cell.prop = nil
    undo_via { @cell.prop = self }
  end
  
  # TODO: Re-evaluate; is this intuitive? If not, what benefit does it have for things to work this way?
  # Is it worth making the rules more complicated for the sake of only _one_ level that uses that complication?
  # Even if I like that level a lot?
  #def passable?(passer)
  #  passer.is_a?(Enemy::Stone) ? false : super
  #end
  
  def pickup!
    raise NotImplementedError, "Subclasses must implemenet :pickup!"
  end
    
end