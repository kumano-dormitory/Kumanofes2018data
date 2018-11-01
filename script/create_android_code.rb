require 'csv'

error = false

if !File.exist?("../list2018.csv")
  puts "[Error] list.csv does not exist."
  exit
end

current_day = "1130"
tmp_str = ""
tmp_str_write_f = false

tmp_permanent = ""
tmp_gerira = ""

path_list = []
url_hash = {}

i = 0
File.open("./for_android.txt", "w+") do |f|

  csv_data = CSV.read('../list2018.csv', encoding: 'utf-8', headers: true)
  csv_data.each_with_index do |data, id|

    if (data['type'] == "0") then
      if (current_day != data['start_day']) then
        f.write(tmp_str)
        f.write("\n-------------------------------------------\n\n-----------------------------------------------")
        current_day = data['start_day']
        tmp_str = ""
      end
      tmp_str = "#{tmp_str},\nlistOf<String>(\"#{data['title']}\",\"#{data['details']}\",\"#{data['start_day'][0..1]}/#{data['start_day'][2..3]} #{data['start_at']}\",\"#{data['end_day'][0..1]}/#{data['end_day'][2..3]} #{data['end_at']}\",\"#{data['place']}\",\"#{data['path']}\")"
      tmp_str_write_f = true
      url_hash["#{data['path']}#{data['start_day']}"] = "https://kumano-dormitory.github.io/ryosai2018/2018-#{data['start_day'][0..1]}-#{data['start_day'][2..3]}.html#event#{i}"
      i = i + 1
    elsif (data['type'] == "1") then
      if tmp_str_write_f then
          tmp_str_write_f = false
          f.write(tmp_str)
          f.write("\n----------------------------------------------\n")
      end
      tmp_permanent = "#{tmp_permanent},\nlistOf<String>(\"#{data['title']}\",\"#{data['details']}\",\"\",\"\",\"#{data['place']}\",\"#{data['path']}\")"
      url_hash["#{data['path']}#{data['start_day']}"] = "https://kumano-dormitory.github.io/ryosai2018/permanent.html#event#{i}"
      i = i + 1
    elsif (data['type'] == "2") then
      tmp_gerira = "#{tmp_gerira},\nlistOf<String>(\"#{data['title']}\",\"#{data['details']}\",\"\",\"\",\"#{data['place']}\",\"#{data['path']}\")"
      url_hash["#{data['path']}#{data['start_day']}"] = "https://kumano-dormitory.github.io/ryosai2018/guerrilla.html#event#{i}"
      i = i + 1
    end

    # パスの集合に追加する
    if (!data['path'].nil? && data['path'].strip != "") then
      path_list.push(data['path'])
    end
  end
  f.write("\n-------------------------------------------\n\n-----------------------------------------------")
  f.write(tmp_permanent)
  f.write("\n-------------------------------------------\n\n-----------------------------------------------")
  f.write(tmp_gerira)


  f.write("\nfor Resource Id match function\n")
  f.write("return when(path) {\n")
  path_list.each do |path|
    f.write("    \"#{path}\" -> R.drawable.#{path}\n")
  end
  f.write("    else -> R.drawable.ic_launcher_background\n}\n")

  f.write("\n\n\n For URL Path match function\n")
  f.write("return when (path) {\n")
  url_hash.each do |path, url|
    f.write("    \"#{path}\" -> \"#{url}\"\n")
  end
  f.write("    else -> \"https://kumano-dormitory.github.io/ryosai2018/\"\n}\n")

  if error then
    puts "Creating json file ended with error."
  else
    puts "Creating json file successfully ended."
  end

end
