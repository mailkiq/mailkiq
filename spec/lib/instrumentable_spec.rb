require 'spec_helper'
require 'instrumentable'

class FatherCat
  include Instrumentable

  def hello_everynyan
  end

  def fake_cat
  end

  def osaka
  end

  def teachers(home, pe, geo)
  end

  def self.omg
  end

  def self.sorry
    "I'mma so sorry"
  end

  def self.who?(_person)
  end

  # String
  instrument_method :hello_everynyan, 'fathercat.greet', payload: 'FatherCat'
  # Symbol
  instrument_method :fake_cat, 'fathercat.rant', payload: :look_alike
  # Proc
  instrument_method :osaka, 'fathercat.ask', payload: -> { 'also cat tounged' }
  # Args
  instrument_method :teachers, 'fathercat.teachers', payload: 'teachers'

  # Class
  class_instrument_method self, :omg, 'fathercat.anger', payload: :sorry
  # Args
  class_instrument_method self, :who?, 'fathercat.who', payload: 'who?'
end

describe Instrumentable do
  describe '.instrument_method' do
    it 'must instrument fathercat.greet' do
      cat = FatherCat.new
      expected = ['fathercat.greet-FatherCat']
      events = []

      callback = -> (*args) { events << "#{args.first}-#{args.last[:payload]}" }
      ActiveSupport::Notifications.subscribed(callback, 'fathercat.greet') do
        cat.hello_everynyan
        ActiveSupport::Notifications.instrument('some.other.event')
      end
      expect(events).to eq expected
    end

    it 'must instrument fathercat.rant' do
      cat = FatherCat.new

      def cat.look_alike
        'Mori'
      end

      expected = ["fathercat.rant-#{cat.look_alike}"]
      events = []

      callback = -> (*args) { events << "#{args.first}-#{args.last[:payload]}" }
      ActiveSupport::Notifications.subscribed(callback, 'fathercat.rant') do
        cat.fake_cat
        ActiveSupport::Notifications.instrument('some.other.event')
      end
      expect(events).to eq expected
    end

    it 'must instrument fathercat.ask' do
      cat = FatherCat.new
      expected = ['fathercat.ask-also cat tounged']
      events = []

      callback = -> (*args) { events << "#{args.first}-#{args.last[:payload]}" }
      ActiveSupport::Notifications.subscribed(callback, 'fathercat.ask') do
        cat.osaka
        ActiveSupport::Notifications.instrument('some.other.event')
      end
      expect(events).to eq expected
    end

    it 'must pass method args to payload' do
      cat = FatherCat.new
      name = { home: 'Yukari', pe: 'Nyamo', geo: 'Kimura' }
      expected = [
        "fathercat.teachers-#{name[:home]}_#{name[:pe]}_#{name[:geo]}"
      ]
      events = []

      callback = lambda do |*args|
        event_name = args.first
        payload = args.last[:_method_args].join('_')
        events << "#{event_name}-#{payload}"
      end
      ActiveSupport::Notifications.subscribed(callback, 'fathercat.teachers') do
        cat.teachers(name[:home], name[:pe], name[:geo])
        ActiveSupport::Notifications.instrument('some.other.event')
      end
      expect(events).to eq expected
    end
  end

  describe '.class_instrument_method' do
    it 'must instrument fathercat.anger' do
      expected = ["fathercat.anger-#{FatherCat.sorry}"]
      events = []

      callback = -> (*args) { events << "#{args.first}-#{args.last[:payload]}" }
      ActiveSupport::Notifications.subscribed(callback, 'fathercat.anger') do
        FatherCat.omg
        ActiveSupport::Notifications.instrument('some.other.event')
      end
      expect(events).to eq expected
    end

    # class_instrument_method self, :who?, 'fathercat.who', :payload => 'who?'
    it 'must pass method args to payload' do
      person = 'chiyo'
      expected = ["fathercat.who-#{person}"]
      events = []

      callback = lambda do |*args|
        events << "#{args.first}-#{args.last[:_method_args].first}"
      end
      ActiveSupport::Notifications.subscribed(callback, 'fathercat.who') do
        FatherCat.who?(person)
        ActiveSupport::Notifications.instrument('some.other.event')
      end
      expect(events).to eq expected
    end
  end
end
