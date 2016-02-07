class Template
  def self.render(source, context = {})
    final = source.dup
    context.each { |key, value| final.gsub! "%#{key}%", value }
    final
  end
end
