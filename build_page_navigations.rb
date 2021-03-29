NUMBER_OF_BUTTON = 10
BUTTON_THRESHOLD = NUMBER_OF_BUTTON / 2
DISABLED = " disabled"

def previous_part(current_page)
  if current_page == 1
    disabled = DISABLED
    link = "#"
  else
    disabled = ""
    link = "./page_#{current_page - 1}.html"
  end

  <<~EOS
        <div class="container-fluid">
          <nav aria-label="Page navigation">
            <ul class="pagination justify-content-center">
              <li class="page-item#{disabled}">
                <a class="page-link" href="#{link}" aria-label="Previous">
                  <span aria-hidden="true">&laquo;</span>
                </a>
              </li>
  EOS
end

def next_part(number_of_pages, current_page)
  if current_page == number_of_pages
    disabled = DISABLED
    link = "#"
  else
    disabled = ""
    link = "./page_#{current_page + 1}.html"
  end

  <<~EOS
              <li class="page-item#{disabled}">
                <a class="page-link" href="#{link}" aria-label="Next">
                  <span aria-hidden="true">&raquo;</span>
                </a>
              </li>
            </ul>
          </nav>
        </div>
  EOS
end

def active(page_num, current_page)
  page_num == current_page ? " active" : ""
end

def page_numbers(number_of_pages, first, current_page)
  temp = ""

  NUMBER_OF_BUTTON.times do |index|
    if current_page > number_of_pages - BUTTON_THRESHOLD
      page_num = index + (number_of_pages - NUMBER_OF_BUTTON) + 1
    else
      page_num = first + index
    end

    temp << "      <li class=\"page-item#{active(page_num, current_page)}\"><a class=\"page-link\" href=\"./page_#{page_num}.html\">#{page_num}</a></li>\n"
  end

  temp
end

def page_navigations(number_of_pages, current_page)
    temp = ""

    # Previous
    if current_page > BUTTON_THRESHOLD
      first = current_page - (BUTTON_THRESHOLD - 1)
    else
      first = 1
    end
    temp << previous_part(current_page)

    # Page numbers
    temp << page_numbers(number_of_pages, first, current_page)

    # Next
    temp << next_part(number_of_pages, current_page)
end