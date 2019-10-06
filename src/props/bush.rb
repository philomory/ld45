class Bush < Prop
  register_type("Bush",self)
  
  def initialize(properties)
    super
    @group = (properties["group"] || :default).to_sym
    @blocks_player = false
  end
end