class CustomPaginationRenderer < WillPaginate::ActionView::LinkRenderer
  def to_html
    html = '<nav aria-label="Page navigation example"><ul class="pagination justify-content-end">'
    html += page_items
    html += '</ul></nav>'
    html.html_safe
  end

  private

  def page_items
    items = []
    items << previous_page
    items += windowed_page_numbers.map { |page| page_link_or_span(page) }
    items << next_page
    items.join
  end

  def previous_page
    if @collection.previous_page
      tag(:li, link("Previous", url(@collection.previous_page), class: 'page-link'), class: 'page-item')
    else
      tag(:li, link("Previous", "#", class: 'page-link'), class: 'page-item disabled')
    end
  end

  def next_page
    if @collection.next_page
      tag(:li, link("Next", url(@collection.next_page), class: 'page-link'), class: 'page-item')
    else
      tag(:li, link("Next", "#", class: 'page-link'), class: 'page-item disabled')
    end
  end

  def page_link_or_span(page)
    if page == current_page
      tag(:li, link(page, "#", class: 'page-link'), class: 'page-item active')
    else
      tag(:li, link(page, url(page), class: 'page-link'), class: 'page-item')
    end
  end
end
