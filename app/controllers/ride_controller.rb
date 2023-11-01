class RideController < ApplicationController
  def new
    iduser = params[:iduser]
    user = User.find(iduser)
    role = user.roles.first
    dept = role.dept

    render json: {
      IdUser: user.IdUser, 
      FullName: user.full_name,
      FinalUser: user.full_name,
      IdRole: role.IdRole, 
      Role: role.Title, 
      IdDept: dept.IdDl, 
      Dept: dept.dl.Title 
    }
  end

  def show
    ride = Ride.find(params[:idride])
    iduser = params[:iduser]
    user = User.find(iduser)
    render json: { ride: ride, FullName: user.full_name }
  end

  def create 
    @ride = Ride.new(ride_params)
    puts @ride
    if @ride.save
      render json: @ride
    else
      puts @ride.errors.inspect
      render json: @ride.errors, status: :unprocessable_entity
    end
  end

  def update
    @ride = Ride.find(params[:idride])
    if @ride.update(ride_params)
      render json: @ride
    else
      render json: @ride.errors, status: :unprocessable_entity
    end
  end

  def admin_confirm
    @ride = Ride.find(params[:idride])
    user = User.find(params[:iduser])
  
    @ride.assign_attributes(ride_params)
    @ride.ApprovedBy = user.full_name

    
    if @ride.save
      render json: @ride
    else
      render json: @ride.errors, status: :unprocessable_entity
    end
  end

  def user_confirm   
    @ride = Ride.find(params[:idride])
    if @ride.update(ride_params)
      render json: @ride
    else
      render json: @ride.errors, status: :unprocessable_entity
    end
  end

  def ride_params
    params.require(:ride).permit(
      # :IdRide,
      :IdUser,
      :FullName,
      :IdRole,
      :Role,
      :IdDept,
      :Dept,
      :RequestForOthers,
      :FinalUser,
      :IdDriver,
      :Driver,
      :IdRideType,
      :RideType,
      :Destination,
      :Date,
      :ShamsiDate,
      :StartTime,
      :EndTime,
      :Note,
      :IdState,
      :State,
      :IdApprovedBy,
      :ApprovedBy,
    )
  end
 
end