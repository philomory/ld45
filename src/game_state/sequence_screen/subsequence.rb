class GameState
  class SequenceScreen
    class SubSequence
      def initialize(duration,&block)
        @duration, @block = duration, block
        @force_finish = false
      end
      
      def draw
        @start_time ||= Time.now
        @block.call(portion)
      end
      
      def restart
        @start_time = nil
        @force_finish = false
      end

      def finish!
        @force_finish = true
      end
      
      def portion
        if @force_finish
          1.0 
        elsif @start_time
          [((Time.now - @start_time) / @duration),1.0].min
        else
          0.0
        end
      end
    end
  end
end