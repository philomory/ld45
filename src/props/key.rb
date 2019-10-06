class Key < Pickup
  
  register_type("Key",self)
  
  def pickup!
    $game.player.gain_key
    MediaManager.play_sfx("pickup_key")
  end

end