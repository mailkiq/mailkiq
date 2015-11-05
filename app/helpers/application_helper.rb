module ApplicationHelper
  def title(string)
    content_for :title, string
  end

  def page_title
    content_for?(:title) ? content_for(:title) : 'Mailkiq'
  end
end
