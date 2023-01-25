class PurchaseRequestController < ApplicationController
  def new
    data = {
      curArr: Currency.all.select(:IdCur, :Abr, :Title),
      idDept: User.find(params[:iduser]).roles.first.IdDept,
      dept: Dl.find(User.find(params[:iduser]).roles.first.IdDept)['Title']
    }
    render json: { message: 'Success', data: }
  end

  def show
    data = {
      curArr: Currency.all.select(:IdCur, :Abr, :Title),
      vch: PurchaseRequest.find(params[:idpurchaserequest]),
      itms: PurchaseRequestItm.where(IdPurchaseRequest: params[:idpurchaserequest])
    }
    render json: { message: 'Success', data: }
  end

  # rubocop:disable Metrics/MethodLength
  def save
    if purchase_request_params[:IdPurchaseRequest].nil?
      @purchase_request = PurchaseRequest.new(purchase_request_params)

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
      purchase_request_itms_attributes:
      %i[Descr Qty Unit Note]
    )
  end

  def purchase_request_itm_params
    params[:purchase_request_itms_attributes]
  end
end
