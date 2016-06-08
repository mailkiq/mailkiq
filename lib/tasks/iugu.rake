namespace :iugu do
  desc 'Create plans'
  task prepare: :environment do
    create name: 'Plano Essentials',
           identifier: 'essentials_plan',
           price: 199,
           emails: 100_000

    create name: 'Plano Pro',
           identifier: 'pro_plan',
           price: 599,
           emails: 300_000

    create name: 'Plano Premier',
           identifier: 'premier_plan',
           price: 999,
           emails: 500_000
  end

  def create(params = {})
    Iugu::Plan.create(
      name: params.fetch(:name),
      identifier: params.fetch(:identifier),
      interval: 1,
      interval_type: 'months',
      value_cents: params.fetch(:price) * 100,
      payable_with: 'credit_card',
      features: prepare_features(params.fetch(:emails))
    )
  end

  def prepare_features(value)
    [{ name: 'Número de Emails', identifier: 'emails', value: value }]
  end
end
