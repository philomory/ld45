class Weapon
  attr_reader :name
  def initialize(name)
    @name = name
  end
  
  def imagename
    name
  end
  
  def bullet(facing=nil)
    Bullet.new(self,facing)
  end
end