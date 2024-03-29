# rubocop:disable Metrics/ClassLength
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
    @work_mission_payments = WorkMissionPayment.where(IdWorkMission: params[:idmission],
                                                      IdWorkMissioner: params[:idmissioner])
    render json: { message: 'Success',
                   vch: @work_mission_payments,
                   missioner: User.find(params[:idmissioner]) }
  end

  def save_payment
    wmp = WorkMissionPayment.create(work_mission_payment_params)
    wmp['Amount'] = -wmp['Amount'] if wmp['IdPaymentType'] == 3
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
      achievements: WorkMissionAchievement.where(IdWorkMission: params[:idmission],
                                                 IdWorkMissioner: params[:idmissioner])
    }
  end

  # rubocop:disable Metrics/MethodLength, Metrics/CyclomaticComplexity, Metrics/PerceivedComplexity, Metrics/AbcSize
  def save_work_mission
    if work_mission_params[:IdWorkMission].nil?
      @work_mission = WorkMission.new(work_mission_params)
      @work_mission[:Issuer] =
        "#{User.find(work_mission_params[:IdUser])[:Fname]} #{User.find(work_mission_params[:IdUser])[:Lname]}"
      @work_mission[:IssueDate] = Date.today
      if @work_mission.save
        work_missioners = params[:work_missioners]
        work_missioners.each do |missioner|
          m = WorkMissioner.new
          m.work_mission = @work_mission
          if missioner[:IdUser]
            m[:IdUser] = missioner[:IdUser]
          else
            m[:FullName] = missioner[:FullName]
          end
          m.save
        end
        render json: { message: 'Success', work_mission: @work_mission }
      else
        render json: { message: 'Failed' }
      end
    else
      @work_mission = WorkMission.find(work_mission_params[:IdWorkMission])
      if @work_mission.update(work_mission_params)
        work_missioners = params[:work_missioners].map { |work_missioner| 
          {
            iduser: work_missioner[:IdUser] , 
            fullname: work_missioner[:FullName]
          }
        }

        existing_work_missioners = @work_mission.work_missioners.map { |work_missioner| 
          {
            IdWorkMissioner: work_missioner[:IdWorkMissioner],
            iduser: work_missioner[:IdUser] , 
            fullname: work_missioner[:FullName]
          }
        }

        # remove deleted missioners
        existing_work_missioners.each do |missioner|
          if work_missioners.select { |wm| ( !wm[:iduser].nil? && wm[:iduser] == missioner[:iduser]) || wm[:fullname] == missioner[:fullname]  }.empty?
            WorkMissioner.find(missioner[:IdWorkMissioner]).destroy
          end
        end


        work_missioners.each do |missioner|
          if existing_work_missioners.select { |wm| ( !wm[:iduser].nil? && wm[:iduser] == missioner[:iduser]) || wm[:fullname] == missioner[:fullname]  }.empty?
            m = WorkMissioner.new
            m.work_mission = @work_mission
            if missioner[:iduser]
              m[:IdUser] = missioner[:iduser]
            else
              m[:FullName] = missioner[:fullname]
            end
            if m.save
              puts "saved #{m.IdWorkMissioner}"
            else
              puts "failed #{m.errors.full_messages}"
            end
          end
        end
        

        # WorkMissioner.where(
        #   IdWorkMission: @work_mission[:IdWorkMission],
        #   IdUser: (existing_work_missioners - work_missioners)
        # ).destroy_all

        # (work_missioners - existing_work_missioners).each do |missioner|
        #   m = WorkMissioner.new
        #   m.work_mission = @work_mission
        #   m[:IdUser] = missioner
        #   m.save
        # end
        render json: { message: 'Success', work_mission: @work_mission }
      else
        render json: { message: 'Failed' }
      end
    end
  end
  # rubocop:enable Metrics/MethodLength, Metrics/CyclomaticComplexity, Metrics/PerceivedComplexity, Metrics/AbcSize

  # rubocop:disable Metrics/MethodLength
  def show_mission_fee
    q = "
    select
      a.IdUser,
      isnull(b.Fname+ ' '+ b.Lname, a.FullName) as FullName,
      b.Lname ,
      isnull(a.StartDate, c.EstimatedStartDate) as StartDate,
      isnull(a.StartDateShamsi, c.EstimatedstartdateShamsi) as StartDateShamsi,
      isnull(a.StartTime, c.EstimatedstartTime) as StartTime,
      isnull(a.EndDate, c.EstimatedEndDate) as EndDate,
      isnull(a.EndDateShamsi, c.EstimatedEnddateShamsi) as EndDateShamsi,
      isnull(a.EndTime, c.EstimatedEndTime) as EndTime,
      isnull(a.MissionDays,
		datediff(day, a.StartDate, a.EndDate) + 1
	  ) as MissionDays,
      isnull(a.MissionFeeRate, 
		case when dbo.UserRole(a.IdUser) = 2 then 130  -- CEO
		     --when a.iduser in (select iduser from UserGroupMembers where IdGroup = 89) then 130 -- Managers
			 else 110
		end
	  ) as MissionFeeRate,
	  isnull(a.MissionFoodRate, 
		case when dbo.UserRole(a.IdUser) = 2 then 65  -- CEO
		     --when a.iduser in (select iduser from UserGroupMembers where IdGroup = 89) then 60 -- Managers
			 else 65
		end
	  ) as MissionFoodRate,
    (
      isnull(a.MissionDays,
        datediff(day, a.StartDate, a.EndDate) + 1
      ) * 
      (
        isnull(a.MissionFeeRate, 
          case when dbo.UserRole(a.IdUser) = 2 then 130  -- CEO
            --when a.iduser in (select iduser from UserGroupMembers where IdGroup = 89) then 130 -- Managers
            else 110
          end
        ) + 
        isnull(a.MissionFoodRate, 
          case when dbo.UserRole(a.IdUser) = 2 then 65  -- CEO
              when a.iduser in (select iduser from UserGroupMembers where IdGroup = 89) then 60 -- Managers
              else 65
          end
        )
      )
	  ) as ActualMissionFee
from WorkMissioner as a
left join users as b on a.IdUser = b.iduser
inner join WorkMission as c on a.IdWorkMission = c.IdWorkMission
where a.IdWorkMission = #{params[:idmission]}
    "
    wm = ActiveRecord::Base.connection.select_all(q)

    render json: { message: 'Success', wm: }
  end
  # rubocop:enable Metrics/MethodLength

  def save_mission_fee
    params[:_json].each do |wm|
      missioner = WorkMissioner.where(IdWorkMission: wm[:IdWorkMission], IdUser: wm['IdUser'])[0]
      missioner['ActualMissionFee'] = wm['ActualMissionFee']
      missioner.MissionFeeRate = wm['MissionFeeRate']
      missioner.MissionFoodRate = wm['MissionFoodRate']
      missioner.MissionDays = wm['MissionDays']
      missioner.save
    end
    render json: { message: 'Success' }
  end

  # rubocop:disable Metrics/MethodLength
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
  # rubocop:enable Metrics/MethodLength
end
# rubocop:enable Metrics/ClassLength
