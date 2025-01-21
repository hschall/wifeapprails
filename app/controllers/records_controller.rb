class RecordsController < ApplicationController
  before_action :set_record, only: %i[show edit update destroy]
  before_action :authenticate_user!, except: [:index, :show]
  before_action :correct_user, only: [:edit, :update, :destroy]
  before_action :authenticate_user!, only: [:index]

  # GET /records or /records.json
def index
  if current_user
    if params[:master]
      if current_user.admin?
        @records = Record.all
      else
        redirect_to records_path, alert: "You are not authorized to view all users' records."
        return
      end
    else
      @records = current_user.records
    end

    # Apply user filter
    if params[:master] && params[:user_id].present?
      @records = @records.where(user_id: params[:user_id])
    end

    # Apply month filter
    if params[:month].present?
      if params[:month] == "all"
        # Skip month filtering
      else
        selected_month = params[:month].to_i
        case ActiveRecord::Base.connection.adapter_name
        when "SQLite"
          @records = @records.where("CAST(strftime('%m', fecha) AS INTEGER) = ?", selected_month)
        when "PostgreSQL"
          @records = @records.where("EXTRACT(MONTH FROM fecha) = ?", selected_month)
        end
      end
    else
      params[:month] = Date.today.month.to_s
      selected_month = params[:month].to_i
      case ActiveRecord::Base.connection.adapter_name
      when "SQLite"
        @records = @records.where("CAST(strftime('%m', fecha) AS INTEGER) = ?", selected_month)
      when "PostgreSQL"
        @records = @records.where("EXTRACT(MONTH FROM fecha) = ?", selected_month)
      end
    end

    # Calculate total amount
    @total_amount = @records.sum(:importe)

    # Apply pagination
    @records = @records.paginate(page: params[:page], per_page: 30)
  else
    redirect_to new_user_session_path, alert: "You must be logged in to view records."
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
