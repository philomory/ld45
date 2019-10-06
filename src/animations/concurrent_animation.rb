class ConcurrentAnimation < Animation
  def initialize(animations)
    @animations = animations.keys
    raise if @animations.empty?
    @callback_registry = animations.dup
    @children_remaining = @animations.count
  end
  
  def on_start
    @animations.each do |anim|
      anim.play! { child_finished!(anim) }
    end
  end
  
  def child_finished!(which)
    @children_remaining -= 1
    @callback_registry[which].call if @callback_registry[which]
    finish if @children_remaining <= 0
  end
  
  def update
    @animations.each(&:update)
  end
  
  def draw
    @animations.each(&:draw)
  end
  
  def on_end
    @animations.each {|child| child.finish unless child.finished? }
  end
  
  def skippable?
    @animations.all?(&:skippable?)
  end
  
   
end