
class MarketReportController < ApplicationController
 
  def index
    market_reports = MarketReport.all
    render json: market_reports
  end

  def show
    @market_report = MarketReport.find(params[:id])
    render json: market_report
  end

  def create
    market_report = MarketReport.new(market_report_params)
    if market_report.save
      render json: market_report
    else
      render json: market_report.errors, status: :unprocessable_entity
    end
  end

  def update
    market_report = MarketReport.find(params[:id])
    if market_report.update(market_report_params)
      render json: market_report
    else
      render json: market_report.errors, status: :unprocessable_entity
    end
  end

  def top_5_markets_suggestions
    search_term = params[:search_term] == "all" ? '' :  params[:search_term]
    markets = {}
    MarketReport.all.each do |market_report|
      market_report.Market.split(',').each do |market|
        m = market.strip.downcase
        markets[m] = markets[m].nil? ? 1 : markets[m] + 1 if m.include?(search_term.strip.downcase)
      end
    end
    result = markets.sort_by { |_key, value| value }.reverse[0..4].map { |market| market[0] }
    render json: result
  end

  def top_5_products_suggestions
    search_term = params[:search_term] == "all" ? '' :  params[:search_term]
    products = {}
    MarketReport.all.each do |market_report|
      market_report.Product.split(',').each do |product|
        p = product.strip.downcase
        products[p] = products[p].nil? ? 1 : products[p] + 1 if p.include?(search_term.strip.downcase)
      end
    end
    result = products.sort_by { |_key, value| value }.reverse[0..4].map { |product| product[0] }
    render json: result
  end

  def market_report_params
    params.require(:work_mission).permit(
      :IdMarketReport,
      :Title,
      :Market,
      :Product,
      :ReportDate,
      :ReportDateShamsi,
      :Idfiles,
      :IssuedBy
    )
  end
end

