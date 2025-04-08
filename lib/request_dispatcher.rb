class RequestDispatcher
  attr_reader :app, :session, :input, :phone_number, :client, :state,
              :response, :input

  class << self
    def call(params)
      new(params).process_request
    end
  end

  def initialize(params)
    @app = SanareiApp.find_by(app_id: params[:shortCode])

    @state = 'end' if @app.nil?
    @response = "END AppID #{@app}#"
  end

  def process_request
    if state == 'end'
      { responseMessage: response, responseExitCode: 200 }
    else
      { responseMessage: response, responseExitCode: 200 }
    end
  end
end
