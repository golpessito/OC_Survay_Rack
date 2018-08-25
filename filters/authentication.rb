require 'rack'
require_relative '../models/answers'

class Authentication

  def initialize (app)
    @app=app
  end

  def call (env)

    #Response
    status, headers, body = @app.call(env)
    response=Rack::Response.new body,status,headers
    template_data = {}

    #Request
    request=Rack::Request.new(env)
    request_method=env["REQUEST_METHOD"]
    path_info=env["PATH_INFO"]

    #The page protected
    if (request_method=="GET" &&  path_info=="/answers")

      view = View.new("/answers", template_data)

      unless request.cookies["logged"]
        #Redirect to login
        view.redirect_page("/login")
      else
        #Redirect to answers with all answers
        template_data=Answer.all
        view.data=template_data
      end

      body=[view.render]
      response=Rack::Response.new body,status,headers
    end

    response.finish
  end
  
end
