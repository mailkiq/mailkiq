class ScopeChain
  SCOPES = [OpenedScope, TagScope, SentScope].freeze

  def initialize(campaign)
    @campaign = campaign
  end

  def call
    relation = Subscriber.activated.where(account_id: @campaign.account_id)
    SCOPES.each do |klass|
      new_relation = klass.new(relation, @campaign).call
      relation = new_relation if new_relation
    end
    relation
  end

  def count
    @count ||= call.count
  end

  def to_sql
    call.to_sql
  end

  def tags
    native_tags + opened_campaigns + sent_campaigns
  end

  private

  def native_tags
    items = Tag.where(account_id: @campaign.account_id).pluck(:id, :name)
    items.map! do |item|
      [item.last, "tag:#{item.first}"]
    end
  end

  def opened_campaigns
    items = Campaign.where(account_id: @campaign.account_id).sent
    items.pluck(:id, :name).map do |item|
      [I18n.t('scopes.opened', name: item.last), "opened:#{item.first}"]
    end
  end

  def sent_campaigns
    items = Campaign.where(account_id: @campaign.account_id).sent
    items.pluck(:id, :name).map do |item|
      [I18n.t('scopes.sent', name: item.last), "sent:#{item.first}"]
    end
  end
end
