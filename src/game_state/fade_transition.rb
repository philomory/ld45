class GameState
  class FadeTransition < GameState
    def initialize(from,to)
      @from, @to = from, to
      @fade_duration = 1000
      super()
    end
    
    def draw_world?
      false
    end
    
    def on_enter
      @start_time = Gosu.milliseconds
    end

    def run_time
      Gosu.milliseconds - @start_time
    end
    
    def portion
      [[(run_time.to_f / @fade_duration.to_f),0].max,2].min
    end

    def update
      finish if portion >= 2
    end
    
    def finish
      @game.game_state = @to
    end

    def draw
      if portion < 1
        @from.draw
        draw_overlay(portion)
      else
        @to.draw
        draw_overlay(2-portion)
      end
    end
      
    def draw_overlay(fraction)
      fraction = [[0,fraction].max,1].min
      bg_color = (0xFF * fraction).floor * 0x01000000
      Gosu.draw_rect(0,0,@game.width,@game.height,bg_color,99999)
    rescue RangeError => e
      p({
        portion: portion,
        fraction: fraction,
        bg_color: bg_color,
        width: @game.width,
        height: @game.height,
      })
      raise
    end
      
  end
end