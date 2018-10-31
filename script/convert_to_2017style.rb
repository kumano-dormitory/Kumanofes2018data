require 'csv'

error = false

if !File.exist?("../list2018.csv")
  puts "[Error] list.csv does not exist."
  exit
end


File.open("../list_style2017.csv", "w+") do |f|

  f.write("type,start_day,start_at,end_day,end_at,file_path,title,where,detail,url\n")

  csv_data = CSV.read('../list2018.csv', encoding: 'utf-8', headers: true)
  csv_data.each_with_index do |data, id|

    tmp = ""

    if (data['type'] == "0") then
      tmp = "regular,#{data['start_day']},#{data['start_at']},#{data['end_day']},#{data['end_at']},"
      tmp = "#{tmp}images/#{data['start_day']}/#{data['path']}.#{data['ext']},"
    elsif (data['type'] == "1") then
      tmp = "permanent,,,,,"
      tmp = "#{tmp}images/permanent/#{data['path']}.#{data['ext']},"
    elsif (data['type'] == "2") then
      tmp = "guerrilla,,,,,"
      tmp = "#{tmp}images/guerrilla/#{data['path']}.#{data['ext']},"
    end

    tmp = "#{tmp}#{data['title']},#{data['place']},#{data['details']},"

    tmp = "#{tmp}\n"
    f.write(tmp)
  end

  if error then
    puts "Creating json file ended with error."
  else
    puts "Creating json file successfully ended."
  end

end
