class EventsController < ApplicationController
  include Responses
  skip_before_action :verify_authenticity_token
  before_action :authenticate_user!

# all events 
  def index
    @events = Event.all.where(is_approved:true, event_status: "active")
    if @events.present?
      event_data = build_event_data(@events)
      
      success(data: event_data)
    else
      error_404("No event found")
    end
  end



  def create
    @event = current_user.events.build(set_params)
    image = params[:image]
    if image.present?
      @event.image.attach(image)
    end

    if params[:hashtags].present?
      hashtag_names = params[:hashtags].first.gsub(/[\[\]\s]/, '').split(',').map { |name| name.delete('#') }.join(',')
      hashtags = hashtag_names.split(",")
      h = create_or_find_hashtags(hashtags) 
    end
  
    if @event.start_date.present? && @event.start_date > Time.zone.now
      if @event.save
        if h.present?
          h.each do |hashtag|
            EventHashtag.create(event_id: @event.id, hashtag_id: hashtag.id)
          end 
        end
        success("Event successfully created", id: @event.id)
      else
        error("all fields are required")
      end
    else
      error("Event date must be in the future")
    end
  end
 
  
  def destroy
    @event = Event.find_by(id: params[:id])
  
    if @event
      if @event.user == current_user
        EventHashtag.where(event_id: @event.id).destroy_all
        @event.destroy
        success("Event deleted successfully")
      else
        error_403("You are not authorized") # User is not authorized to delete the event
      end
    else
      error_404("Event not found") # Display custom error message for event not found
    end
  end
  
  
  def update
    @event = current_user.events.find_by(id: params[:id])
    if @event.present?

    image = params[:image]
    if image.present?
      @event.image.attach(image)
    end
  
    if params[:hashtags].present?
      hashtag_names = params[:hashtags].first.gsub(/[\[\]\s]/, '').split(',').map { |name| name.delete('#') }.join(',')
      hashtags = hashtag_names.split(",")
      h = create_or_find_hashtags(hashtags)
    end
  
    if @event.start_date.present? && @event.start_date > Time.zone.now
      if @event.update(set_params)
        if h.present?
          @event.event_hashtags.destroy_all
          h.each do |hashtag|
            EventHashtag.create(event_id: @event.id, hashtag_id: hashtag.id)
          end
        end
        success("Event successfully updated", id: @event.id)
      else
        error_400("all fields are required")
      end
    else
      error("Event date must be in the future")
    end
  else
    error_404("Event not found")
  end
  end
  
  
  
# all events of current user
  def show_all
    @events = Event.where(user_id: current_user)
    if @events.present?
      event_data = build_event_data(@events)
      success(data: event_data)
    else
      error_404("No event found for the user")
    end
  end



  def sort_events
    order_by = params[:order_by]
    case order_by
    when "start_time"
      @events = Event.order(start_time: :asc)
    when "start_date"
      @events = Event.order(start_date: :asc)
    else
      @events = Event.all
    end
    
    if @events.present?
      event_data = build_event_data(@events)
      success(data: event_data)
    else
      error_404("not found")
    end
  end
  
  def search_events
    search_by = params[:search_by]
    case search_by
    when 'location'
      @events = Event.where(location: params[:location])
    when 'start_date'
      @events = Event.where(start_date: params[:start_date])
    when 'title'
      @events = Event.where(title: params[:title])
    else
      @events = Event.all
    end
  
    if @events.present?
      event_data = build_event_data(@events)
      success(data: event_data)
    else
      error_404("Not found")
    end
  end
  
  def event_categories
    @categories = EventCategory.all
    data = @categories.map { |category| { id: category.id, category_name: category.event_category } }
    success(event_category: data)
  end
  


#report event or user
def report
  type = params[:type]
  case type
  when 1
    report_event(type)
  when 2
    report_user(type)
  else
    error("Invalid report type")
  end
end


  def report_event(type)
    event = Event.find_by(id: params[:id])
    description = params[:description]

    if event.nil?
      error_404("Event not found")
      return
    end

    if event.user_id == current_user.id
      error("You cannot report your own event")
      return
    end
   
    if Report.exists?(reported_id: event.id, reported_by_id: current_user.id, report_type: type)
      error("You have already reported this event")
      return
    end
  


    reported_event = Report.create(reported_id: event.id, reported_by_id: current_user.id,report_type: type, description: description)
    if reported_event.save
      success("Event reported successfully")
    else
      error("Failed to report the event")
    end
  end

def report_user(type)
    user = User.find_by(id: params[:id])
    description = params[:description]

    if user.nil?
      error_404("user not found")
      return
    end

    if user.id == current_user.id
      error("You cannot report yourself")
      return
    end

    if Report.exists?(reported_id: user.id, reported_by_id: current_user.id, report_type: type)
      error("You have already reported this event")
      return
    end
  


    reported_user = Report.create(reported_id: user.id, reported_by_id: current_user.id,report_type:type, description: description)
    if reported_user.save
      success("User reported successfully")
    else
      error("Failed to report the User")
    end
 end
  

 def mark_favourite
  event = Event.find_by(id: params[:id])
  unless event
    return  error_404("Event not found")
  end
  favourite_event = FavouriteEvent.find_by(user_id: current_user.id, event_id: event.id)
  if favourite_event
    favourite_event.destroy
    success("Event is unmarkedfrom from favourite")
  else
  favourite_event = FavouriteEvent.new(user_id: current_user.id, event_id: event.id)
  if favourite_event.save
    success("Event marked as favorite")
  else
    error("Failed to mark event as favorite")
  end
end
end

def join_event
  event = Event.find_by(id: params[:id])
  unless event
    return error_404("Event not found")
  end
  join_event = EventAttendee.find_by(user_id: current_user.id, event_id: event.id)
  if join_event
    join_event.destroy
    success("You canceled this join")
  else
  attendee = EventAttendee.new(user_id: current_user.id, event_id: event.id)
  if attendee.save
    success("You have joined the event")
  else
    error("Failed to join the event")
  end
end
end


  def follow_user
    followed_user = User.find_by(id: params[:id])
    unless followed_user
      return error_404("User not found")
    end

    isfollowed =  UserFollower.find_by(user_id: followed_user.id, followed_by_id: current_user.id)
    if  isfollowed 
      isfollowed.destroy
      success("You have unfollowed this user")
    else
    follower = UserFollower.create(user_id: followed_user.id, followed_by_id: current_user.id)
    if follower.save
      success("You are now following ")
    else
      error("Failed to follow the user")
    end
  end
end


  def like_event
    event = Event.find_by(id: params[:id])
    
    unless event
      return error_404("Event not found")
    end
    
    like = LikeEvent.find_by(event_id: event.id, user_id: current_user.id)
    
    if like
      like.destroy
      success("You have unliked the event")
    else
      like = LikeEvent.create(event_id: event.id, user_id: current_user.id)
      
      if like.save
        success("You have liked the event")
      else
        error("Failed to like the event")
      end
    end
  end
  

  
private


def build_event_data(events)
  events.map do |event|
    category_name = EventCategory.find(event.event_categories_id).event_category
    user = Profile.find_by(user_id: event.user_id)
    hashtags = event.hashtags.pluck(:name)
    if user.image.present?
      profileimage = url_for(user.image)
    else
      profileimage = nil
    end
    {
      id: event.id,
      title: event.title,
      location: event.location,
      latitude: event.latitude,
      longitude: event.longitude,
      is_approved: event.is_approved,
      event_status: event.event_status,
      start_date: event.start_date,
      start_time: event.start_time.strftime('%H:%M'),
      end_date: event.end_date,
      end_time: event.end_time.strftime('%H:%M'),
      user_id: event.user_id,
      description: event.description,
      event_category_id: event.event_categories_id,
      event_category_name: category_name,
      hashtags: hashtags,
      user_name: user.first_name + " " + user.last_name,
      image_url: event.image.present? ? url_for(event.image) : nil,
      user_profile_image: profileimage
     
    }
  end
end

       
  def create_or_find_hashtags(hashtag_names)
    hashtags = []
    hashtag_names.each do |name|
      hashtag = Hashtag.find_or_create_by(name: name) # Find or create the hashtag based on the name
      hashtags << hashtag
    end
    hashtags
  end
   
      
  
    def set_params
      params.permit(:title, :location, :latitude, :longitude, :start_date, :start_time, :end_date, :end_time, :description, :event_categories_id)
    end
  end
  