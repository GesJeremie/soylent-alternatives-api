class CurrenciesController < ApplicationController
  def show
    base = params[:base] || 'EUR'
    render json: get_response(base)
  end

  private
    def get_response(base)
      if Currency.where(base: base).empty?
        response = HTTParty.get("http://api.fixer.io/latest?base=#{base}").body

        currency = Currency.new do |currency|
          currency.base = base
          currency.response = response
        end

        currency.save
        
        return response
      end

      if Currency.where(base: base).first.updated_at < 1.day.ago 
        response = HTTParty.get("http://api.fixer.io/latest?base=#{base}").body

        currency = Currency.where(base: base).first
        currency.response = response
        currency.save

        return response
      end

      return Currency.where(base: base).first.response
    end
end
