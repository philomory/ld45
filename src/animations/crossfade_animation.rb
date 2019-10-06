class CrossfadeAnimation < Animation
  def initialize(object,z,image1,image2,duration,skippable=true)
    @object, @z, @image1, @image2 = object, z, image1, image2
    super(duration,skippable)
  end
  
  def on_start
    @object.animating = true
  end
  
  def position
    [@object.xpos,@object.ypos]
  end
  
  def interpolate(a,b,f)
    a + ((b - a) * f)
  end
  
  def alpha1
    Gosu::Color.argb(255*(1-portion),255,255,255)
  end

  def alpha2
    Gosu::Color.argb(255*portion,255,255,255)
  end

  def draw
    @image1.draw(*position,@z,1,1,alpha1)
    @image2.draw(*position,@z,1,1,alpha2)    
  end
  
  def on_end
    @object.animating = false
  end
  
end