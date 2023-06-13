class Admin::ReportsController < ApplicationController
    before_action :authenticate_user!
    
    def index
        @reports = Report.all
    end


    def update_status
        @report =  Report.find_by(id:params[:id])
        if @report.status == "reported" && @report.report_type == 2 
            @user = User.find_by(id:@report.reported_id)
            if @user.status == "suspended"
                @report.update(status: :suspended)
            else
                @user.update(status: :active)
                @report.update(status: :approved)
                debugger
                AccountSuspensionMailer.approved(@user).deliver_now
            end
        elsif @report.status == "reported" &&  @report.report_type == 1
            @event =  Event.find_by(id:@report.reported_id)
            @user = User.find_by(id: @event.user_id)
            # if @event.is_approved == false
            #     @report.update(status: :suspended)
            # else
            @event.update(is_approved: true)
            @report.update(status: :approved)
            AccountSuspensionMailer.event_approved(@user,@event).deliver_later
            # end
           
        end
        redirect_to admin_reports_path
    end


    def disapprove
        @report = Report.find_by(id:params[:id])
        if(@report.status == "reported" &&  @report.report_type == 2)
            @user = User.find_by(id: @event.user_id)
            @user.update(status: :suspended)
            @event =  Event.find_by(user_id: @user.id)
            @event.update(is_approved: false, event_status: :suspended)
            @report.update(status: :suspended)
            AccountSuspensionMailer.suspended(@user).deliver_now

        end

        if(@report.status == "reported" &&  @report.report_type == 1)
            @event =  Event.find_by(id:@report.reported_id)
            @event.update(is_approved: false, event_status: :suspended)
            @user = User.find_by(id: @event.user_id)
            @report.update(status: :suspended)
            AccountSuspensionMailer.event_suspended(@user,@event).deliver_later


        end
        redirect_to admin_reports_path
    end


    def show
        @report = Report.find_by(id:params[:id])
        if @report.report_type == 1
            @data = Event.find_by(id:@report.reported_id)
<<<<<<< HEAD
        else
            @data =User.find_by(id:@report.reported_id)
        end
    end
=======
        elsif @report.report_type == 2
            @data = User.find_by(id:@report.reported_id)
        end
    end


>>>>>>> origin/development
end