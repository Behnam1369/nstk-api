class WorkMission < ApplicationRecord
  has_many :work_mission_objectives, foreign_key: 'IdWorkMission'
  belongs_to :user, foreign_key: 'IdUser'
  has_many :work_missioners, foreign_key: 'IdWorkMission', dependent: :destroy
  accepts_nested_attributes_for :work_missioners

  self.table_name = 'WorkMission'
  self.primary_key = 'IdWorkMission'

  def commission_permit
    attachments = []
    self.CommissionPermit.split(',').each do |idattachment|
      attachments << Attachment.find(idattachment)
    end

    attachments
  end

  def shastan_permit
    attachments = []
    self.ShastanPermit.split(',').each do |idattachment|
      attachments << Attachment.find(idattachment)
    end

    attachments
  end

  def mission_order
    attachments = []
    self.MissionOrder.split(',').each do |idattachment|
      attachments << Attachment.find(idattachment)
    end

    attachments
  end

  def ticket
    attachments = []
    self.Ticket.split(',').each do |idattachment|
      attachments << Attachment.find(idattachment)
    end

    attachments
  end

  def hotel
    attachments = []
    self.Hotel.split(',').each do |idattachment|
      attachments << Attachment.find(idattachment)
    end

    attachments
  end

  def payments
    attachments = []
    self.Payments.split(',').each do |idattachment|
      attachments << Attachment.find(idattachment)
    end

    attachments
  end

  def other_files
    attachments = []
    self.OtherFiles.split(',').each do |idattachment|
      attachments << Attachment.find(idattachment)
    end

    attachments
  end
end
