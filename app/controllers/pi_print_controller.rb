class PiPrintController < ApplicationController
  def show
    sql = "loadPiPrint @idpiprint = #{params[:idpiprint]}"
    result = ActiveRecord::Base.connection.select_all(sql)
    render json: { message: 'Success', result: }
  end

  def create
    @pi_print = PiPrint.new(pi_print_params)
    if @pi_print.save
      render json: { message: 'Success', data: @pi_print }
    else
      render json: { message: 'Failed', error: @pi_print.errors }
    end
  end

  def update
    @pi_print = PiPrint.find(params[:idpiprint])
    @pi_print.pi_print_itms.destroy_all
    if @pi_print.update(pi_print_params)
      render json: { message: 'Success', data: @pi_print }
    else
      render json: { message: 'Failed', error: @pi_print.errors }
    end
  end

  def pi_print_params
    params.require(:pi_print).permit(
      :IdPi,
      :IdPiPattern,
      pi_print_itms_attributes: %i[Title Formula Text Type]
    )
  end

  # def pi_print_itm_params
  #   params[:purchase_request_itms_attributes]
  # end
end
