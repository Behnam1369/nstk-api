class UserController < ApplicationController
  include ShamsiDateHelper

  def show 
    render json: User.where(IdWinkart: params[:idwinkart])[0]
  end

  def birthdays
    idwinkart = params[:idwinkart]
    result = ActiveRecord::Base.connection.select_all("select * from BirthDay where idwinkart = #{idwinkart}")
    render json: result
  end

  def save_birthdays
    received_ids = params[:birthdays].map { |bd| bd[:IdBirthDay] }
    existing_ids = Birthday.where(IdWinkart: params[:idwinkart]).pluck(:IdBirthDay)
    removed_ids = existing_ids - received_ids
  
    # Delete the removed records
    if removed_ids.present?
      Birthday.where(IdWinkart: params[:idwinkart], IdBirthDay: removed_ids).delete_all
    end
  
    params[:birthdays].each do |bd|
      birthday = Birthday.find_by(IdBirthDay: bd[:IdBirthDay])
  
      if birthday.nil?
        bd[:IdBirthDay] = Birthday.maximum(:IdBirthDay).to_i + 1
        bd[:IdWinkart] = params[:idwinkart]
        bd[:ShamsiDate] = shamsi_date(bd[:Date])
        Birthday.create(birthday_params(bd))
      else
        bd[:ShamsiDate] = shamsi_date(bd[:Date])
        birthday.update(birthday_params(bd))
      end
    end
  
    render json: 'success'
  end
  
  private
  
  def birthday_params(params)
    params.permit(:IdBirthDay, :IdWinkart, :Type, :Date, :ShamsiDate)
  end
  
end