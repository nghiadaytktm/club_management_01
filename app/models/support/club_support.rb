class Support::ClubSupport
  attr_reader :club

  def initialize club_value, page, organization
    @club_value = club_value
    @page = page
    @organization = organization
  end

  def members
    @club_value.user_clubs.newest
  end

  def albums
    @club_value.albums.newest.page(@page).per Settings.per_page_album
  end

  def events
    @club_value.events.newest.page(@page).per Settings.event_page
  end

  def users
    @organization.user_organizations.joined.without_user_ids(members.map(&:user_id)).includes(:user)
  end

  def images_club
    images = []
    albums = @club_value.albums.newest.includes(:images)
    albums.each do |album|
      album.images.newest.each do |image|
        images << image
      end
    end
    images
  end

  def history_budget
    @club_value.events.without_notification(Settings.notification).newest
  end

  def members_joined
    @club_value.user_clubs.joined
  end

  def messages
    @club_value.messages.take(Settings.chat_messages_limit)
  end
 end
