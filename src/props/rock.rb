class Rock < Pickup
  
  register_type("Rock",self)
  
  def pickup!
    $game.player.gain_rock
    MediaManager.play_sfx("pickup_key")
  end

end