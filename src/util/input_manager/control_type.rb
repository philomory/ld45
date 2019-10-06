class InputManager
  class ControlType
    include Gosu
    
    def self.register(key)
      @key = key
      InputManager.register(key, self)
    end
    
    def self.key
      @key
    end
    
    attr_reader :queued_input
    def initialize
      @queued_input = []
      setup_bindings
    end
    
    def queue_input(action)
      @queued_input.push(action) if @queued_input.empty?
    end
    
    def clear_queue!
      @queued_input.clear
    end
    
    def save_bindings
      Settings.set_key_path(:input,:bindings,self.class.key,settings_dump)
    end
  end
end