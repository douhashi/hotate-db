require 'csv'

SOURCE_DIR = "data"
DIST_DIR = "dist"

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
  table = "<table>\n"
  table << thead(header)
  table << tbody(data)
  table << "</table>\n"
end

def generate_page(file_path, header, data)
  File.open(file_path, "w") do |page|
    page << table(header, data)
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
