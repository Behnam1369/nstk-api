class PurchaseRequestController < ApplicationController
  def new
    data = {
      curArr: Currency.all.select(:IdCur, :Abr, :Title),
      idDept: User.find(params[:iduser]).roles.first.IdDept,
      dept: Dl.find(User.find(params[:iduser]).roles.first.IdDept)['Title'],
      tradeSize: TradeSize.all
    }
    render json: { message: 'Success', data: }
  end

  def show
    data = {
      curArr: Currency.all.select(:IdCur, :Abr, :Title),
      vch: PurchaseRequest.find(params[:idpurchaserequest]),
      itms: PurchaseRequestItm.where(IdPurchaseRequest: params[:idpurchaserequest]),
      inquiries: PurchaseRequestInquiry.where(IdPurchaseRequest: params[:idpurchaserequest]),
      tradeSize: TradeSize.all
    }
    render json: { message: 'Success', data: }
  end

  # rubocop:disable Metrics/MethodLength
  def save
    if purchase_request_params[:IdPurchaseRequest].nil?
      @purchase_request = PurchaseRequest.new(purchase_request_params)
      puts @purchase_request

      abr = Dept.find(@purchase_request[:IdDept])[:Abr]
      yr = @purchase_request[:PurchaseRequestDateShamsi].split('/')[0]
      no = 1
      if PurchaseRequest.where('IdDept = ? AND PurchaseRequestDateShamsi LIKE ?', @purchase_request[:IdDept],
                               "#{yr}%").count.positive?
        no = PurchaseRequest.where('IdDept = ? AND PurchaseRequestDateShamsi LIKE ?', @purchase_request[:IdDept],
                                   "#{yr}%").last.No + 1
      end

      @purchase_request.No = no
      @purchase_request.PurchaseRequestNo = "PUR/#{yr}/#{abr}/#{no}"

      if @purchase_request.save
        render json: { message: 'Success', data: @purchase_request }
      else
        puts @purchase_request.errors.inspect
        render json: { message: 'Failed', error: @purchase_request.errors }
      end
    else
      @purchase_request = PurchaseRequest.find(purchase_request_params[:IdPurchaseRequest])
      @purchase_request.purchase_request_itms.destroy_all
      @purchase_request.purchase_request_inquiries.destroy_all
      if @purchase_request.update(purchase_request_params)
        render json: { message: 'Success', data: @purchase_request }
      else
        render json: { message: 'Failed', error: @purchase_request.errors }
      end
    end
  end
  # rubocop:enable Metrics/MethodLength

  def delete
    @purchase_request = PurchaseRequest.find(params[:idpurchaserequest])
    if @purchase_request.update(State: '-1')
      render json: { message: 'Success' }
    else
      render json: { message: 'Failed' }
    end
  end

  def cancel
    @purchase_request = PurchaseRequest.find(params[:idpurchaserequest])
    if @purchase_request.update(State: '1')
      render json: { message: 'Success' }
    else
      render json: { message: 'Failed' }
    end
  end

  def get_trade_size
    abr = params[:abr]
    amount = params[:amount]

    exchange_rate = 1
    if abr != "IRR"
      exchange_rate = ExchangeRate.where(Abr: abr, Title: 'فروش(اسکناس)').order(:Date).last.Rate
    end
    
    TradeSize.all.each do |ts|
      if ts.Amount.nil? || amount.to_f * exchange_rate <= ts.Amount
        return render json: { result: ts.IdTradeSize }
      end
    end
  end

  private

  def purchase_request_params
    params.require(:purchase_request).permit(
      :IdPurchaseRequest,
      :No,
      :PurchaseRequestNo,
      :PurchaseRequestDate,
      :PurchaseRequestDateShamsi,
      :IdHeadLetter,
      :HeadLetter,
      :IdDept,
      :Dept,
      :Amount,
      :IdCur,
      :Abr,
      :Note,
      :Issuer,
      :State,
      :IdTradeSize, 
      :TradeSize,
      :SkipFormalities,
      :SkipFormalitiesNote,
      :CommissionDate,
      :CommissionDateShamsi,
      :StartTime,
      :EndTime,
      :Venue,
      :Subject1,
      :Subject2,
      :IsPurchaseRequestAttached,
      :IsInquiriesAttached,
      :IsOffersTableAttached,
      :IsSkippingFormalitiesReportAttached,
      :OtherAttachments,
      :Desicions,
      :Winner,
      :HowToWork,
      purchase_request_itms_attributes: %i[Descr Qty Unit Note],
      purchase_request_inquiries_attributes: %i[Title Amount IdCur Cur ExchangeRate ExchangeRateRevert IRRAmount Note]
    )
  end

  def purchase_request_itm_params
    params[:purchase_request_itms_attributes]
  end

  def purchase_request_inquiries_params
    params[:purchase_request_inquiries_attributes]
  end
end
