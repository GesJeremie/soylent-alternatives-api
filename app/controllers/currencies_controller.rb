class CurrenciesController < ApplicationController
  
  FIXER_API_KEY = '5d7a931c37d2c0eb5c91dbcca63aeaeb'.freeze

  def show
    base = params[:base] || 'EUR'
    render json: get_response(base)
  end

  private
    def get_response(base)
      if Currency.where(base: base).empty?
        response = HTTParty.get("http://data.fixer.io/api/latest?base=#{base}&access_key=#{access_key}").body

        currency = Currency.new do |currency|
          currency.base = base
          currency.response = response
        end

        currency.save
        
        return response
      end

      if Currency.where(base: base).first.updated_at < 1.day.ago 
        response = HTTParty.get("http://data.fixer.io/api/latest?base=#{base}&access_key=#{access_key}").body

        currency = Currency.where(base: base).first
        currency.response = response
        currency.save

        return response
      end

      return Currency.where(base: base).first.response
    end

    def access_key
      FIXER_API_KEY
    end
end
