class SuggestionController < ApplicationController
  def new
    user = User.find(params[:iduser])
    dept = user.dept
    full_name = user.full_name
    render json: {iddept: dept.IdDl, dept:dept.dl.Title, full_name:full_name, roles: user.roles }
  end
  
  def show
    user = User.find(params[:iduser])
    suggestion = Suggestion.find(params[:idsuggestion])
    render json: {suggestion: suggestion,  roles: user.roles }
  end

  def create
    @suggestion = Suggestion.new(suggestion_params)
    @suggestion[:State] = 'Reviewing'
    if @suggestion.save
      render json: @suggestion
    else
      render json: { message: 'Failed', data: @suggestion.errors }
    end
  end

  def update
    @suggestion = Suggestion.find(params[:idsuggestion])
    if @suggestion.update(suggestion_params)
      render json: @suggestion
    else
      render json: { message: 'Failed', data: @suggestion.errors }
    end
  end

  
  def suggestion_params
    params.require(:suggestion).permit(
      :IdUser,
      :FullName,
      :IdDept,
      :Dept,
      :Visibility,
      :Title,
      :Description,
      :MeasurabilityType,
      :SuggestionType,
      :EffectType,
      :EffectTypeOther,
      :Scope,
      :Before,
      :After,
      :Budget,
      :Result,
      :Bonus,
      :CashBonus,
      :NonCashBonus,
      :State
    )
  end
end
