require 'gosu'
require 'pry'

class Game < Gosu::Window
  def self.play!
    new.show
  end
  
  attr_accessor :input_manager #TODO: make static on InputManager class
  attr_accessor :paused 
  attr_reader :game_state, :world, :player, :enemies, :level, :animation_manager
  def initialize
    $game = self
    Settings.load

    super 896, 690, Settings[:fullscreen]

    @input_manager = InputManager
    @animation_manager = AnimationManager.new(self)
    self.game_state = GameState::TitleScreen.new(self)

    self.caption = "...and to Nothingness Return"
    
    @ui = UI.new(self)
    
    @levels = YAML.load_file(File.join(DATA_ROOT,'levels.yml'))

    MediaManager.play_music('title')
  end
  
  def toggle_fullscreen!
    Settings[:fullscreen] = !Settings[:fullscreen]
    Settings.save
    self.fullscreen = Settings[:fullscreen]
  end
    
  
  def start_game(level=Settings[:max_level])
    @level = level
    setup_level
  end

  def draw
    if @game_state.draw_world?
      @ui.draw
      
      Gosu.translate(0,UI_HEIGHT) do
        Gosu.scale(SCALE_FACTOR,SCALE_FACTOR,0,0) do
          MediaManager.image("background").draw(0,0,0)
          Gosu.translate(TILE_WIDTH,TILE_HEIGHT) do
            @world.grid.each(&:draw)
            @world.grid.each_edge(&:draw)
            @game_state.draw unless @game_state.fullscreen?
          end
        end
        #MediaManager.image("background0").draw(0,0,0) if @level == 0
      end
      @game_state.draw if @game_state.fullscreen?
    else
      @game_state.draw
    end
  end

  def button_down(id)
    if defined?(Pry)
      binding.pry if id == Gosu::KB_BACKTICK
      return (@skip_display = true; next_level) if id == Gosu::KB_PERIOD
      return (@skip_display = true; prev_level) if id == Gosu::KB_COMMA
    end
    if @game_state.needs_raw_input?
      @game_state.button_down(id)
    elsif !@input_processing
      @input_processing = true
      @input_manager.button_down(id)
    end
  end
  
  def animation_duration
    @game_state.animation_duration
  end
  
  def handle_input(action)
    case action
    when :quit then exit
    when :toggle_music then MediaManager.toggle_music
    when :toggle_sfx then MediaManager.toggle_sfx
    else @game_state.handle_input(action)
    end
  end
  
  def pause
    @paused = true
    self.game_state = GameState::PauseMenu.new
  end
  
  def unpause
    @paused = false
    self.game_state = GameState::WaitingForPlayer.new
  end
  
  def paused?
    @paused
  end
  
  def game_state=(state)
    return if @game_state&.locked?
    @game_state.on_exit if @game_state
    @game_state = state
    @game_state.on_enter if @game_state
  end
  
  def update
    @input_processing = false
    @animation_manager.play_if_pending!
    @game_state.update
  end
  
  def player_died
    schedule_animation(PlayerDeathAnimation.new) { self.game_state = GameState::PlayerDiedState.new }
  end
  
  def enemy_died(who)
    enemies.delete(who)
  end
  
  def schedule_animation(anim,&callback)
    @animation_manager.schedule_animation(anim,&callback)
  end
  
  def restart_level
    setup_level
  end
  
  def waiting_allowed?
    false # @world.waiting_allowed?
  end
  
  def next_level
    MediaManager.play_sfx('portal')
    @level += 1
    @level < @levels.count ? setup_level : to_be_continued
  end
  
  def prev_level
    MediaManager.play_sfx('portal')
    @level -= 1
    setup_level
  end
  
  def setup_level
    Settings[:max_level] = [@level,Settings[:max_level]].max
    MediaManager.play_song_for_level(@level)
    @world = World.new(@levels[@level])
    if @skip_display
      @skip_display = false
      UndoManager.level_start!
      self.game_state = GameState::WaitingForPlayer.new(self)
    else
      player.animating = true
      self.game_state = GameState::LevelSplashScreen.new(self) do 
        anim = FrameAnimation.new(player,'devouring',1750)
        anim.on_frame(4) do
          player.cell.terrain_collapse!
        end
        self.schedule_animation(anim) do
          player.cell.terrain_collapse! if player.cell.terrain != Terrain::Empty
          UndoManager.level_start!
          self.game_state = GameState::WaitingForPlayer.new(self)
        end
        MediaManager.play_sfx('start')
      end
    end
  end
  
  def to_be_continued
    self.game_state = GameState::YouWinScreen.new(self)
  end
    
  def player
    @world.player
  end
  
  def enemies
    @world.enemies
  end
  
  def needs_cursor?
    false
  end
  
  def in_menu?
    @game_state.is_menu?
  end
end
