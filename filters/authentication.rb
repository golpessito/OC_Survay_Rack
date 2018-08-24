require 'rack'
require_relative '../views/view'
require_relative '../routes/router'
require_relative '../models/users'
require_relative '../models/answers'

class Authentication

  def initialize (app)
    @app=app
  end

  def call (env)
    status, headers, body = @app.call(env)
    response=Rack::Response.new body,status,headers
    request=Rack::Request.new(env)
    template_data = {}

    if (env["REQUEST_METHOD"]=="GET" && env["PATH_INFO"] == "/answers")
      unless request.cookies["logged"]
        #Redirect to login
        view = View.new("/login", template_data)
        body=[view.render]
        response=Rack::Response.new body,status,headers
      else
        #Redirect to answers
        template_data=Answer.all
        view = View.new("/answers", template_data)
        body=[view.render]
        response=Rack::Response.new body,status,headers
      end
    end

    response.finish
  end

end
