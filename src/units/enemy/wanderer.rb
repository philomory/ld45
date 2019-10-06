class Enemy::Wanderer < Enemy
  self.z_index = 1
  
  def make_your_move(&blk)
    move(%i(north south east west).sample,&blk)
  end
end
