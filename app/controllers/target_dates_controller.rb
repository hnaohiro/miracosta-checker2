class TargetDatesController < ApplicationController
  before_action :set_target_date, only: [:show, :edit, :update, :destroy]

  # GET /target_dates
  # GET /target_dates.json
  def index
    @target_dates = TargetDate.all
  end

  # GET /target_dates/1
  # GET /target_dates/1.json
  def show
  end

  # GET /target_dates/new
  def new
    @target_date = TargetDate.new
  end

  # GET /target_dates/1/edit
  def edit
  end

  # POST /target_dates
  # POST /target_dates.json
  def create
    @target_date = TargetDate.new(target_date_params)

    respond_to do |format|
      if @target_date.save
        format.html { redirect_to target_dates_path, notice: 'Target date was successfully created.' }
        format.json { render :show, status: :created, location: @target_date }
      else
        format.html { render :new }
        format.json { render json: @target_date.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /target_dates/1
  # PATCH/PUT /target_dates/1.json
  def update
    respond_to do |format|
      if @target_date.update(target_date_params)
        format.html { redirect_to target_dates_path, notice: 'Target date was successfully updated.' }
        format.json { render :show, status: :ok, location: @target_date }
      else
        format.html { render :edit }
        format.json { render json: @target_date.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /target_dates/1
  # DELETE /target_dates/1.json
  def destroy
    @target_date.destroy
    respond_to do |format|
      format.html { redirect_to target_dates_url, notice: 'Target date was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_target_date
      @target_date = TargetDate.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def target_date_params
      params.require(:target_date).permit(:year, :month, :day, :enabled)
    end
end
