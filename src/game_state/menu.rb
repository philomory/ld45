class GameState
  class Menu < GameState
    
    def initialize(*args)
      super
      @position = 0
      @options = []
      #@background_image = MediaManager.image("credits")
      @title = ""
      setup_menu
    end
    
    
    def fullscreen?
      true
    end
    
    def add_option(text,&blk)
      @options << SimpleOption.new(text,blk)
    end
    
    def add_slider(text,min,cur,max,auto: true, &blk)
      @options << SliderOption.new(text,min,cur,max,auto,blk)
    end
    
    def menu_start_pos
      center_y + 25 - (@options.count * 25)
    end
    
    def draw
      #bg_color = (0xEE * (1.0 - fade_portion)).floor * 0x01000000
      #@background_image.draw(0,0,11)
      draw_text(@title,100,2)
      @options.each_with_index do |option,index|
        scale = (index == @position) ? 1.5 : 1
        ypos = menu_start_pos + (75 * index)
        draw_text(option.text,ypos,scale)
      end
    end
    
    def handle_input(action)
      case action
      when :south, :throw_south then @position += 1
      when :north, :throw_north then @position -= 1
      when :east, :throw_east then selected_option.incr!
      when :west, :throw_west then selected_option.decr!
      when :accept then trigger_selected
      when :pause then on_menu_button
      end
      @position %= @options.length
    end
    
    def on_menu_button
      back
    end
    
    def back
    end
    
    def inc
      
    end
    
    def dec
    end
      
    def transition_to(state)
      @game.game_state = GameState::FadeTransition.new(self,state)
    end
      
    def selected_option
      @options[@position]
    end
      
    def trigger_selected
      selected_option.activate!
    end
    
    def draw_text(msg,ypos,scale = 1)
      MediaManager.font('large').draw_rel(msg,center_x, ypos, 14,0.5,0.5,scale,scale)
    end
    
    def draw_world?
      false
    end
    
  end
end