class PiPatternController < ApplicationController

  def show
    sql = "loadPiPattern @idpi = #{params[:idpi]}, @idpattern = #{params[:idpipattern]}"
    result = ActiveRecord::Base.connection.select_all(sql)
    render json: { message: 'Success', result: result }
  end

  def create
    @pi_pattern = PiPattern.new(pi_pattern_params)
    if @pi_pattern.save
      render json: { message: 'Success', data: @pi_pattern }
    else
      render json: { message: 'Failed', error: @pi_pattern.errors }
    end
  end

  def update
    @pi_pattern = PiPattern.find(params[:idpipattern])
    @pi_pattern.pi_pattern_itms.destroy_all
    if @pi_pattern.update(pi_pattern_params)
      render json: { message: 'Success', data: @pi_pattern }   
    else
      render json: { message: 'Failed', error: @pi_pattern.errors }
    end
  end
    

  def pi_pattern_params
    params.require(:pi_pattern).permit(
      :VchType,
      :Title,
      pi_pattern_itms_attributes:
      %i[Title Formula Text Type]
    )
  end

  def pi_pattern_itm_params
    params[:purchase_request_itms_attributes]
  end
end
