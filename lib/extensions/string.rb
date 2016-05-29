class String
  def render!(locals = {})
    locals.each { |name, value| gsub! "%#{name}%", value.to_s }
    self
  end
end
