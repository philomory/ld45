class MovementAnimation < Animation
  def initialize(object,start_pos,end_pos,duration,skippable=true)
    @object = object
    @start_pos = position_from(start_pos)
    @end_pos = position_from(end_pos)
    super(duration,skippable)
  end
  
  def on_start
    @object.animating = true
  end
  
  def position
    x1, y1 = @start_pos
    x2, y2 = @end_pos
    x_pos = interpolate(x1,x2,portion)
    y_pos = interpolate(y1,y2,portion)
    [x_pos,y_pos]
  end
  
  def interpolate(a,b,f)
    a + ((b - a) * f)
  end
  
  def draw
    @object.draw(*position)    
  end
  
  def on_end
    @object.animating = false
  end
  
  def position_from(obj)
    case obj
    when Cell then [obj.xpos, obj.ypos]
    else obj
    end
  end
  

  
end