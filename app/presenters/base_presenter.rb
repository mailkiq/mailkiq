class BasePresenter < SimpleDelegator
  attr_reader :record

  def initialize(record, view_context)
    @record = record
    __setobj__ view_context
  end
end
