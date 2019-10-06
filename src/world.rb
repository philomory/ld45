require 'forwardable'
require 'pry'

class World
  extend Forwardable
  
  WIDTH = 12
  HEIGHT = 8
  
  def_delegators :@grid, :[]
    
  attr_reader :grid, :player, :enemies, :props
  def initialize(level)
    
    Trigger.reset!
    
    level_data = TileMap.new(level)
    @grid = Grid.new(WIDTH,HEIGHT) do |cell|
      ter, dec = level_data[cell.x,cell.y]
      cell.terrain = ter || Terrain::Empty
      cell.decoration = dec
      # binding.pry if cell.x == 6 && cell.y == 3
      if cell.right_edge
        cell.right_edge.blocked = !!level_data.right_edge(cell.x,cell.y)
      end
      if cell.bottom_edge
        cell.bottom_edge.blocked = !!level_data.bottom_edge(cell.x,cell.y)
      end
    end
    
    @warps = []
    @props = level_data.props.map do |tmo|
      prop = Prop.new(tmo.type,tmo.properties)
      prop.position = @grid[tmo.x,tmo.y]
      prop
    end
    
    warps = @props.select {|prop| prop.is_a? WarpPoint}
    warps.each {|warp| warp.partner = warps.find {|other| other != warp && other.tag == warp.tag } }
    
    @enemies = level_data.enemies.map do |tmo|
      enemy = Enemy.new(tmo.type,tmo.properties)
      enemy.position = @grid[tmo.x,tmo.y]
      enemy
    end
    
    @triggers = level_data.triggers.map do |tmo|
      Trigger.new(@grid[tmo.x,tmo.y], (tmo.properties["group"] || :default).to_sym)
    end
    
    tmo = level_data.player
    @player = Player.new(health:1, weapon_count: 0) #tmo.properties['rocks'].to_i || 3)
    @player.position = @grid[tmo.x, tmo.y]
     
  end
  
  def method_missing(name,*args,&blk)
    if @grid.respond_to?(name)
      warn "Called #{name} directly on World, should delegate to Grid"
      @grid.send(name,*args,&blk)
    else
      super
    end
  end
  
end