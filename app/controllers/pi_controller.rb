class PiController < ApplicationController
  def soa
    sql = "CustomerSOA @idpi = #{params[:idpi]}"
    result = ActiveRecord::Base.connection.select_all(sql)
    render json: { message: 'Success', result: }
  end 
end