module DocumentsHelper

  #Method called in show.html.erb@users return briefly formatted csv file
  def render_csv content_in
    hash_array = content_to_hash_array(content_in)
    header_array = get_header_array(content_in)
    return_str = ""
    hash_array.each do |h|
      header_array.each do |e|
        return_str = return_str + (h[:"#{e}"] || " ") + " | "
      end
      return_str += "\n"
    end
    return_str
  end

  def get_header_array content_in
    str_array = content_in.split(/\r\n|\t|\n|\r/)
    str_array[0].split(/\s*,\s*/)
  end

  def fix_file(params={}, content_in)
    @sort_by_input = params.delete(:sort_by)
    @rmv_duplicate_input = params.delete(:rmv_duplicate)
    @word_occurrence_input = params.delete(:word_occurrence)
    @customize_input = params.delete(:customize)
    @request_hash = {"sort_by" => @sort_by_input, "rmv_duplicate" => @rmv_duplicate_input, "word_occurrence" => @word_occurrence_input, "customize" => @customize_input}
    @content_in = content_in
    @content_array = content_to_hash_array(@content_in)
    puts "@content_array = #{@content_array}"
    puts "@sort_by = '#{@sort_by_input}' and is it truthy? #{@sort_by_input ? "true" : "false"} and class is: #{@sort_by_input.class}"
    puts "@customize = '#{@customize_input}' and is it truthy? #{@customize_input ? "true" : "false"} and class is: #{@customize_input.class}"

    fix_all_requests @request_hash
  end

  def content_to_hash_array content_in
    str_array = content_in.split(/\r\n|\t|\n|\r/)
    # puts "str_array: #{str_array}"
    header_array = str_array[0].split(/\s*,\s*/)
    # str_array = content_in.split(/\r\n|\t|\n|\r/)
    # header_array = str_array[0].split(/\s*,\s*/)
    header_hash = {}
    header_array.each do |header|
      header_hash[:"#{header}"] = header
    end
    hash_array = [header_hash]
    str_array[1..-1].each do |data_row|
      data_array = data_row.split(/\s*,\s*/)
      new_data_hash = {}
      data_array.each_with_index do |data, j|
        header_name = header_array[j]
        new_data_hash[:"#{header_name}"] = data
      end
      hash_array << new_data_hash
    end
    hash_array
  end

  def fix_all_requests hash_in
    hash_in.delete_if {|key, value| !value}
    puts "here's the new hash_in: #{hash_in}"
    hash_in.each {|key, value| self.public_send(key) if self.respond_to? key}
  end

  # def sort_by_first_value_number()
  #   #sort by first value, if number is the first value
  #   #converting to integers and comparing two items in the callback (sorting on them)
  #   array_of_lines! { |a, b| a[0].to_i <=> b[0].to_i }
  #   #modify the existing array
  #   array_of_lines.uniq!(&:first)
  #   array_of_lines.each { |line| p line }
  # end

  def sort_by
    puts "sort_by method inside Helper called!!!!!!!"
    header_array = get_header_array(@content_in)
    if !header_array.include? @sort_by_input
      puts "doesn't include that headerrrrrr header: #{header_array}"
      puts "@sort_by_input: #{@sort_by_input}, class: #{@sort_by_input.class}"
      return
    end
    @content_array = @content_array[1..-1].sort_by { |k| k[:"#{@sort_by_input}"] }
    puts "sorted: #{@content_array}"
  end


  def rmv_duplicate
    puts "rmv method called"
    @content_array = @content_array.uniq
  end

  def word_occurrence
    puts "word_occurrence method called"
    words = @content_in.split(/[^A-Za-z0-9]/)
    frequency = Hash.new(0)
    words.each do |word|
      word = word.gsub(/[^A-Za-z]/, "")
      if word != "" then frequency[word.downcase] += 1 end
    end
    puts "class: #{frequency.class}" 
    puts "frequency_before: #{frequency}"
    frequency = frequency.sort{ |l, r| l[1]<=>r[1] }.reverse
    # frequency.keys.sort.each { |key| puts frequency[key] }
    puts "frequency: #{frequency}"
    return frequency
  end

  def customize
    puts "customize method called"
  end

  # array_of_lines = []

  # import the file as an array
  # File.open("./FL_insurance_sample.csv", "r") do |f|
  #   f.each_line do |line|
  #   array_of_lines += line.split(/\t|\n|\r|\r\n/)
  # end

  # def sort_by_first_value_number()
  # #sort by first value, if number is the first value
  # #converting to integers and comparing two items in the callback (sorting on them)
  # array_of_lines! { |a, b| a[0].to_i <=> b[0].to_i }
  # #modify the existing array
  # array_of_lines.uniq!(&:first)
  # array_of_lines.each { |line| p line }
  # end

end
