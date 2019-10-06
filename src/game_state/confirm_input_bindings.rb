class GameState
  class ConfirmInputBindings < Menu
    
    def setup_menu
      @title = "New Bindings"
      add_option("Accept") { accept }
      add_option("Cancel") { cancel }
    end
    
    def menu_start_pos
      475
    end
    
    def accept
      InputManager.save_bindings
      back
    end
    
    def cancel
      InputManager.load_from_settings
      back
    end
    
    def back
      transition_to(GameState::ConfigMenu.new)
    end
    
    def draw
      super
      InputManager.current_manager.current_bindings.each_with_index {|(desc, keys),index| draw_binding(desc,keys,index) }
    end
    
    def draw_binding(desc,keys,index)
      font = MediaManager.font('small')
      ypos = 150 + 28 * index
      key_str = names_for(keys)
      font.draw_rel("#{desc}:",center_x-80, ypos, 14,1.0,0.5)
      font.draw_rel(key_str,center_x-70,ypos, 14, 0.0, 0.5)
    end
    
    def names_for(keys)
      keys.map(&method(:name_of_key)).join(", ")
    end
    
    def name_of_key(key)
      char = Gosu.button_id_to_char(key)
      return char.upcase if char.length > 0
      sym = (Gosu.constants - [:MAJOR_VERSION, :MINOR_VERSION, :POINT_VERSION, :VERSION, :LICENSES]).find {|const| Gosu.const_get(const) == key }
      if sym
        name = sym.to_s
        name = name.start_with?("KB_") ? name[3..-1] : name
        return name.tr('_',' ')
      end
      key
    end
    
  end
end