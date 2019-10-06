class Edge
  attr_reader :direction, :c1, :c2, :blocked, :xpos, :ypos
  attr_accessor :animating
  def initialize(direction,c1,c2)
    @direction, @c1, @c2 = direction, c1, c2
    @blocked = false
    @glowing = false
    @xpos = (@c1.xpos + @c2.xpos)/2
    @ypos = (@c1.ypos + @c2.ypos)/2
  end

  def blocked=(value)
    @blocked = !!value
  end

  def player_starts_adjacent!
    @glowing = true
  end

  def passable?
    !blocked
  end

  def undo_via(&blk)
    UndoManager.undo_via(&blk)
  end

  def player_arriving!
    glow! if blocked
  end

  def player_leaving!
    disperse! if blocked
  end

  def glow!
    old_image = image
    @glowing = true
    new_image = image
    @glowing = false
    anim = CrossfadeAnimation.new(self,1,old_image,new_image,$game.animation_duration)
    $game.schedule_animation(anim) do
      @glowing = true
    end
    undo_via { @glowing = false }
  end

  def disperse!
    anim = CrossfadeAnimation.new(self,1,image,MediaManager.image('empty'),$game.animation_duration)
    $game.schedule_animation(anim) do
      @blocked = false
      undo_via { @blocked = true }
    end
  end

  def imagename
    name = direction == :vertical ? 'vertical_edge' : 'horizontal_edge'
    name = "#{name}_glow" if @glowing
    name
  end

  def image(glow=@glowing)
    MediaManager.image(imagename)
  end

  def draw?
    blocked && !animating
  end

  def draw
    image.draw(@xpos,@ypos,1) if draw?
  end
end
