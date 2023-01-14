class WorkMissionerController < ApplicationController
  
  def save_report
    @work_missioner = WorkMissioner.find(missioner_params[:IdWorkMissioner])
    @work_missioner.work_mission_reports.destroy_all
    @work_missioner.work_mission_achievements.destroy_all
    if @work_missioner.update(missioner_params)
      render json: { message: 'Success' }
    else
      render json: { message: 'Failed' }
    end
  end
  
  def missioner_params
    params.require(:work_missioner).permit(
      :IdWorkMissioner,
      :StartDate,
      :StartDateShamsi,
      :StartTime,
      :EndDate,
      :EndDateShamsi,
      :EndTime,
      :IdRoleType,
      :RoleType,
      :Note,
      :Files,
      work_mission_reports_attributes: [
        :IdWorkMissionReport, 
        :IdWorkMission, 
        :IdWorkMissioner, 
        :Subject, 
        :Date, 
        :DateShamsi, 
        :Venue, 
        :Done, 
        :ToDo, 
        :Follower,
        :Note
      ], 
      work_mission_achievements_attributes: [
        :IdWorkMissionAchievement,
        :IdWorkMission,
        :IdWorkMissioner,
        :Descr
      ]
    )
  end
end
