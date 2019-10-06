class UI
  Z_INDEX = 10
  
  def initialize(game)
    @game = game
  end
  
  def draw
    draw_level
    draw_keys
    draw_weapon
  end
  
  def draw_level
    MediaManager.font("large").draw("Level #{@game.level}",64,0,Z_INDEX) if @game.level > 0
  end
  
  def draw_keys
    MediaManager.font("large").draw_rel("Keys: #{@game.player.keys}",@game.width/2,0,Z_INDEX,0.5,0) if @game.player.has_key?
  end
  
  def draw_weapon
    MediaManager.font("large").draw_rel("Rocks: #{@game.player.weapon_count}",@game.width - 64,0,Z_INDEX,1,0) if @game.player.has_weapon?
  end
  
  
end
