class String
  def render!(locals = {})
    locals.each do |name, value|
      gsub! "%#{name}%", value
    end
    self
  end
end
