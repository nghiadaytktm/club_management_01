class BudgetsController < ApplicationController
  before_action :load_club

  def index
    if params[:date_search]
      @events = @club.events.newest.event_category_activity_money(Event.array_style_event_money_except_activity,
        Event.event_categories[:activity_money])
        .includes(:budgets, :event_details).by_created_at(params[:date_search][:first_date],
        params[:date_search][:second_date]).page(params[:page]).per params[:limit_page]
    else
      @events = @club.events.newest.event_category_activity_money(Event.array_style_event_money_except_activity,
        Event.event_categories[:activity_money])
        .includes(:budgets, :event_details).page(params[:page]).per(params[:limit_page] || Settings.per_page)
    end
    if @events
      respond_to do |format|
        format.js
      end
    end
  end

  private
  def load_club
    @club = Club.find_by id: params["club_id"]
    unless @club
      flash[:danger] = t "cant_found_club"
      redirect_to root_path
    end
  end
end
