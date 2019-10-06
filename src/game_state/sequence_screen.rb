class GameState
  class SequenceScreen < GameState
    attr_accessor :loop_final
    def subseq(duration,&block)
      @timeline ||= []
      @timeline.push(SubSequence.new(duration,&block))
    end

    def draw
      (@current_subseq && @current_subseq.portion < 1.0) || next_subseq
      @current_subseq.draw if @current_subseq
    end

    def next_subseq!
      @current_subseq.finish! if @current_subseq
      next_subseq
    end

    def next_subseq
      if not @timeline.empty?
        @current_subseq = @timeline.shift
      elsif @loop_final
        @current_subseq.restart
      elsif @current_subseq
        self.done!
        @current_subseq = nil
      end
    end

    def done!
      raise "Subclass needs to impliment #done! method!"
    end
  end
end
