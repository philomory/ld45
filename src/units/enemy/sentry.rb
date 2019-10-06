class Enemy::Sentry < Enemy::Watcher
  
  def rotate
  end
  
  def range
    10
  end 
  
  def imagename
    frame = ((Gosu.milliseconds % 1000) / 500) + 1
    "sentry_#{@facing}_#{frame}"
  end
  
end
