class EvaluatesController < ApplicationController
  before_action :authenticate_user!
  before_action :load_club
  before_action :load_evaluate, except: [:new, :index, :create]
  before_action :all_evaluates, only: :index
  before_action :load_rules, only: [:new, :edit]
  authorize_resource

  def new
    if @club
      @evaluate = @club.evaluates.build
    end
  end

  def create
    @evaluate = @club.evaluates.new params_evaluate
    if params[:rule_detail_ids].is_a?(Array) && params[:note].is_a?(Array)
      ActiveRecord::Base.transaction do
        import_evaluate_details
      end
    else
      flash.now[:danger] = t ".error_process"
    end
  rescue
    flash.now[:danger] = t ".error_process"
  end

  def index; end

  def show; end

  def edit; end

  def update
    if params[:rule_detail_ids].is_a?(Array) && params[:note].is_a?(Array)
      ActiveRecord::Base.transaction do
        @evaluate.evaluate_details.delete_all
        import_evaluate_details
      end
    else
      flash.now[:danger] = t ".error_process"
    end
    all_evaluates
  rescue
    flash.now[:danger] = t ".error_process"
  end

  def destroy
    if @evaluate && @evaluate.destroy
      flash.now[:success] = t ".success"
    else
      flash.now[:danger] = t ".error_process"
    end
  end

  private
  def load_club
    @club = Club.find_by slug: params[:club_id]
    return if @club
    flash[:danger] = t ".club_not_found"
  end

  def params_evaluate
    params.permit(:time).merge! year: params[:date][:year], total_points: count_point,
      user_id: current_user.id
  end

  def count_point
    if params[:rule_detail_ids].is_a? Array
      RuleDetail.by_ids(params[:rule_detail_ids]).sum(&:points)
    end
  end

  def load_evaluate
    if @club
      @evaluate = Evaluate.includes(:evaluate_details).find_by id: params[:id]
      return if @evaluate
      flash[:danger] = t ".evaluate_not_found"
    end
  end

  def import_evaluate_details
    if @evaluate.update_attributes params_evaluate
      details = []
      params[:rule_detail_ids].each_with_index do |rule_detail_id, index|
        details << @evaluate.evaluate_details.new(rule_detail_id: rule_detail_id,
          note: params[:note][index])
      end
    end
    EvaluateDetail.import details
    flash.now[:success] = t ".success"
  end

  def all_evaluates
    if @club
      @evaluates = @club.evaluates.newest.page(params[:page]).per Settings.per_page
    end
  end

  def load_rules
    @rules = @club.organization.rules.includes(:rule_details).newest if @club
  end
end
