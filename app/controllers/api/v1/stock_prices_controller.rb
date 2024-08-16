class Api::V1::StockPricesController < ApplicationController  
  prepend_before_action :authenticate_with_api_key!

  def index
    price_all = GemStyle::LatestStockPrice.new().price_all

    if price_all.present?
      render json: price_all
    else
      render json: { status: "Data not exists." }, status: 401
    end
  end
end
