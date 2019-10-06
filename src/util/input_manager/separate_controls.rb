class InputManager
  class SeparateControls < ControlType

    register :separate

    DEFAULT_BINDINGS = {
      KbW => :north,
      KbS => :south,
      KbA => :west,
      KbD => :east,
      KbUp => :throw_north,
      KbDown => :throw_south,
      KbLeft => :throw_west,
      KbRight => :throw_east,
      KbEscape => :pause,
      KbR => :restart,
      KbU => :undo,
      KbZ => :undo
    }.freeze
    
    BIND_LIST = {
      north: "Move Up",
      south: "Move Down",
      west: "Move Left",
      east: "Move Right",
      throw_north: "Throw Up",
      throw_south: "Throw Down",
      throw_west: "Throw Left",
      throw_east: "Throw Right",
      pause: "Pause Game",
      restart: "Restart Level",
      undo: "Undo Move"
    }.freeze
    
    def self.default_bindings
      DEFAULT_BINDINGS
    end
    
    def setup_bindings
      @input_bindings = Settings[:input][:bindings][:separate]
    end
    
    def settings_dump
      @input_bindings.dup
    end
    
    def restore_default_bindings
      @input_bindings = DEFAULT_BINDINGS.dup
    end
    
    def bindings=(bindings)
      @input_bindings = bindings.invert
    end
    
    def bind_list
      self.class::BIND_LIST.dup
    end
    
    def current_bindings
      action_keys = Hash.new {|h,k| h[k] = []}
      @input_bindings.each_pair {|key,action| action_keys[action] << key }
      bind_list.map {|action, desc| [desc, action_keys[action]] }
    end
  
    def action_for_button_id(id)
      @input_bindings[id]
    end
  end
end