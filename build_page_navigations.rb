NUMBER_OF_BUTTON = 10
NUMBER_OF_PAGE = 26
BUTTON_THRESHOLD = NUMBER_OF_BUTTON / 2
DISABLED = " disabled"

def pagenation_upper_part(disabled = "")
  <<~EOS
        <div class="container-fluid">
          <nav aria-label="Page navigation">
            <ul class="pagination justify-content-center">
              <li class="page-item">
                <a class="page-link#{disabled}" href="#" aria-label="Previous">
                  <span aria-hidden="true">&laquo;</span>
                </a>
              </li>
  EOS
end

def pagenation_lower_part(disabled = "")
  <<~EOS
              <li class="page-item">
                <a class="page-link#{disabled}" href="#" aria-label="Next">
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

def page_numbers(first, current_page)
  temp = ""

  NUMBER_OF_BUTTON.times do |index|
    if current_page > NUMBER_OF_PAGE - BUTTON_THRESHOLD
      page_num = index + (NUMBER_OF_PAGE - NUMBER_OF_BUTTON) + 1
    else
      page_num = first + index
    end

    temp << "      <li class=\"page-item#{active(page_num, current_page)}\"><a class=\"page-link\" href=\"#{page_num}\">#{page_num}</a></li>\n"
  end

  temp
end

def page_navigations(current_page)
    temp = ""

    # Previous
    if current_page > BUTTON_THRESHOLD
      first = current_page - (BUTTON_THRESHOLD - 1)
      temp << pagenation_upper_part
    else
      first = 1
      temp << pagenation_upper_part(DISABLED)
    end

    # Page numbers
    temp << page_numbers(first, current_page)

    # Next
    if current_page > NUMBER_OF_PAGE - BUTTON_THRESHOLD
      last = NUMBER_OF_PAGE
      temp << pagenation_lower_part(DISABLED)
    else
      last = current_page + BUTTON_THRESHOLD
      temp << pagenation_lower_part
    end

    temp
end
