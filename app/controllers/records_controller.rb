class RecordsController < ApplicationController
  before_action :set_record, only: %i[ show edit update destroy ]
  before_action :authenticate_user!, except: [:index, :show]
  before_action :correct_user, only: [:edit, :update, :destroy]
  before_action :authenticate_user!, only: [:index]


  # GET /records or /records.json
  def index
    if current_user && params[:master] # Master view for logged-in users
      @records = Record.all
      @total_amount = @records.sum(:importe)
    else # Individual view for the logged-in user
      if current_user
        if params[:month]
          selected_date = Date.parse(params[:month] + "-01") rescue Date.today
          @records = Record.for_month(selected_date).where(user: current_user)
          @total_amount = @records.sum(:importe)
        else
          @records = Record.where(user: current_user)
          @total_amount = @records.sum(:importe)
        end
      else
        redirect_to new_user_session_path, alert: "You must be logged in to view records."
      end
    end
  end

  # GET /records/1 or /records/1.json
  def show
  end

  # GET /records/new
  def new
    #@record = Record.new
    @record = current_user.records.build
  end

  # GET /records/1/edit
  def edit
  end

  # POST /records or /records.json
  def create
  @record = current_user.records.build(record_params)

  respond_to do |format|
    if @record.save
      format.html { redirect_to records_path, notice: "Record was successfully created." }
      format.json { render :index, status: :created, location: records_path }
    else
      format.html { render :new, status: :unprocessable_entity }
      format.json { render json: @record.errors, status: :unprocessable_entity }
    end
  end
end


  # PATCH/PUT /records/1 or /records/1.json
  def update
  respond_to do |format|
    if @record.update(record_params)
      format.html { redirect_to records_path, notice: "Record was successfully updated." }
      format.json { render :index, status: :ok, location: records_path }
    else
      format.html { render :edit, status: :unprocessable_entity }
      format.json { render json: @record.errors, status: :unprocessable_entity }
    end
  end
end


  # DELETE /records/1 or /records/1.json
  def destroy
    @record.destroy!

    respond_to do |format|
      format.html { redirect_to records_path, status: :see_other, notice: "Record was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  def correct_user
  @record = current_user.records.find_by(id: params[:id])
  redirect_to records_path, notice: "Not Authorized to edit this record" if @record.nil?
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_record
      @record = Record.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def record_params
      params.require(:record).permit(:fecha, :concepto, :importe, :comentario, :user_id)
    end
end
