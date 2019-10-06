class PropStone < Prop
  
  register_type("Stone",self)
  
  def position=(new_cell)
    stone = Enemy::Stone.new
    stone.position = new_cell
  end
  
end