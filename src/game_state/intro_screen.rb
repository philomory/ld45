class GameState
  class IntroScreen < SequenceScreen
    class Part
      attr_accessor :alpha, :pause, :duration, :discard
      def initialize(text:, x:, y:,pause: 0.75, duration: 1.5, discard: false)
        @text = text
        @x, @y = x, y
        @pause, @duration, @discard = pause, duration, discard
        @alpha = 0
      end
      
      def color
        @alpha * 0x01000000 + 0x00FFFFFF
      end
      
      def draw
        font.draw(@text,@x,@y,0,0.25,0.25,color)
      end
      
      def font
        MediaManager.font('large')
      end
    end
    
    def initialize(key,*args,&blk)
      super(*args)
      @done_callback = blk
      @parts = _load_parts(key)
      @skip = 0
      @part_num = 0
      @finishing = false
      @parts.each_with_index do |part,index|
        subseq(part.duration) do |portion|
          @part_num = index
          @skip = 2
          part.alpha = (portion * 0xFF).floor
        end
        subseq(part.pause) {|_| @skip = 1 }
      end
      subseq(0.75) {|_| @finishing = true }
      subseq(1) do |portion|
        @finishing = true
        alpha = ((1-portion) * 0xFF).floor
        @parts.each do |p| 
          p.alpha = p.discard ? 0 : alpha
        end
      end
    end
    
    def draw
      super
      Gosu.scale(SCALE_FACTOR,SCALE_FACTOR) do
        @parts.each {|part| part.draw }
      end
    end
    
    def next_part!
      @parts[@part_num].alpha = 0xFF
      @skip.times { next_subseq! }
    end

    def done!
      game.game_state = GameState::FadeTransition.new(self,GameState::MainMenu.new(@game))
    end
    
    def handle_input(action)
      if [:quit,:pause].include?(action) || @finishing
        done!
      else
        next_part!
      end
    end
    
    def draw_world?
      false
    end
      
    def is_menu?
      true
    end
    
    private
    def _load_parts(key)
      path = File.join(DATA_ROOT,'intro.yml')
      data = YAML.load_file(path)
      parts = data[key]
      parts.map {|hsh| Part.new(**hsh) }
    end
  end
end