class LoanController < ApplicationController
include ShamsiDateHelper

  def new
    q = "
      declare @iduser int = ?
      select cast((select 
        (select * from loanType for json auto) as LoanTypes , 
        dbo.GrossSalary(idwinkart) as GrossSalary, 
        dbo.EmploymentMonth(idwinkart) as EmploymentMonth,
        dbo.HierarchyLevel(iduser) as HierarchyLevel,
        dbo.ActiveMonthlyInstallments(idwinkart) as ActiveMonthlyInstallments,
        fname + ' ' + lname as FullName , 
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
      declare @idloan int = ? 
      declare @iduser int = (select iduser from loan where idloan = @idloan)
      select cast((select 
        (select * from loan where idloan = @idloan for json auto,include_null_values, without_array_wrapper) as Loan, 
        (select * from loanType for json auto) as LoanTypes , 
        dbo.GrossSalary(idwinkart) as GrossSalary, 
        dbo.EmploymentMonth(idwinkart) as EmploymentMonth,
        dbo.HierarchyLevel(iduser) as HierarchyLevel,
        dbo.ActiveMonthlyInstallments(idwinkart) as ActiveMonthlyInstallments,
        fname + ' ' + lname as FullName , 
        IdWinkart as PerNo,
        (select string_agg(idrole, ',') from role where iduser = #{params[:iduser]}) as Roles,
        (select string_agg(idgroup, ',') from UserGroupMembers where iduser = #{params[:iduser]}) as UserGroups
        from users where iduser = @iduser for json path, include_null_values) as nvarchar(max)) as data
    "

    data = ActiveRecord::Base.connection.select_all(
      ApplicationRecord.sanitize_sql([q, params[:idloan]])
    )

    render json: data
  end

  def create
    @loan = Loan.new(loan_params)
    puts @loan.inspect
    if @loan.save
      render json: { message: 'Success', loan: @loan }
    else
      render json: { message: 'Error', data: @loan.errors }
    end
  end

  def send_to_dept_manager
    @loan = Loan.find(params[:idloan])
    manager = User.find(params[:iduser]).dept.manager
    @loan.IdManager = manager.IdUser
    @loan.Manager = manager.full_name
    @loan.IdStep = 2
    @loan.Step = 'در حال بررسی توسط مدیر واحد'
    @loan.RequestDate = DateTime.now
    @loan.RequestDateShamsi = shamsi_date(DateTime.now)

    if @loan.save
      render json: { message: 'Success', loan: @loan }
    else
      render json: { message: 'Error', data: @loan.errors }
    end
  end

  def send_to_hr
    @loan = Loan.find(params[:idloan])
    @loan.ManagerNote = params[:Note]
    @loan.IdStep = 3
    @loan.Step = 'در حال بررسی توسط منابع انسانی'
    @loan.ManagerConfirmDate = DateTime.now
    @loan.ManagerConfirmDateShamsi = shamsi_date(DateTime.now)
    hr_manager = Role.find(55).user
    @loan.IdHr = hr_manager.IdUser
    @loan.Hr = hr_manager.full_name

    if @loan.save
      render json: { message: 'Success', loan: @loan }
    else
      render json: { message: 'Error', data: @loan.errors }
    end
  end

  def send_to_ceo
    @loan = Loan.find(params[:idloan])
    @loan.HrNote = params[:Note]
    @loan.IdStep = 4
    @loan.Step = 'در انتظار تایید مدیرعامل'
    @loan.HrConfirmDate = DateTime.now
    @loan.HrConfirmDateShamsi = shamsi_date(DateTime.now)
    ceo = Role.find(2).user
    @loan.IdCeo = ceo.IdUser
    @loan.Ceo = ceo.full_name

    puts ceo.inspect
    puts @loan.inspect

    if @loan.save
      render json: { message: 'Success', loan: @loan }
    else
      render json: { message: 'Error', data: @loan.errors }
    end
  end

  def send_to_finance
    @loan = Loan.find(params[:idloan])
    @loan.CeoNote = params[:Note]
    @loan.IdStep = 5
    @loan.Step = 'در انتظار پرداخت'
    @loan.CeoConfirmDate = DateTime.now
    @loan.CeoConfirmDateShamsi = shamsi_date(DateTime.now)
    finance_users = UserGroup.find(109).users.map{ |user|  user.IdUser }.join(",")
    @loan.IdFin = finance_users

    if @loan.save
      render json: { message: 'Success', loan: @loan }
    else
      render json: { message: 'Error', data: @loan.errors }
    end
  end

  def confirm_payment
    puts params.inspect
    @loan = Loan.find(params[:idloan])
    @loan.FinNote = params[:Note]
    @loan.IdStep = 6
    @loan.Step = 'پرداخت شده'
    @loan.State = 'Paid'
    @loan.Fin = User.find(params[:iduser]).full_name
    @loan.InstallmentFirstMonth = params[:InstallmentFirstMonth]
    @loan.InstallmentLastMonth = params[:InstallmentLastMonth]
    
    if @loan.save
      render json: { message: 'Success', loan: @loan }
    else
      render json: { message: 'Error', data: @loan.errors }
    end
  end

  def reject_by_dept_manager
    @loan = Loan.find(params[:idloan])
    @loan.ManagerNote = params[:Note]
    @loan.ManagerConfirmDate = DateTime.now
    @loan.ManagerConfirmDateShamsi = shamsi_date(DateTime.now)
    dept_manager = User.find(params[:iduser])
    @loan.Step = -1
    @loan.State = 'عدم تایید توسط ' + dept_manager.full_name
    if @loan.save
      render json: { message: 'Success', loan: @loan }
    else
      render json: { message: 'Error', data: @loan.errors }
    end
  end

  def reject_by_hr
    @loan = Loan.find(params[:idloan])
    @loan.HrNote = params[:Note]
    @loan.HrConfirmDate = DateTime.now
    @loan.HrConfirmDateShamsi = shamsi_date(DateTime.now)
    hr = User.find(params[:iduser])
    @loan.Step = -1
    @loan.State = 'عدم تایید توسط ' + hr.full_name
    if @loan.save
      render json: { message: 'Success', loan: @loan }
    else
      render json: { message: 'Error', data: @loan.errors }
    end
  end

  def reject_by_ceo
    @loan = Loan.find(params[:idloan])
    @loan.CeoNote = params[:Note]
    @loan.CeoConfirmDate = DateTime.now
    @loan.CeoConfirmDateShamsi = shamsi_date(DateTime.now)
    @loan.Step = -1
    @loan.State = 'عدم تایید توسط ' + @loan.Ceo
    if @loan.save
      render json: { message: 'Success', loan: @loan }
    else
      render json: { message: 'Error', data: @loan.errors }
    end
  end

  def loan_params
    params.require(:loan).permit(
      :IdLoan,
      :IdUser,
      :FullName,
      :PerNo,
      :IdLoanType,
      :LoanType,
      :IdStep,
      :Step,
      :State,
      :RequestDate,
      :RequestDateShamsi,
      :Amount,
      :Installments,
      :InstallmentAmount,
      :InstallmentFirstMonth,
      :InstallmentLastMonth,
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
      :HrConfirmDateShamsi
    )
  end

end