module HelperFunctions
  def method_missing(method, *args, &block)
    raise Alphavantage::Error.new message: "#{method} is undefined for #{self.class}"
  end

  def check_argument(list, value, attribute)
    unless list.include? value
      list.each{|l| l = "nil" if l.nil?}
      raise Alphavantage::Error.new message: "Only #{list.join(", ")} are supported for #{attribute}",
        data: {"list_valid" => list, "wrong_value" => value, "wrong_attribute" => attribute}
    end
  end

  def check_datatype(datatype, file)
    if datatype == "csv" && file.nil?
      raise Alphavantage::Error.new message: "No file specified where to save the CSV data"
    elsif datatype != "csv" && !file.nil?
      raise Alphavantage::Error.new message: "Hash error: No file necessary"
    end
  end

  def open_struct(url, type)
    output = OpenStruct.new
    output.output = @client.request(url)

    global_quote = output.output.dig(type) || {}
    global_quote.each do |key, val|
      key_sym = recreate_metadata_key(key)
      output[key_sym] = val
    end

    output
  end

  def return_matype(val, val_string)
    check_argument(["0", "1", "2", "3", "4", "5", "6", "7", "8", "SMA", "EMA", "WMA", "DEMA", "TEMA", "TRIMA", "T3", "KAMA", "MAMA"], val, "ma_type")
    hash = {"SMA" => "0", "EMA" => "1", "WMA" => "2", "DEMA" => "3",
      "TEMA" => "4", "TRIMA" => "5", "T3" => "6", "KAMA" => "7", "MAMA" => "8"}
    val = hash[val] unless hash[val].nil?
    return "&#{val_string}=#{val}"
  end

  def return_int_val(val, val_string, type="integer", check_positivity=true)
    value = case type
    when "integer"
      val.to_i
    when "float"
      val.to_f
    end
    if value.to_s != val
      Alphavantage::Error.new message: "Error: #{val_string} is not a correct number"
    elsif check_positivity && value <= 0
      Alphavantage::Error.new message: "Error: #{val_string} is not a correct positive #{type}"
    end
    return "&#{val_string}=#{val}"
  end

  def return_client(key, verbose=false)
    if key.is_a?(String)
      client = Alphavantage::Client.new key: key, verbose: verbose
    elsif key.is_a?(Alphavantage::Client)
      client = key
    else
      raise Alphavantage::Error.new message: "Key should be a string"
    end
    return client
  end

  def return_value(hash, val)
    return hash.find{|key, value| key.include?(val)}&.dig(1)
  end

  def return_series(series, order)
    order ||= "desc"
    check_argument(["asc", "desc"], order, "order")
    return series.sort_by{ |hsh| hsh[0]} if order == "asc"
    return series
  end

  def recreate_metadata_key(key)
    key_sym = key.split(" ")
    key_sym.shift if key_sym.size > 1
    if key_sym[-1] == "(USD)"
      key_sym[-1] = "USD"
    elsif key_sym[-1].include?("(") && key_sym[-1].include?(")")
      key_sym.pop
    end
    key_sym = key_sym.join("_")
    key_sym = key_sym.downcase.lstrip.gsub(" ", "_")
    key_sym = key_sym.to_sym
    return key_sym
  end

  def which_series(type, name_series, adjusted: false)
    check_argument(["intraday", "daily", "weekly", "monthly"], type, "type")
    series = "#{name_series}_"
    series += type.upcase
    series += "_ADJUSTED" if adjusted
    return series
  end
end
