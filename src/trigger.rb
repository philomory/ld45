class Trigger < GameObject
  
  self.z_index = 0.5
  
  def self.register(trigger)
    @triggers ||= Hash.new {|h,k| h[k] = []}
    @triggers[trigger.group] << trigger
  end
  
  def self.activated?(group=:default)
    @triggers[group].any?(&:activated?) if @triggers
  end
  
  def self.reset!
    @triggers&.clear
  end
  
  attr_accessor :group
  def initialize(cell, group=:default)
    @cell, @group = cell, (group || :default)
    @cell.trigger = self
    @previously_activated = activated?
    Trigger.register(self)
  end 
  
  def activated?
    @cell.occupant || @cell.prop
  end
    
  def transition_to_actived?
    activated? && !@previously_activated
  end
  
  def transition_to_deactivated?
    @previously_activated && !activated?
  end
  
  def imagename
    activated? ? "button_down" : "button_up"
  end
        
end