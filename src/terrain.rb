class Terrain
  def self.register(name,object)
    @registry ||= {}
    @registry[name] = object
  end
  
  def self.[](tag)
    @registry[tag]
  end
    
  
  attr_reader :name
  def initialize(name:, passable: true,bullet_passable: passable,prop_passable: passable, collapsing: false)
    @name = name 
    @passable, @bullet_passable, @prop_passable = passable, bullet_passable, prop_passable
    @collapsing = collapsing
    Terrain.register(name,self)
  end
  def imagename
    name
  end
  def image
    MediaManager.image(imagename)
  end
  def draw(xpos,ypos,z=0)
    image.draw(xpos,ypos,z)
  end
  
  def passable?(passer)
    case passer
    when Prop then !!@prop_passable
    when Weapon, Bullet then !!@bullet_passable
    else !!@passable
    end
  end
  
  def collapsing?
    true
  end

  def tag
    name
  end
  
  OutOfBounds = new(passable: false, name: "out_of_bounds")
  Dirt = new(name: "dirt")
  Grass = new(name: "grass")
  Ground = new(name: "ground")
  Wall = new(name: "wall", passable: false)
  Floor = new(name: "floor")
  Empty = new(name: "empty", passable: false, bullet_passable: true)
  Collapsing = new(name: "collapsing", collapsing: true)
  BrokenFloor = new(name: "broken_floor", collapsing: true)
  FilledHole = new(name: "filled_hole")
  Ruins = new(name: "ruins1",collapsing: true)

end