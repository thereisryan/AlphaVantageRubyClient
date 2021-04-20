module Alphavantage
  class EarningsCalendar
    include HelperFunctions

    def initialize(key:, datatype: 'json', verbose: false)
      check_argument([true, false], verbose, 'verbose')
      @client = return_client(key, verbose)
      @datatype = datatype
    end

    attr_reader :datatype

    def datatype=(datatype)
      check_argument(%w[json csv], datatype, "datatype")
      @datatype = datatype
    end

    def call(file: nil)
      check_datatype(@datatype, file)

      url = 'function=EARNINGS_CALENDAR'
      return @datatype == 'json' ?
        open_struct(url, "Upcoming Earnings Events") :
        @client.download(url, file)
    end
  end
end
