module Alphavantage
  class EarningsCalendar
    include HelperFunctions

    def initialize(key:, verbose: false)
      check_argument([true, false], verbose, "verbose")
      @client = return_client(key, verbose)
      @datatype = "csv"
    end

    attr_reader :datatype

    def datatype=(datatype)
      check_argument(["csv"], datatype, "datatype")
      @datatype = datatype
    end

    def calendar(file:)
      check_datatype(@datatype, file)

      url = "function=EARNINGS_CALENDAR"
      return @client.download(url, file)
    end
  end
end
