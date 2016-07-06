class Prospect
  attr_reader :tag, :model

  def initialize(params)
    @tag = params.delete(:tag)
    @model = Subscriber.new params
  end

  def save
    _run { model.save }
  end

  def save!
    _run { model.save! }
  end

  private

  def _run
    merge_tags if tag.present?
    yield
    send_confirmation_instructions
    model
  end

  def automated_confirmation
    Automation.confirmation.where(account_id: model.account_id).first
  end

  def send_confirmation_instructions
    automation = automated_confirmation
    return false if automation.nil? || model.invalid?
    CampaignJob.enqueue automation.id, model.id
  end

  def merge_tags
    new_tag_ids = Tag.where(slug: tag, account_id: model.account_id).pluck(:id)
    model.tag_ids = model.tag_ids | new_tag_ids
  end
end
