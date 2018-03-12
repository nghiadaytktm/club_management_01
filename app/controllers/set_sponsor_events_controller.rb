class SetSponsorEventsController < ApplicationController
  before_action :authenticate_user!
  before_action :load_organization, only: [:index, :update, :edit]
  before_action :load_sponsor, only: [:show, :edit, :update]

  def index
    @sponsors = Support::SponsorSupport.new params[:page], @organization
  end

  def show; end

  def edit; end

  def update
    case when params[:status].to_i == Sponsor.statuses[:accept]
      approve_sponsor
    when params[:status].to_i == Sponsor.statuses[:rejected]
      reject_sponsor
    else
      flash.now[:danger] = t "approve_error"
    end
    @sponsors = Support::SponsorSupport.new params[:page], @organization
    respond_to do |format|
      format.html
      format.js
    end
  end

  private
  def load_organization
    @organization = Organization.find_by id: params[:organization_id]
    return if @organization
    flash[:danger] = t("organization_not_found")
    redirect_to root_url
  end

  def reject_sponsor_params
    params.require(:sponsor).permit(:note)
      .merge! status: Sponsor.statuses[:rejected]
  end

  def load_sponsor
    @sponsor = Sponsor.find_by id: params[:id]
    unless @sponsor
      flash[:danger] = t "not_found"
      redirect_to club_event_path @club, @event
    end
  end

  def approve_sponsor
    if @sponsor.accept!
      flash.now[:success] = t "approve_success"
    else
      flash.now[:danger] = t "approve_error"
    end
  end

  def reject_sponsor
    if @sponsor.update_attributes reject_sponsor_params
      flash.now[:success] = t "reject_success"
    else
      flash.now[:danger] = t "reject_error"
    end
  end
end