require 'pp'
require 'cgi'
require_relative 'routes/router'
require_relative 'views/view'
require_relative 'models/answers'

class App

  def call(env)
    request = Rack::Request.new(env)

    #Response
    response_headers={}
    answers_data={}
    template_data={}

    #Routing
    route=Router.new(env)

    if env["REQUEST_METHOD"]=="POST"
     params=CGI::parse(env["rack.input"].read)
     answers={}
     mail=params["mail"] && params["mail"].first
     answers["gender"]=params["gender"] && params["gender"].first
     answers["smoke"]=params["smoke"] && params["smoke"].first
     answers["alcohol"]=params["alcohol"] && params["alcohol"].first
     answers["hour_of_sport"]=params["hour_of_sport"] && params["hour_of_sport"].first
     answers["litre_per_day"]=params["litre_per_day"] && params["litre_per_day"].first
     message_form_survay = Answer.create(mail,answers) ? "Thanks for answer this form!" : "Sorry your mail have been already used"
     template_data["message_form_survay"]=message_form_survay
    end

    #Template
    view = View.new(route.name, template_data)

    ##return
    [route.status, response_headers, [view.render]]
  end

end
