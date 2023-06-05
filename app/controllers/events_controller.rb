class EventsController < ApplicationController
  include Responses
  skip_before_action :verify_authenticity_token
  before_action :authenticate_user!



  def index
    @events = Event.where(is_approved:true, event_status: "active")
    if @events.present?
      event_data = @events.map do |event|
        category_name = EventCategory.find(event.event_categories_id).event_category
        hashtags = event.hashtags.pluck(:name)
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
          image_url: event.image.present? ? url_for(event.image) : nil
        }
      end
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
    @event = current_user.events.find(params[:id])
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
          # Delete existing event hashtags that are not in the updated hashtags list
          @event.event_hashtags.where.not(hashtag_id: h.pluck(:id)).destroy_all
  
          # Create new event hashtags
          h.each do |hashtag|
            unless @event.event_hashtags.exists?(hashtag_id: hashtag.id)
              EventHashtag.create(event_id: @event.id, hashtag_id: hashtag.id)
            end
          end
        else
          # If no hashtags are provided, delete all existing event hashtags
          @event.event_hashtags.destroy_all
        end
        success("Event successfully updated")
      else
        error("all fields are required")
      end
    else
      error("Event date must be in the future")
    end
  end
  
  
  

  def show_all
    @events = Event.where(user_id: current_user)
    
    if @events.present?
      event_data = @events.map do |event|
        category_name = EventCategory.find(event.event_categories_id).event_category
        
        # Fetch associated hashtags for the event
        hashtags = event.hashtags.pluck(:name)
        
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
          hashtags: hashtags, # Include the associated hashtags in the response
          image_url: event.image.present? ? url_for(event.image) : nil
        }
      end
      
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
      event_data = @events.map do |event|
        category_name = EventCategory.find(event.event_categories_id).event_category
        hashtags = event.hashtags.pluck(:name)
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
          image_url: event.image.present? ? url_for(event.image) : nil
        }
      end
      success(data: event_data)
    else
      success(data: [])
    end
  end
  

  def event_categories
    @categories = EventCategory.all
    data = @categories.map { |category| { id: category.id, category_name: category.event_category } }
    success(event_category: data)
  end
  



  
private

       
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
  