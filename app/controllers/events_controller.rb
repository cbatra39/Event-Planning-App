class EventsController < ApplicationController
  include Responses
  skip_before_action :verify_authenticity_token
  before_action :authenticate_user!

  def index
    @events = Event.where(event_status: "Active", is_approved: true)
    if @events.present?
      event_data = @events.map do |event|
        category_name = EventCategory.find(event.event_categories_id).event_category
        {
          id: event.id,
          title: event.title,
          location: event.location,
          latitude: event.latitude,
          longitude: event.longitude,
          is_approved: event.is_approved,
          event_status: event.event_status,
          start_date: event.start_date,
          start_time: event.start_time,
          end_date: event.end_date,
          end_time: event.end_time,
          user_id: event.user_id,
          description: event.description,
          event_category_id: event.event_categories_id,
          event_category_name: category_name,
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
  
    if @event.start_date.present? && @event.start_date > Date.today # Check if the event date is upcoming
      if @event.end_date.present? && @event.end_date < @event.start_date # Check if end date is earlier than start date
        error("End date must be greater than or equal to start date")
      elsif event_already_booked?(@event.location, @event.start_date, @event.end_date, @event.start_time, @event.end_time)
        error("Location is already booked for this date and time")
      elsif @event.save
        success("Event successfully created", id: @event.id)
      else
        error("Event not created")
      end
    else
      error("Event date must be in the future")
    end
  end
  

  def destroy
    @event = Event.find(params[:id])
    if @event
      if @event.user == current_user # Check if the event belongs to the current user
        @event.destroy
        success("Event deleted successfully")
      else
        error_403("You are not authorized to update this event") # User is not authorized to delete the event
      end
    else
      error_404("Event not found")
    end
  end

  def update
    @event = Event.find(params[:id])
    if @event
      if @event.user == current_user # Check if the event belongs to the current user
        if @event.start_date.present? && @event.start_date > Date.today && @event.end_date > Date.today # Check if the event date is upcoming
          if start_date_or_end_date_updated? && event_already_booked?(@event.location, params[:start_date], params[:end_date], @event.start_time, @event.end_time)
            error("Location is already booked for the new date and time")
          else
            if @event.update(set_params) # Update other parameters except date and time
              image = params[:image]
              if image.present?
                @event.image.attach(image)
              end
              @event.update(is_approved: false)
              success("Event updated successfully", id: @event.id)
            else
              error("Event update failed")
            end
          end
        else
          error("Event date must be in the future")
        end
      else
        error_403("You are not authorized to update this event") # User is not authorized to update the event
      end
    else
      error_404("Event not found")
    end
  end
  
  def start_date_or_end_date_updated?
    params[:start_date].present? || params[:end_date].present?
  end
  


      def show_all
        @events = Event.where(user_id: current_user)
        if @events.present?
          event_data = @events.map do |event|
            category_name = EventCategory.find(event.event_categories_id).event_category
            {
              id: event.id,
              title: event.title,
              location: event.location,
              latitude: event.latitude,
              longitude: event.longitude,
              is_approved: event.is_approved,
              event_status: event.event_status,
              start_date: event.start_date,
              start_time: event.start_time,
              end_date: event.end_date,
              end_time: event.end_time,
              user_id: event.user_id,
              description: event.description,
              event_category_id: event.event_categories_id,
              event_category_name: category_name,
              image_url: event.image.present? ? url_for(event.image) : nil
            }
          end
          success(data: event_data)
        else
          error_404("No event found for the user")
        end
      end
      
  
      private
      def event_already_booked?(location, start_date, end_date, start_time, end_time)
        existing_event = Event.where(location: location)
                              .where("start_date <= ? AND end_date >= ?", end_date, start_date)
                              .where("end_date > ? OR (end_date = ? AND end_time > ?)", start_date, start_date, start_time)
                              
        existing_event.present?
      end
      
  
    def set_params
      params.permit(:title, :location, :latitude, :longitude, :start_date, :start_time, :end_date, :end_time, :description, :event_categories_id)
    end
  end
  