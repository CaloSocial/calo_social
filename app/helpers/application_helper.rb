module ApplicationHelper

  # Returns the full title on a per-page basis.
  def full_title(page_title) 
    base_title = "Calo: your adventure starts here"
    if page_title.empty? #if there's no page title, it uses base_title
      base_title
    else #otherwise it adds | and page title using string interpolation
      "#{base_title} | #{page_title}"
    end
  end
end