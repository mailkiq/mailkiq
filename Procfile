web: bundle exec puma -C config/puma.rb
worker: QUEUE=* rake environment resque:work
