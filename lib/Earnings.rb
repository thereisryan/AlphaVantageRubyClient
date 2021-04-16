module Alphavantage
  class Earnings
    include HelperFunctions

    def initialize (symbol:, datatype: "json", key:, verbose: false)
      check_argument([true, false], verbose, "verbose")
      @client = return_client(key, verbose)
      @symbol = symbol
      @datatype = datatype
    end

    attr_accessor :symbol
    attr_reader :datatype #Opens up attributes to the @ variables via accessors without the @ sign

    def datatype=(datatype)
      check_argument(["json", "csv"], datatype, "datatype")
      @datatype = datatype
    end

    def earnings
      url = "function=EARNINGS&symbol=#{@symbol}"
      return open_struct(url, "Quarterly earnings data")
    end
  end
end