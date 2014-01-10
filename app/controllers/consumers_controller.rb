class ConsumersController < ApplicationController
  before_action :set_consumer, only: [:show, :edit, :update, :destroy]

  # GET /consumers
  # GET /consumers.json
  def index
    # curl http://localhost:3024/api/events -H 'Authorization: Token token=":token"'
    api_response = Curl.get("http://localhost:3024/api/events") do|http|
      http.headers['Authorization'] = 'Token token=' + params[:token]
    end
    @events = JSON.parse(api_response.body_str)
  end

  # GET /consumers/1
  # GET /consumers/1.json
  def show
    @consumer = Consumer.find(params[:id])
  end

  # GET /consumers/new
  def new
    @consumer = Consumer.new
  end

  # GET /consumers/1/edit
  def edit
  end

  # POST /consumers
  # POST /consumers.json
  def create
    @consumer = Consumer.new(consumer_params)

    respond_to do |format|
      if @consumer.save
        # curl -v -H 'Authorization: Token token=":token"' -H "Content-type: application/json" -X POST -d '{"event": {"action":"test", "description":"...", "scope": "admission"}}' http://localhost:3024/api/events
        url = "http://localhost:3024/api/events"
        Curl::Easy.http_post(url, Curl::PostField.content('event[action]', params[:consumer][:event_action]),
                             Curl::PostField.content('event[description]', params[:consumer][:event_description]),
                             Curl::PostField.content('event[scope]', params[:consumer][:event_scope])) do |http|
          http.headers['Authorization'] = 'Token token=' + params[:consumer][:token]
        end
        format.html { redirect_to @consumer, notice: 'Consumer event was successfully created.' }
        format.json { render action: 'show', status: :created, location: @consumer }
      else
        format.html { render action: 'new' }
        format.json { render json: @consumer.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /consumers/1
  # PATCH/PUT /consumers/1.json
  def update
    respond_to do |format|
      if @consumer.update(consumer_params)
        format.html { redirect_to @consumer, notice: 'Consumer event was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @consumer.errors, status: :unprocessable_entity }
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_consumer
      @consumer = Consumer.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def consumer_params
      params.require(:consumer).permit(:token, :event_action, :event_description, :event_scope)
    end
end
