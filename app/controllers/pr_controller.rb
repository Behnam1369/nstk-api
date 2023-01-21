class PrController < ApplicationController
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
      vch: Pr.find(params[:idpr])
    }
    render json: { message: 'Success', data: }
  end

  # rubocop:disable Metrics/MethodLength
  def save
    if pr_params[:IdPr].nil?
      @pr = Pr.new(pr_params)
      abr = Dept.find(@pr[:IdDept])[:Abr]
      yr = @pr[:PrDateShamsi].split('/')[0]
      no = 1
      if Pr.where('IdDept = ? AND PrDateShamsi LIKE ?', @pr[:IdDept], "#{yr}%").count.positive?
        no = Pr.where('IdDept = ? AND PrDateShamsi LIKE ?', @pr[:IdDept], "#{yr}%").last.No + 1
      end

      @pr.No = no
      @pr.PrNo = "PR/#{yr}/#{abr}/#{no}"
      if @pr.save
        puts 'saved'
        render json: { message: 'Success', data: @pr }
      else
        render json: { message: 'Error', data: @pr.errors }
      end
    else
      @pr = Pr.find(pr_params[:IdPr])
      if @pr.update(pr_params)
        puts 'updated'
        render json: { message: 'Success', data: @pr }
      else
        render json: { message: 'Error', data: @pr.errors }
      end
    end
  end
  # rubocop:enable Metrics/MethodLength

  def cancel
    @pr = Pr.find(pr_params[:IdPr])
    if @pr.update(State: 1)
      render json: { message: 'Success', data: @pr }
    else
      render json: { message: 'Error', data: @pr.errors }
    end
  end

  def delete
    @pr = Pr.find(pr_params[:IdPr])
    if @pr.update(State: -1)
      render json: { message: 'Success', data: @pr }
    else
      render json: { message: 'Error', data: @pr.errors }
    end
  end

  private

  # rubocop:disable Metrics/MethodLength
  def pr_params
    params.require(:pr).permit(
      :IdPr,
      :No,
      :PrNo,
      :PrDate,
      :PrDateShamsi,
      :IdHeadLetter,
      :HeadLetter,
      :IdDept,
      :Dept,
      :Amount,
      :IdCur,
      :Abr,
      :Rate,
      :RevertRate,
      :AmountIRR,
      :Payee,
      :IdPaymentType,
      :PaymentType,
      :DestinationAccount,
      :IdPrType,
      :PrType,
      :IdPettyCashPaymentType,
      :PettyCashPaymentType,
      :PettyCashNo,
      :IdPayrollPaymentType,
      :PayrollPaymentType,
      :PayrollMonth,
      :IdPurchaseGoodPaymentType,
      :PurchaseGoodPaymentType,
      :GoodTitle,
      :IdPurchaseServicePaymentType,
      :PurchaseServicePaymentType,
      :ServiceTitle,
      :IdContractPaymentType,
      :ContractPaymentType,
      :ContractNo,
      :ContractDate,
      :IdCreditorType,
      :CreditorType,
      :CreditorTitle,
      :Other,
      :Guarantee,
      :Note,
      :IdPrOut,
      :Paid,
      :Remained,
      :State
    )
  end
  # rubocop:enable Metrics/MethodLength
end
