class Grid
  include Enumerable
  attr_reader :width, :height
  
  def initialize(width, height, &blk)
    @width, @height = width, height
    @contents = Array.new(width) do |x|
      Array.new(height) {|y| Cell.new(x,y,self) }
    end
    @edges = []
    self.each_with_index do |cell00,x,y|
      cell10 = self[x+1,y]
      cell01 = self[x,y+1]
      if x < width-1
        v_edge = Edge.new(:vertical,cell00,cell10)
        cell00.right_edge = cell10.left_edge = v_edge
        @edges << v_edge
      end
      if y < height-1
        h_edge = Edge.new(:horizontal,cell00,cell01)
        cell00.bottom_edge = cell01.top_edge = h_edge
        @edges << h_edge
      end
    end
    self.each(&blk)
  end
  
  def each(&blk)
    @contents.each do |row|
      row.each do |element|
        blk.call(element)
      end
    end
  end
  
  def each_with_index(&blk)
    @contents.each_with_index do |row, x|
      row.each_with_index do |element, y|
        blk.call(element,x,y)
      end
    end
  end

  def each_edge(&blk)
    @edges.each do |edge|
      blk.call(edge)
    end
  end

  def [](x,y)
    if x.between?(0,width-1) && y.between?(0,height-1)
      @contents[x][y]
    else
      Cell::OutOfBounds.new(x,y,self)
    end
  end
  
  def []=(x,y,val)
    @contents[x][y] = val
  end
  
  def valence(x,y,radius)
    select {|cell| ((cell.x - x).abs + (cell.y-y).abs) == radius }
  end

  def around(x,y,radius)
    select {|cell| ((cell.x - x).abs + (cell.y-y).abs) <= radius }
  end
end