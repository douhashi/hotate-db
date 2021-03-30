require 'csv'
require_relative 'build_page_navigations'

SOURCE_DIR = "data"
DIST_BASE = "dist"

def upper_part(page_title, data_name)
  <<~EOS
  <!DOCTYPE html>
  <html>
    <head>
      <!-- Required meta tags -->
      <meta charset="utf-8">
      <meta name="viewport" content="width=device-width, initial-scale=1">

      <!-- Bootstrap CSS -->
      <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.0-beta1/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-giJF6kkoqNQ00vy+HMDP7azOuL0xtbfIcaT9wjKHr8RbDVddVHyTfAAsrekwKmP1" crossorigin="anonymous">
      <title>#{page_title}</title>
    </head>
    <body>
      <header>
        <nav class="navbar fixed-top navbar-expand-lg navbar-light bg-light">
          <div class="container-fluid">
            <a class="navbar-brand" href="#">#{page_title}</a>
            <div>
              <ul class="navbar-nav">
                <form class="d-flex">
                  <a class="btn btn-outline-success" href="../data/#{data_name}.csv">ダウンロード</a>
                </form>
                <li class="nav-item">
                  <a class="nav-link active" href="../top.html">トップ</a>
                </li>
              </ul>
            </div>
          </div>
        </nav>
      </header>
      <main>
  EOS
end

def lower_part
  <<~EOS
      </main>
      <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.0-beta1/dist/js/bootstrap.bundle.min.js" integrity="sha384-ygbV9kiqUc6oa4msXn9868pTtWMgiQaeYH7/t7LECLbyPA2x65Kgf80OJFdroafW" crossorigin="anonymous"></script>
    </body>
  </html>
  EOS
end

def row(col_tag, col_values)
  html_row = "  <tr>"
  col_values.each do |value|
    html_row << "<#{col_tag}>#{value}</#{col_tag}>"
  end
  html_row << "</tr>\n"
end

def thead(header)
  temp = "<thead>\n"
  temp << row("th", header)
  temp << "</thead>\n"
end

def tbody(data)
  temp = "<tbody>\n"

  data.each do |row|
    temp << row("td", row)
  end

  temp << "</tbody>\n"
end

def table(header, data)
  table = "<table class=\"table\">\n"
  table << thead(header)
  table << tbody(data)
  table << "</table>\n"
end

def html_dir_path(data_name)
  "#{DIST_BASE}/#{data_name}"
end

def html_file_path(data_name, page_num)
  html_dir_path(data_name) << "/page_#{page_num}.html"
end

def generate_page(page_title, data_name, number_of_pages, page_num, header, data)
  File.open(html_file_path(data_name, page_num), "w") do |page|
    page << upper_part(page_title, data_name)
    page << table(header, data)
    page << page_navigations(number_of_pages, page_num)
    page << lower_part
  end
end

def source_file_path(data_name)
  "#{SOURCE_DIR}/#{data_name}.csv"
end

def generate_htmls(page_title, data_name, number_of_pages)
  page_num = 1
  header = ""
  data = []

  dir_path = html_dir_path(data_name)
  Dir.mkdir(dir_path) unless Dir.exist?(dir_path)

  CSV.foreach(source_file_path(data_name)) do |row|
    if header.empty?
      header = row
      next
    end

    data << row
    if (data.size % 100 == 0)
      generate_page(page_title, data_name, number_of_pages, page_num, header, data)
      data = []
      page_num += 1
    end
  end
  generate_page(page_title, data_name, number_of_pages, page_num, header, data)
end

generate_htmls("KDB", "kdb", 26)
generate_htmls("JAGES - 全国共通", "jages_kuriyama_all_2019", 24)
generate_htmls("JAGES - 栗山町", "jages_kuriyama_original_2019", 26)