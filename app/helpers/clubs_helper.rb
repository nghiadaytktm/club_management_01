module ClubsHelper
  def get_day_view days
    days.join("-")
  end

  def get_field_club field
    field.html_safe unless field.nil?
  end
end