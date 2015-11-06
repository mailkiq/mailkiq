Rails.application.config.assets.configure do |env|
  es6amd = Sprockets::ES6.new('modules' => 'amd', 'moduleIds' => true)
  # Replace the default transformer to transpile each `.es6` file with `define`
  # and `require` from the AMD spec.
  # Just be sure to add `almond.js` to the application and
  # require it before requiring other assets on `application.js`
  env.register_transformer 'text/ecmascript-6', 'application/javascript', es6amd
end
