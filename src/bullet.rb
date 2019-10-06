require 'forwardable'

class Bullet < GameObject
  extend Forwardable
  
  self.z_index = 3
  
  def initialize(weapon,facing=nil)
    @weapon, @facing = weapon, facing
  end
  
  def imagename
    @facing ? "#{@weapon.name}_bullet_#{@facing}" : "#{@weapon.name}_bullet"  
  end
  
end