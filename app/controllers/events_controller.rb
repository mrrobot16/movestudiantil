class EventsController < ApplicationController
  include EventsHelper
  before_action :authenticate_user!, except: [:index, :show, :calendar]
  before_action :set_event, only: [:show, :edit, :update, :destroy]
  before_action :set_date, only: [:index, :calendar]
  before_action :set_colors, only: [:index, :show]
  @@monthToES = {
    "january":"enero",
    "febuary":"febrero",
    "march":"marzo",
    "april":"april",
    "may":"mayo",
    "june":"junio",
    "july":"julio",
    "august":"agosto",
    "september":"septiembre",
    "october":"octubre",
    "november":"noviembre",
    "december":"diciembre"
  }
  @@monthToES2 ={
    "jan":"enero",
    "feb":"febrero",
    "mar":"marzo",
    "apr":"april",
    "may":"mayo",
    "jun":"junio",
    "jul":"julio",
    "aug":"agosto",
    "sep":"septiembre",
    "oct":"octubre",
    "nov":"noviembre",
    "dec":"diciembre"
  }

  @@dayToES = {
    "mon":'Lunes',
    "tue":'Martes',
    "wen":"Miercoles",
    "thu":"Jueves",
    'fri':"Viernes",
    "sat":"Sabado",
    "sun":"Domingo"
  }
  def index
    # Lets just show the next 20 events and worry about proper navigation sorting another time.
    @events_by_week = Event.where('start > ?', @date).order(:start).limit(params[:limit]).group_by(&:start_date)
    # @events_by_week = Event.where(:start => @date.yesterday..@date.at_end_of_week + 1.day).order(:start).group_by(&:start_date) || Event.this_week.order(:start).group_by(&:start_date)
    ## display variables
    @display_month = @date.year < Date.current.year ? @date.strftime("%B %Y") : @date.strftime("%B")
    @spanish_month = @@monthToES[@display_month.downcase.intern].capitalize
  end

  def calendar
    @events = Event.all
    @events_by_date = @events.group_by(&:start_date)
  end

  def show
  end

  def new
    @event = Event.new(
        start: (DateTime.now + 1.hour).beginning_of_hour,
        finish: (DateTime.now + 2.hour).beginning_of_hour)
    # @location = @event.build_location_event.build_location
  end

  def edit
    @location = @event.location || @event.build_location_event.build_location

    if @event.user != current_user
      redirect_to events_url, notice: 'Invalid Permissions.'
    end
  end

  def create
    @event = Event.new(event_params.except(:location))
    @event.user = current_user
    # @location = Location.find_or_initialize_by(location_params)
    # @event.build_location_event.location = @location
    respond_to do |format|

      if @event.save
        format.html { redirect_to @event, notice: 'ENCUENTRO INICIADO' }
        format.json { render json: @event.errors, status: :unprocessable_entity }
      else
        format.html { render action: 'new' }
        format.json { render json: @event.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    # Creates a valid Event Location
    # @location = @event.location || @event.build_location_event.build_location

    # If the location exists use else make a new one
    # @event.location_event.location = Location.find_or_initialize_by(location_params)
    # @event.location_event.location.update(location_params)

    respond_to do |format|
      if @event.user == current_user && @event.update(event_params.except(:location))
        format.html { redirect_to @event, notice: 'ENCUENTRO EDITADO' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @event.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    respond_to do |format|
      if @event.user == current_user && @event.destroy
        format.html { redirect_to events_url, notice: @event.title + ' BORRADO' }
        format.json { head :no_content }
      else
        format.html { redirect_to events_url, notice: 'Invalid Permissions.' }
      end
    end
  end

  private

    # Use callbacks to share common setup or constraints between actions.
    def set_event
      @event = Event.find(params[:id])
    end

    def set_date
      @date = params[:date] ? Date.parse(params[:date]) : Date.current
      # p @date
      # p @date.strftime("%B %Y")
    end

    def set_colors
      @colors = %w(#f44336 #E91E63 #9C27B0 #673AB7
                 #3F51B5 #2196F3 #03A9F4 #00BCD4
                 #009688 #4CAF50 #8BC34A #CDDC39
                 #FFC107 #FF9800 #FF5722)
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def event_params
      # params.require(:event).permit(:title, :start, :finish, :ticketurl, :description, :location => [:name, :streetnumber, :street, :city, :state, :zip, :country, :unit, :long_address])
      params.require(:event).permit(:title, :start, :finish, :ticketurl, :description, :regroup_location, :finish_line)
    end

    def location_params
      event_params[:location]
    end

end
