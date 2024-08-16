module GemStyle
  require "uri"
  require "json"
  require "net/http"

  class LatestStockPrice
    def initialize
      @url = URI("https://latest-stock-price.p.rapidapi.com/any/")

      @https = Net::HTTP.new(@url.host, @url.port)
      @https.use_ssl = true
    end

    def price_all
      request = Net::HTTP::Get.new(@url)
      request["Content-Type"] = "application/json"
      request["x-rapidapi-key"] = ENV["rapid_key"]
      response = @https.request(request)

      return JSON.parse(response.read_body) rescue nil      
    end
  end
end