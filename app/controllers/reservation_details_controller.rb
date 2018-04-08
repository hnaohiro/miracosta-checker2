class ReservationDetailsController < ApplicationController
  before_action :set_reservation_detail, only: [:show, :edit, :update, :destroy]

  # GET /reservation_details
  # GET /reservation_details.json
  def index
    @reservation_details = ReservationDetail.all
  end

  # GET /reservation_details/1
  # GET /reservation_details/1.json
  def show
  end

  # GET /reservation_details/new
  def new
    @reservation_detail = ReservationDetail.new
  end

  # GET /reservation_details/1/edit
  def edit
  end

  # POST /reservation_details
  # POST /reservation_details.json
  def create
    @reservation_detail = ReservationDetail.new(reservation_detail_params)

    respond_to do |format|
      if @reservation_detail.save
        format.html { redirect_to @reservation_detail, notice: 'Reservation detail was successfully created.' }
        format.json { render :show, status: :created, location: @reservation_detail }
      else
        format.html { render :new }
        format.json { render json: @reservation_detail.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /reservation_details/1
  # PATCH/PUT /reservation_details/1.json
  def update
    respond_to do |format|
      if @reservation_detail.update(reservation_detail_params)
        format.html { redirect_to @reservation_detail, notice: 'Reservation detail was successfully updated.' }
        format.json { render :show, status: :ok, location: @reservation_detail }
      else
        format.html { render :edit }
        format.json { render json: @reservation_detail.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /reservation_details/1
  # DELETE /reservation_details/1.json
  def destroy
    @reservation_detail.destroy
    respond_to do |format|
      format.html { redirect_to reservation_details_url, notice: 'Reservation detail was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_reservation_detail
      @reservation_detail = ReservationDetail.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def reservation_detail_params
      params.require(:reservation_detail).permit(:room_id, :target_date_id, :reservable)
    end
end
