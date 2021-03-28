require 'csv'

SOURCE_DIR = "data"
DIST_DIR = "dist"

def line(col_tag, col_values)
  html_row = "  <tr>"
  col_values.each do |value|
    html_row << "<#{col_tag}>#{value}</#{col_tag}>"
  end
  html_row << "</tr>\n"
end

def thead(page, header)
  page << "<thead>\n"
  page << line("th", header)
  page << "</thead>\n"
end

def tbody(page, data)
  page << "<tbody>\n"

  data.each do |row|
    page << line("td", row)
  end

  page << "</tbody>\n"
end

def generate_page(file_path, header, data)
  File.open(file_path, "w") do |page|
    page << "<table>\n"
    thead(page, header)
    tbody(page, data)
    page << "</table>\n"
  end
end

def source_file_path(data_name)
  "#{SOURCE_DIR}/#{data_name}.csv"
end

def html_file_path(data_name, page_num)
  "#{DIST_DIR}/#{data_name}/page_#{page_num}.html"
end

def generate_htmls(data_name)
  page_num = 1
  header = ""
  data = []

  CSV.foreach(source_file_path(data_name)) do |row|
    if header.empty?
      header = row
      next
    end

    data << row
    if (data.size % 100 == 0)
      generate_page(html_file_path(data_name, page_num), header, data)
      data = []
      page_num += 1
    end
  end
  generate_page(html_file_path(data_name, page_num), header, data)
end

generate_htmls("jages_kuriyama_original_2019")
