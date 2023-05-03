
class MarketReportController < ApplicationController
 
  def index
    search_text = params[:search_text] == 'all' ? '' : params[:search_text]
    search_text.gsub(' ', '')
    # find all reports that contain search text in title or market or product
    market_reports = MarketReport.where(State: nil).
    where("replace(Title, ' ', '') LIKE ? OR replace(Market, ' ','') LIKE ? OR replace(Product,' ','') LIKE ?", "%#{search_text}%", "%#{search_text}%", "%#{search_text}%")

    render json: market_reports
  end

  def show
    @market_report = MarketReport.find(params[:idmarketreport])
    render json: @market_report
  end

  def create
    market_report = MarketReport.new(market_report_params)
    market_report[:IssuedBy] == params[:iduser]
    if market_report.save
      render json: market_report
    else
      render json: market_report.errors, status: :unprocessable_entity
    end
  end

  def update
    @market_report = MarketReport.find(params[:idmarketreport])
    if @market_report.update(market_report_params)
      render json: market_report
    else
      render json: market_report.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @market_report = MarketReport.find(params[:idmarketreport])
    @market_report[:State] = -1; 
    if @market_report.save
      render json: @market_report
    else
      render json: market_report.errors, status: :unprocessable_entity
    end
  end

  def top_5_markets_suggestions
    search_term = params[:search_term] == "all" ? '' :  params[:search_term]
    markets = {}
    MarketReport.where(State: nil).each do |market_report|
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
    MarketReport.where(State: nil).each do |market_report|
      market_report.Product.split(',').each do |product|
        p = product.strip.downcase
        products[p] = products[p].nil? ? 1 : products[p] + 1 if p.include?(search_term.strip.downcase)
      end
    end
    result = products.sort_by { |_key, value| value }.reverse[0..4].map { |product| product[0] }
    render json: result
  end

  def market_report_params
    params.require(:market_report).permit(
      :IdMarketReport,
      :Title,
      :Market,
      :Product,
      :ReportDate,
      :ReportDateShamsi,
      :IdFiles,
      :IssuedBy, 
      :State
    )
  end
end

