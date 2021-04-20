require 'csv'

module Alphavantage
  class Client
    include HelperFunctions

    def initialize key:, verbose: false
      check_argument([true, false], verbose, "verbose")
      @apikey = key
      @base_uri = 'https://www.alphavantage.co'
      @verbose = verbose
    end

    attr_reader :verbose

    def verbose=(verbose)
      check_argument([true, false], verbose, "verbose")
      @verbose = verbose
    end

    def request(url)
      send_url = "#{@base_uri}/query?#{url}&apikey=#{@apikey}"
      puts "\n#{send_url}\n" if @verbose
      begin
        response = HTTParty.get(send_url)
      rescue StandardError => e
        raise Alphavantage::Error.new(message: "Failed request: #{e.message}")
      end
      data = response.body
      begin
        puts data if @verbose

        begin
          data = JSON.parse(data)
        rescue JSON::ParserError => e
          puts 'Failed to parse response JSON. Attempting CSV parsing.' if @verbose
          csv_data = CSV.parse(data)
          data = {
            headers: csv_data.first,
            items: csv_data[1...-1]
          }
        end
      rescue StandardError => e
        raise Alphavantage::Error.new(message: "Parsing failed", data: data)
      end

      error = nil
      if data.is_a?(Hash)
        error = data["Error Message"] || data["Information"] || data["Note"]
      end

      raise Alphavantage::Error.new(message: error, data: data) if error

      data
    end

    def download(url, file)
      send_url = "#{@base_uri}/query?#{url}&datatype=csv&apikey=#{@apikey}"
      begin
        puts send_url if @verbose
        uri = URI.parse(send_url)
        uri.open{|csv| IO.copy_stream(csv, file)}
      rescue StandardError => e
        raise Alphavantage::Error.new message: "Failed to save the CSV file: #{e.message}"
      end
      return "CSV saved in #{file}"
    end

    def search(keywords:, datatype: "json", file: nil)
      check_datatype(datatype, file)
      url = "function=SYMBOL_SEARCH&keywords=#{keywords}"
      return download(url, file) if datatype == "csv"
      output = OpenStruct.new
      output.output = request(url)
      bestMatches = output.output.dig("bestMatches") || {}
      output.stocks = bestMatches.map do |bm|
        val = OpenStruct.new
        bm.each do |key, valz|
          key_sym = recreate_metadata_key(key)
          val[key_sym] = valz
        end
        val.stock = Alphavantage::Stock.new(symbol: bm["1. symbol"], key: self)
        val
      end
      return output
    end

    def crypto(symbol:, market:, datatype: "json")
      Alphavantage::Crypto.new(
        symbol: symbol,
        key: self,
        datatype: datatype,
        market: market
      )
    end

    def earnings(symbol:, datatype: "json")
      Alphavantage::Earnings.new(symbol: symbol, key: self, datatype: datatype)
    end

    def earnings_calendar
      Alphavantage::EarningsCalendar.new(key: self)
    end

    def exchange(from:, to:, datatype: "json")
      Alphavantage::Exchange.new(from: from, to: to, key: self, datatype: datatype)
    end

    def sector
      Alphavantage::Sector.new(key: self)
    end

    def stock(symbol:, datatype: "json")
      Alphavantage::Stock.new(symbol: symbol, key: self, datatype: datatype)
    end
  end
end
