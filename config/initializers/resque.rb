require 'resque/failure/multiple'
require 'resque/failure/redis'
require 'resque/failure/raven'

Resque::Failure::Multiple.classes = [
  Resque::Failure::Redis,
  Resque::Failure::Raven
]

Resque::Failure.backend = Resque::Failure::Multiple
