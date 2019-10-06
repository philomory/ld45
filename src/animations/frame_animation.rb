class FrameAnimation < Animation
  attr_reader :position
  def initialize(object,key,duration,skippable=false)
    @object = object
    @position = [@object.cell.xpos,@object.cell.ypos]
    @frames = MediaManager.animation_frames(key)
    @frame_callbacks = {}
    @ran_callbacks = []
    super(duration,skippable)
  end

  def on_frame(fnum,&callback)
    @frame_callbacks[fnum] ||= []
    @frame_callbacks[fnum] << callback
  end
  
  def on_start
    @object.animating = true
  end
  
  def frame_index
    [(portion * @frames.count).floor,@frames.count].min
  end

  def current_frame
    @frames[frame_index]
  end

  def run_callbacks
    index = frame_index
    unless @ran_callbacks[index]
      @ran_callbacks[index] = true
      callbacks = @frame_callbacks[index]
      if callbacks
        callbacks.each(&:call)
      end
    end
  end

  def draw
    run_callbacks
    current_frame.draw(*position,@object.z_index)
  end
  
  def on_end
    @object.animating = false
  end
  
end