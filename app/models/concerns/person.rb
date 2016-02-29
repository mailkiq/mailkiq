module Person
  def first_name
    name.split(' ').first if name?
  end

  def last_name
    name.split(' ')[1..-1].join(' ') if name?
  end
end
