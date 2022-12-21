class WorkMissionController < ApplicationController
  def new
    data = {
      users: User.all.select(:IdUser, :UserName, :Fname, :Lname),
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

  def save_work_mission
    @work_mission = WorkMission.new(
      {
        Subject: params[:Subject],
        IdUser: params[:IdUser],
        IdWorkMissionObjective: params[:IdWorkMissionObjective],
        OtherWorkMissionObjective: params[:OtherWorkMissionObjective],
        EstimatedStartDate: params[:EstimatedStartDate],
        EstimatedStartTime: params[:EstimatedStartTime],
        EstimatedEndDate: params[:EstimatedEndDate],
        EstimatedEndTime: params[:EstimatedEndTime],
        Origin: params[:Origin],
        Destination: params[:Destination],
        Note: params[:Note],
        CommissionPermit: params['CommissionPermit'].map { |x| x['IdAttachment'] }.join(','),
        ShastanPermit: params['ShastanPermit'].map { |x| x['IdAttachment'] }.join(','),
        MissionOrder: params['MissionOrder'].map { |x| x['IdAttachment'] }.join(','),
        Ticket: params['Ticket'].map { |x| x['IdAttachment'] }.join(','),
        Hotel: params['Hotel'].map { |x| x['IdAttachment'] }.join(','),
        Payments: params['Payments'].map { |x| x['IdAttachment'] }.join(','),
        OtherFiles: params['OtherFiles'].map { |x| x['IdAttachment'] }.join(',')
      }
    )

    params['missioners'].split(',').each do |missioner|
      @missioner = WorkMissioner.new({ IdUser: missioner })
      @missioner.work_mission = @work_mission
      @missioner.save
    end

    @work_mission.save
  end
end
