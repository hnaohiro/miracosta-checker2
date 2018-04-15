class ReservationsController < ApplicationController
  before_action :set_reservation, only: [:show, :edit, :update, :destroy]
  protect_from_forgery except: :create

  # GET /reservations
  # GET /reservations.json
  def index
    @reservations = Reservation.all
  end

  # GET /reservations/1
  # GET /reservations/1.json
  def show
  end

  # GET /reservations/new
  def new
    @reservation = Reservation.new
  end

  # GET /reservations/1/edit
  def edit
  end

  # POST /reservations
  # POST /reservations.json
  def create
    respond_to do |format|
      format.html do
        @reservation = Reservation.new(reservation_params)

        if @reservation.save
          redirect_to @reservation, notice: 'Reservation was successfully created.'
        else
          render :new 
        end
      end

      format.json do
        json_request = JSON.parse(request.body.read)
        reservation_details = json_request['reservation']['reservation_details'].map do |data|
          ReservationDetail.new(room_id: data['room_id'], target_date_id: data['target_date_id'], reservable: data['reservable'])
        end
        @reservation = Reservation.new(reservation_details: reservation_details)

        if @reservation.save
          render :show, status: :created, location: @reservation
        else
          render json: @reservation.errors, status: :unprocessable_entity
        end
      end
    end
  end

  # PATCH/PUT /reservations/1
  # PATCH/PUT /reservations/1.json
  def update
    respond_to do |format|
      if @reservation.update(reservation_params)
        format.html { redirect_to @reservation, notice: 'Reservation was successfully updated.' }
        format.json { render :show, status: :ok, location: @reservation }
      else
        format.html { render :edit }
        format.json { render json: @reservation.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /reservations/1
  # DELETE /reservations/1.json
  def destroy
    @reservation.destroy
    respond_to do |format|
      format.html { redirect_to reservations_url, notice: 'Reservation was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_reservation
      @reservation = Reservation.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def reservation_params
      params.fetch(:reservation, {})
    end
end
