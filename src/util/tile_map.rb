require 'crack'
require 'base64'

class TileMap
  
  attr_reader :props, :enemies, :player, :triggers
  def initialize(map_file)
    @tiles = {}
    data = Crack::XML.parse(File.read(File.join(DATA_ROOT,"levels","#{map_file}.tmx")))
    Ary(data['map']['tileset']).each {|tset| load_tiles(tset) }
    @width, @height = data['map']["width"].to_i, data['map']["height"].to_i
    layers = hashify(data["map"]["layer"])
    @terrain_data = decode(layers["Terrain"]["data"]).map {|gid| @tiles[gid] }
    @decoration_data = decode(layers["Decoration"]["data"]).map {|gid| @tiles[gid]}
    @horizontal_edges = decode(layers["Horizontal Edges"]["data"]).map { |gid| @tiles[gid]}
    @vertical_edges = decode(layers["Vertical Edges"]["data"]).map { |gid| @tiles[gid]}
    object_groups = hashify(data["map"]["objectgroup"])
    @props = Ary(object_groups["Props"]["object"]).map {|o_dfn| TMapObject.new(o_dfn) }
    @enemies = Ary(object_groups["Enemies"]["object"]).map {|o_dfn| TMapObject.new(o_dfn) }
    @triggers = Ary(object_groups["Triggers"]["object"]).map {|o_dfn| TMapObject.new(o_dfn) }
    @player = TMapObject.new(object_groups["Player"]["object"])  
  end
  
  def [](x,y)
    [@terrain_data[x + y * @width], @decoration_data[x + y * @width]]
  end

  def right_edge(x,y)
    @vertical_edges[x + y * @width]
  end

  def bottom_edge(x,y)
    @horizontal_edges[x + y * @width]
  end
  
  private
  def load_tiles(tset,first_gid=nil)
    if tset.has_key?("image")
      MediaManager.tileset(tset["image"]["source"].split("/").last).each_with_index do |image,index|
        register_tile(index+tset["firstgid"].to_i, Tile.new(image))
      end
      Ary(tset["tile"]).each {|props| set_tile_properties(props,tset["firstgid"]) }
    else
      load_tileset(tset['source'],tset['firstgid'])
    end
  end
  
  def load_tileset(source, firstgid)
    data = Crack::XML.parse(File.read(File.join(DATA_ROOT,"levels",source)))
    tset = data["tileset"]
    tset['firstgid'] = firstgid
    load_tiles(tset)
  end
  
  def register_tile(gid, tile)
    @tiles[gid] = tile
  end
  
  def set_tile_properties(props,first_gid)
    gid = props["id"].to_i + first_gid.to_i
    dfns = Ary(props["properties"]["property"])
    tile = @tiles[gid]
    dfns.each {|dfn| tile.add_property(dfn["name"],dfn["value"]) }
  end
  
  def decode(data)
    Base64.decode64(data).unpack("V*")
  end
  
  def hashify(group)
    ary = Ary(group)
    hsh = {}
    ary.each {|entry| hsh[entry["name"]] = entry }
    hsh
  end
    
end


Tile = Struct.new(:image,:tag,:passable,:type) do
  def add_property(key,value)
    self[key.to_sym] = value
  end
  
  def passable?(passer)
    case passable
    when true, false then passable
    when nil then Terrain[tag].passable?(passer)
    else raise ArgumentError
    end
  end
  
  def method_missing(name,*args,&blk)
    proto = Terrain[tag]
    proto.respond_to?(name) ? proto.send(name,*args,&blk) : super
  end
  
  def draw(xpos,ypos,z)
    image.draw(xpos,ypos,z)
  end
end

class TMapObject
  attr_reader :type, :properties, :x, :y
  def initialize(dfn)
    dfn = dfn.dup
    @type = dfn["type"] || "prop"
    @x = (dfn["x"].to_i / TILE_WIDTH)
    @y = (dfn["y"].to_i / TILE_WIDTH) - 1
    props = dfn['properties']
    @properties = props ? hashify(props['property']) : {}
  end
  
  def hashify(group)
    ary = Ary(group)
    hsh = {}
    ary.each {|entry| hsh[entry["name"]] = entry["value"] }
    hsh
  end
end