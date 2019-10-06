class Edge
  attr_reader :direction, :c1, :c2, :blocked
  def initialize(direction,c1,c2)
    @direction, @c1, @c2 = direction, c1, c2
    @blocked = false
    @xpos = (@c1.xpos + @c2.xpos)/2
    @ypos = (@c1.ypos + @c2.ypos)/2
  end

  def blocked=(value)
    @blocked = !!value
  end

  def passable?
    !blocked
  end

  def imagename
    direction == :vertical ? 'vertical_edge' : 'horizontal_edge'
  end

  def image
    MediaManager.image(imagename)
  end

  def draw?
    blocked && (!@c1.empty? || @c1.occupant) && (!@c2.empty? || @c2.occupant)
  end

  def draw
    image.draw(@xpos,@ypos,1) if draw?
  end
end
