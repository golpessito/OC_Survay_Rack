require 'pp'
require 'cgi'
require 'http-cookie'
require 'uri'
require_relative 'routes/router'
require_relative 'views/view'
require_relative 'models/answers'
require_relative 'models/users'

class App

  def call(env)

    request = Rack::Request.new(env)
    request_method=env["REQUEST_METHOD"]
    path_info=env["PATH_INFO"]

    #Response
    response_headers={}
    answers_data={}
    template_data={}

    #Routing
    route=Router.new(env)
    route_name=route.name

    if request_method=="POST"
      case route_name
        when :home
          template_data=create_answer(env)
        when :answers
          #Check if the user is valid
          login=get_login_params(env)
          user_valid=User.autenticate?(login["user_name"],login["password"])
          authenticate_user(response_headers) if user_valid #Authenticate User With Cookie

          #Redirect depens on if the user is valid or not
          route.name=user_valid ? :answers : :login
          template_data=user_valid ? Answer.all : {}
      end

    end

    #Template
    view = View.new(route.name, template_data)

    #return
    [route.status, response_headers, [view.render]]
  end

  #Athenticate User
  def authenticate_user(response_headers)
    # Set Cookie
    cookie = HTTP::Cookie.new("logged", "true", origin: uri = URI("http://localhost:9292"),
                                         path: '/',
                                         max_age: 5*60)

    response_headers['Set-Cookie'] = cookie.set_cookie_value
  end

  def create_answer(env)
    template_data={}
    answer=get_answers_params(env)
    answer_created=Answer.create(answer['mail'],answer['answers'])
    msg_survay = answer_created ? "Thanks for answer this form!" : "Sorry your mail have been already used"
    error = answer_created ? false : true
    template_data["msg_survay"]=msg_survay
    template_data["error"]=error
    return template_data
  end

  #*** PARAMS POST METHOD ***

  #From home page
  def get_answers_params(env)
    params=CGI::parse(env["rack.input"].read)
    answer={}
    answer['mail']=params["mail"] && params["mail"].first
    answer['answers']={}
    answer['answers']["age"]=params["age"] && params["age"].first
    answer['answers']["gender"]=params["gender"] && params["gender"].first
    answer['answers']["smoke"]=params["smoke"] && params["smoke"].first
    answer['answers']["alcohol"]=params["alcohol"] && params["alcohol"].first
    answer['answers']["hour_of_sport"]=params["hour_of_sport"] && params["hour_of_sport"].first
    answer['answers']["litre_per_day"]=params["litre_per_day"] && params["litre_per_day"].first
    return answer
  end

  #From home answers page
  def get_login_params(env)
    params=CGI::parse(env["rack.input"].read)
    login={}

    login["user_name"]=params["user_name"] && params["user_name"].first
    login["password"]=params["password"] && params["password"].first
    return login
  end

end
