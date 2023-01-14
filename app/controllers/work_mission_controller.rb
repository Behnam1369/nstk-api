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
    @work_mission = WorkMission.includes(:work_missioners).find(params[:idmission])
    @work_mission['EstimatedStartTime'] = @work_mission['EstimatedStartTime']
    @work_mission['EstimatedEndTime'] = @work_mission['EstimatedEndTime']
    render json: { message: 'Success',
                   data: @work_mission.as_json(include: :work_missioners,
                                               methods: %w[
                                                 commission_permit shastan_permit mission_order ticket hotel payments other_files
                                               ]) }
  end

  def payments
    @work_mission_payments = WorkMissionPayment.where(IdWorkMission: params[:idmission], IdWorkMissioner: params[:idmissioner])
    render json: { message: 'Success',
                   vch: @work_mission_payments,
                   missioner: User.find(params[:idmissioner]) 
                  }
  end

  # def save_work_mission
  #   @work_mission = WorkMission.new(
  #     {
  #       Subject: params[:Subject],
  #       IdUser: params[:IdUser],
  #       IdWorkMissionObjective: params[:IdWorkMissionObjective],
  #       OtherWorkMissionObjective: params[:OtherWorkMissionObjective],
  #       EstimatedStartDate: params[:EstimatedStartDate],
  #       EstimatedStartTime: params[:EstimatedStartTime],
  #       EstimatedEndDate: params[:EstimatedEndDate],
  #       EstimatedEndTime: params[:EstimatedEndTime],
  #       Origin: params[:Origin],
  #       Destination: params[:Destination],
  #       Note: params[:Note],
  #       CommissionPermit: params['CommissionPermit'].map { |x| x['IdAttachment'] }.join(','),
  #       ShastanPermit: params['ShastanPermit'].map { |x| x['IdAttachment'] }.join(','),
  #       MissionOrder: params['MissionOrder'].map { |x| x['IdAttachment'] }.join(','),
  #       Ticket: params['Ticket'].map { |x| x['IdAttachment'] }.join(','),
  #       Hotel: params['Hotel'].map { |x| x['IdAttachment'] }.join(','),
  #       Payments: params['Payments'].map { |x| x['IdAttachment'] }.join(','),
  #       OtherFiles: params['OtherFiles'].map { |x| x['IdAttachment'] }.join(',')
  #     }
  #   )

  #   params['missioners'].split(',').each do |missioner|
  #     @missioner = WorkMissioner.new({ IdUser: missioner })
  #     @missioner.work_mission = @work_mission
  #     @missioner.save
  #   end

  #   @work_mission.save
  # end

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
    puts '---------------------'
    puts '---------------------'
    if work_mission_params[:IdWorkMission].nil?
      @work_mission = WorkMission.new(work_mission_params)
      if @work_mission.save
        puts '!!!!!!!!!!!!!!!!!!'
        render json: { message: 'Success', work_mission: @work_mission }
      else
        puts '??????????????????'
        render json: { message: 'Failed' }
      end
    end
  end

  def work_mission_params
    params.require(:work_mission).permit(
      :IdWorkMission,
      :Subject,
      :IdUser,
      :IdWorkMissionObjective,
      :OtherWorkMissionObjective,
      :IdMissionType,
      :MissionType,
      :EstimatedStartDate,
      :EstimatedStartTime,
      :EstimatedEndDate,
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
