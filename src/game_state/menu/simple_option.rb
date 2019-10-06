class GameState
  class Menu
    class SimpleOption < Option
      def initialize(text, action)
        @text, @action = text, action
      end
      
      def text
        @text.respond_to?(:call) ? @text.call : @text
      end
      
      def activate!
        @action.call
      end
    end
  end
end