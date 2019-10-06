class InputManager
  class MenuControls < ControlType

    register :menu
    
    DEFAULT_BINDINGS = {
      KbUp => :north,
      KbDown => :south,
      KbLeft => :west,
      KbRight => :east,
      KbEscape => :quit,
      KbSpace => :accept,
      KbEnter => :accept,
      KbReturn => :accept
    }.freeze
    
    def setup_bindings
    end
  
    def action_for_button_id(id)
      DEFAULT_BINDINGS[id]
    end
    
  end
end