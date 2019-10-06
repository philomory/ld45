class InputManager
  
  METHODS = {}
  
  def self.register(key,klass)
    METHODS[key] = klass
  end
  
  def self.controls(type=:modifier)
    METHODS[type]
  end
  
  def self.input_style=(key)
    @current_manager = controls(key).new
    Settings.set_key_path(:input, :input_style, key)
  end
  
  def self.current_manager
    @current_manager ||= controls.new
  end
  
  def self.menu_controls
    @menu_controls ||= controls(:menu).new
  end
  
  def self.button_down(id)
    action = current_manager.action_for_button_id(id)
    action ||= menu_controls.action_for_button_id(id) if $game.in_menu?
    $game.handle_input(action)
  end
  
  def self.queue_input(action)
    current_manager.queue_input(action)
  end
  
  def self.queued_input
    current_manager.queued_input
  end

  def self.clear_queue!
    current_manager.clear_queue!
  end

  def self.restore_default_bindings
    current_manager.restore_default_bindings
  end
  
  def self.save_bindings
    current_manager.save_bindings
  end
  
  def self.defaults
    {
      input_style: :modifier,
      bindings: METHODS.reject {|k,v| k == :menu }.map {|key,klass| [key, klass.default_bindings]}.to_h
    }
  end
  
  def self.load_from_settings
    self.input_style = Settings[:input][:input_style]
  end

end