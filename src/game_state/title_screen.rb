class GameState
  class TitleScreen < SequenceScreen
    
    def initialize(*args)
      super
      @bg_alpha = 0
      @prompt_alpha = 0
      subseq(0.5) do |portion|
        @bg_alpha = (0xFF * portion).floor
      end
      subseq(3.0) {|_| }
      subseq(0.3) do |portion|
        @prompt_alpha = (0xFF * portion).floor
      end 
    end

    def color(alpha)
      alpha * 0x01000000 + 0x00FFFFFF
    end

    def on_enter
      @start_time = Time.now
    end

    def draw
      super
      MediaManager.image("title_screen").draw(0,0,11,1,1,color(@bg_alpha))
      MediaManager.font('large').draw_rel("press any key",center_x*2, 550,14,0.5,0.5,1,1,color(@prompt_alpha))
    end
    
    def handle_input(any)
      @game.game_state = GameState::FadeTransition.new(self,GameState::IntroScreen.new(@game))
    end
    
    def draw_world?
      false
    end

    def done!
    end
  end
end