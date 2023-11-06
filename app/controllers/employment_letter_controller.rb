class EmploymentLetterController < ApplicationController
  include ShamsiDateHelper

  def new
    q = "
      declare @iduser int = ?
      select cast((select
        fname + ' ' + lname as FullName ,
        dbo.GrossSalary(idwinkart) as GrossSalary,
        dbo.EmploymentMonth(idwinkart) as EmploymentMonth,
        dbo.UserDept(@iduser) as IdDept,
        (select title from dl where iddl = (dbo.UserDept(@iduser))) as Dept,
        dbo.UserRole(@iduser) as IdRole,
        (select title from role where idrole = (dbo.UserRole(@iduser))) as Role,  
        IdWinkart as PerNo
        from users where iduser = @iduser for json path, include_null_values) as nvarchar(max)) as data
    "

    data = ActiveRecord::Base.connection.select_all(
      ApplicationRecord.sanitize_sql([q, params[:iduser]])
    )

    render json: data
  end

  def edit
    q = "
      declare @idemploymentletter int = ?
      declare @iduser int = (select iduser from employmentletter where idemploymentletter = @idemploymentletter)
      select cast((select
        (select * from employmentletter where idemploymentletter = @idemploymentletter for json auto,include_null_values, without_array_wrapper) as EmploymentLetter,
        (select string_agg(idrole, ',') from role where iduser = #{params[:iduser]}) as Roles,
        (select string_agg(idgroup, ',') from UserGroupMembers where iduser = #{params[:iduser]}) as UserGroups
        from users where iduser = @iduser for json path, include_null_values) as nvarchar(max)) as data
    "

    data = ActiveRecord::Base.connection.select_all(
      ApplicationRecord.sanitize_sql([q, params[:idemploaymentletter]])
    )

    render json: data
  end

  def create
    @employment_letter = EmploymentLetter.new(employment_letter_params)
    puts @employment_letter.inspect
    if @employment_letter.save
      render json: { message: 'Success', employment_letter: @employment_letter }
    else
      render json: { message: 'Error', data: @employment_letter.errors }
    end
  end

  def update
    @employment_letter = EmploymentLetter.find(params[:idemploaymentletter])
    if @employment_letter.update(employment_letter_params)
      render json: { message: 'Success', employment_letter: @employment_letter }
    else
      render json: { message: 'Error', data: @employment_letter.errors }
    end
  end
  
  def send_to_dept_manager
    @employment_letter = EmploymentLetter.find(params[:idemploaymentletter])
    manager = User.find(params[:iduser]).dept.manager
    @employment_letter.IdManager = manager.IdUser
    @employment_letter.Manager = manager.full_name
    @employment_letter.IdStep = 2
    @employment_letter.Step = 'در حال بررسی توسط مدیر واحد'
    @employment_letter.RequestDate = DateTime.now
    @employment_letter.RequestDateShamsi = shamsi_date(DateTime.now)

    if @employment_letter.save
      render json: { message: 'Success', employment_letter: @employment_letter }
    else
      render json: { message: 'Error', data: @employment_letter.errors }
    end
  end

  def send_to_hr
    @employment_letter = EmploymentLetter.find(params[:idemploaymentletter])
    @employment_letter.ManagerNote = params[:Note]
    @employment_letter.IdStep = 3
    @employment_letter.Step = 'در حال بررسی توسط منابع انسانی'
    @employment_letter.ManagerConfirmDate = DateTime.now
    @employment_letter.ManagerConfirmDateShamsi = shamsi_date(DateTime.now)
    hr_manager = Role.find(55).user
    @employment_letter.IdHr = hr_manager.IdUser
    @employment_letter.Hr = hr_manager.full_name

    if @employment_letter.save
      render json: { message: 'Success', employment_letter: @employment_letter }
    else
      render json: { message: 'Error', data: @employment_letter.errors }
    end
  end

  def send_to_ceo
    @employment_letter = EmploymentLetter.find(params[:idemploaymentletter])
    @employment_letter.HrNote = params[:Note]
    @employment_letter.IdStep = 4
    @employment_letter.Step = 'در انتظار تایید مدیرعامل'
    @employment_letter.HrConfirmDate = DateTime.now
    @employment_letter.HrConfirmDateShamsi = shamsi_date(DateTime.now)
    ceo = Role.find(2).user
    @employment_letter.IdCeo = ceo.IdUser
    @employment_letter.Ceo = ceo.full_name

    puts ceo.inspect
    puts @employment_letter.inspect

    if @employment_letter.save
      render json: { message: 'Success', employment_letter: @employment_letter }
    else
      render json: { message: 'Error', data: @employment_letter.errors }
    end
  end

  def send_to_finance
    @employment_letter = EmploymentLetter.find(params[:idemploaymentletter])
    @employment_letter.CeoNote = params[:Note]
    @employment_letter.IdStep = 5
    @employment_letter.Step = 'در انتظار پرداخت'
    @employment_letter.CeoConfirmDate = DateTime.now
    @employment_letter.CeoConfirmDateShamsi = shamsi_date(DateTime.now)
    finance_users = UserGroup.find(109).users.map(&:IdUser).join(',')
    @employment_letter.IdFin = finance_users

    if @employment_letter.save
      render json: { message: 'Success', employment_letter: @employment_letter }
    else
      render json: { message: 'Error', data: @employment_letter.errors }
    end
  end

  def confirm_payment
    puts params.inspect
    @employment_letter = EmploymentLetter.find(params[:idemploaymentletter])
    @employment_letter.FinNote = params[:Note]
    @employment_letter.IdStep = 6
    @employment_letter.Step = 'پرداخت شده'
    @employment_letter.State = 'Paid'
    @employment_letter.Fin = User.find(params[:iduser]).full_name
    @employment_letter.InstallmentFirstMonth = params[:InstallmentFirstMonth]
    @employment_letter.InstallmentLastMonth = params[:InstallmentLastMonth]

    if @employment_letter.save
      render json: { message: 'Success', employment_letter: @employment_letter }
    else
      render json: { message: 'Error', data: @employment_letter.errors }
    end
  end

  def reject_by_dept_manager
    @employment_letter = EmploymentLetter.find(params[:idemploaymentletter])
    @employment_letter.ManagerNote = params[:Note]
    @employment_letter.ManagerConfirmDate = DateTime.now
    @employment_letter.ManagerConfirmDateShamsi = shamsi_date(DateTime.now)
    dept_manager = User.find(params[:iduser])
    @employment_letter.Step = -1
    @employment_letter.State = "عدم تایید توسط #{dept_manager.full_name}"
    if @employment_letter.save
      render json: { message: 'Success', employment_letter: @employment_letter }
    else
      render json: { message: 'Error', data: @employment_letter.errors }
    end
  end

  def reject_by_hr
    @employment_letter = EmploymentLetter.find(params[:idemploaymentletter])
    @employment_letter.HrNote = params[:Note]
    @employment_letter.HrConfirmDate = DateTime.now
    @employment_letter.HrConfirmDateShamsi = shamsi_date(DateTime.now)
    hr = User.find(params[:iduser])
    @employment_letter.Step = -1
    @employment_letter.State = "عدم تایید توسط #{hr.full_name}"
    if @employment_letter.save
      render json: { message: 'Success', employment_letter: @employment_letter }
    else
      render json: { message: 'Error', data: @employment_letter.errors }
    end
  end

  def reject_by_ceo
    @employment_letter = EmploymentLetter.find(params[:idemploaymentletter])
    @employment_letter.CeoNote = params[:Note]
    @employment_letter.CeoConfirmDate = DateTime.now
    @employment_letter.CeoConfirmDateShamsi = shamsi_date(DateTime.now)
    @employment_letter.Step = -1
    @employment_letter.State = "عدم تایید توسط #{@employment_letter.Ceo}"
    if @employment_letter.save
      render json: { message: 'Success', employment_letter: @employment_letter }
    else
      render json: { message: 'Error', data: @employment_letter.errors }
    end
  end

  def employment_letter_params
    params.permit(
      :IdEmploymentLetter,
      :IdUser,
      :FullName,
      :PerNo,
      :IdRole,
      :Role,
      :IdDept,
      :Dept,
      :GrossSalary,
      :EmploymentMonth,
      :Recipient,
      :IdStep,
      :Step,
      :State,
      :RequestDate,
      :RequestDateShamsi,
      :IsEmploymentLetter,
      :IsDeductionLetter,
      :IsGuarantee,
      :LoanTaker,
      :LoanTakerFatherName,
      :LoanTakerNationalId,
      :IncludePayrolSlips,
      :IsForCheque,
      :PayrolSlipsMonth,
      :IdFiles,
      :Note,
      :IdManager,
      :Manager,
      :ManagerNote,
      :ManagerConfirmDate,
      :ManagerConfirmDateShamsi,
      :IdHr,
      :Hr,
      :HrNote,
      :HrConfirmDate,
      :HrConfirmDateShamsi,
      :IdCeo,
      :Ceo,
      :CeoNote,
      :CeoConfirmDate,
      :CeoConfirmDateShamsi
    )
  end
end
