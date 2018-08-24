require 'pp'
require 'cgi'
require 'http-cookie'
require_relative 'routes/router'
require_relative 'views/view'
require_relative 'models/answers'
require_relative 'models/users'
require 'uri'

class App

  def call(env)

    request = Rack::Request.new(env)

    #Response
    response_headers={}
    answers_data={}
    template_data={}

    #Routing
    route=Router.new(env)

    if env["REQUEST_METHOD"]=="POST" && env["PATH_INFO"] == "/home"

     params=CGI::parse(env["rack.input"].read)
     answers={}

     mail=params["mail"] && params["mail"].first
     answers["age"]=params["age"] && params["age"].first
     answers["gender"]=params["gender"] && params["gender"].first
     answers["smoke"]=params["smoke"] && params["smoke"].first
     answers["alcohol"]=params["alcohol"] && params["alcohol"].first
     answers["hour_of_sport"]=params["hour_of_sport"] && params["hour_of_sport"].first
     answers["litre_per_day"]=params["litre_per_day"] && params["litre_per_day"].first

     message_form_survay=""
     error=false
     if Answer.create(mail,answers)
       message_form_survay="Thanks for answer this form!"
     else
       message_form_survay="Sorry your mail have been already used"
       error=true
     end

     template_data["message_form_survay"]=message_form_survay
     template_data["error"]=error

   elsif env["REQUEST_METHOD"]=="POST" && env["PATH_INFO"] == "/answers"

      params=CGI::parse(env["rack.input"].read)
      login={}

      login["user_name"]=params["user_name"] && params["user_name"].first
      login["password"]=params["password"] && params["password"].first

      if User.autenticate?(login["user_name"],login["password"])

       # Set Cookie
        cookie = HTTP::Cookie.new("logged", "true", origin: uri = URI("http://localhost:9292"),
                                            path: '/',
                                            max_age: 5*60)
       response_headers['Set-Cookie'] = cookie.set_cookie_value

       #Redirect to answers
       template_data=Answer.all
       route.name=:answers
      else
        #Redirect to login
        route.name=:login
      end
    end

    #Template
    view = View.new(route.name, template_data)

    ##return
    [route.status, response_headers, [view.render]]
  end

end
