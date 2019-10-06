class Lock < Prop
  
  register_type("Lock",self)
  
  def blocks_player?
    !$game.player.has_key?
  end
  
  def position=(new_cell)
    new_cell.terrain = new_cell.terrain.dup
    new_cell.terrain.passable = true
    super
  end
  
  def on_enter(unit)
    $game.player.lose_key
    MediaManager.play_sfx("unlock")
    @cell.terrain = Terrain::Floor
    @cell.prop = nil
    undo_via { @cell.prop = self }
  end
  

  
end