class WorkMissionController < ApplicationController
  def new
    data = {
      users: User.all.select(:IdUser, :UserName, :Fname, :Lname),
      currencies: Currency.all,
      work_mission_objectives: WorkMissionObjective.all
    }
    render json: { message: 'Success', data: }
  end

  def show
    data = {
      work_mission: WorkMission.find(params[:idmission]),
      work_missioners: WorkMissioner.where(IdWorkMission: params[:idmission]),
      users: User.all.select(:IdUser, :UserName, :Fname, :Lname),
      currencies: Currency.all,
      work_mission_objectives: WorkMissionObjective.all
    }
    render json: { message: 'Success', data: }
  end

  def payments
    @work_mission_payments = WorkMissionPayment.where(IdWorkMission: params[:idmission], IdWorkMissioner: params[:idmissioner])
    render json: { message: 'Success',
                   vch: @work_mission_payments,
                   missioner: User.find(params[:idmissioner]) 
                  }
  end

  
  def save_payment
    wmp = WorkMissionPayment.create(work_mission_payment_params)
    if wmp["IdPaymentType"] == 3
      wmp["Amount"] = -wmp["Amount"]
    end
    wmp.save
    if wmp.save
      render json: { message: 'Success' }
    else
      render json: { message: 'Failed' }
    end
  end

  def delete_payment
    wmp = WorkMissionPayment.find(params[:idpayment])
    if wmp.destroy
      render json: { message: 'Success' }
    else
      render json: { message: 'Failed' }
    end
  end

  def work_mission_payment_params
    params.permit(
      :IdWorkMissionPayment,
      :IdWorkMission,
      :IdWorkMissioner,
      :IdPaymentType,
      :PaymentType,
      :Descr,
      :PaymentDate,
      :PaymentDateShamsi,
      :Amount,
      :IdCur,
      :Abr
    )
  end

  def reports
    render json: {  
      message: 'Success',
      reports: WorkMissionReport.where(IdWorkMission: params[:idmission], IdWorkMissioner: params[:idmissioner]),
      missioner: WorkMissioner.where(IdWorkMission: params[:idmission], IdWorkMissioner: params[:idmissioner])[0],
      achievements: WorkMissionAchievement.where(IdWorkMission: params[:idmission], IdWorkMissioner: params[:idmissioner])
    }
  end

  def save_work_mission
    if work_mission_params[:IdWorkMission].nil?
      @work_mission = WorkMission.new(work_mission_params)
      @work_mission[:Issuer] = User.find(work_mission_params[:IdUser])[:Fname] + " " + User.find(work_mission_params[:IdUser])[:Lname] 
      @work_mission[:IssueDate] = Date.today 
      if @work_mission.save
        work_missioners = params[:work_missioners]
        work_missioners.each do |missioner|
          m = WorkMissioner.new(); 
          m.work_mission = @work_mission
          m[:IdUser] = missioner[:IdUser]
          m.save
        end
        render json: { message: 'Success', work_mission: @work_mission }
      else
        render json: { message: 'Failed' }
      end
    else 
      @work_mission = WorkMission.find(work_mission_params[:IdWorkMission])
      if @work_mission.update(work_mission_params)
        work_missioners = params[:work_missioners].map { |work_missioner| work_missioner[:IdUser]  }
        existing_work_missioners = @work_mission.work_missioners.map { |work_missioner| work_missioner[:IdUser]  }
        
        WorkMissioner.where(
          IdWorkMission: @work_mission[:IdWorkMission], 
          IdUser: (existing_work_missioners - work_missioners)
        ).destroy_all

        (work_missioners - existing_work_missioners).each do |missioner|
          m = WorkMissioner.new(); 
          m.work_mission = @work_mission
          m[:IdUser] = missioner
          m.save
        end
        render json: { message: 'Success', work_mission: @work_mission }
      else
        render json: { message: 'Failed' }
      end
    end
  end

  def work_mission_params
    params.require(:work_mission).permit(
      :IdWorkMission,
      :Subject,
      :IdUser,
      :WorkMissioners,
      :IdWorkMissionObjective,
      :WorkMissionObjective,
      :OtherWorkMissionObjective,
      :IdMissionType,
      :MissionType,
      :EstimatedStartDate,
      :EstimatedStartDateShamsi,
      :EstimatedStartTime,
      :EstimatedEndDate,
      :EstimatedEndDateShamsi,
      :EstimatedEndTime,
      :Origin,
      :Destination,
      :IdRequirement,
      :Requirements,
      :Vehicle,
      :ResidencePlace,
      :IdPettyCashHolder,
      :PettyCashAmount,
      :IdCur, 
      :Abr,
      :OtherRequirements,
      :Note,
      :CommissionPermit,
      :ShastanPermit,
      :LeavePermit,
      :MissionOrder,
      :Visa,
      :Ticket,
      :Hotel,
      :Payments,
      :OtherFiles
    )
  end
end
