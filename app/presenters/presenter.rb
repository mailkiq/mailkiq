class Presenter < SimpleDelegator
  attr_reader :model

  def initialize(model, view_context)
    @model = model
    __setobj__ view_context
  end

  def eql?(other)
    other == self || model.eql?(other)
  end
end
