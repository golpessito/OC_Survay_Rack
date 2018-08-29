class Router

  #name   {/homepage, /answers}
  #status {200 => OK, 404 => Error}
  attr_accessor :name,:status

  ROUTES = {
    "GET" => {
      "/" => :home,
      "/answers" => :answers,
      "/login" => :login
    },
    "POST" => {
      "/" => :home,
      "/answers" => :answers
    }
  }

  def initialize (env)

    http_method=env["REQUEST_METHOD"]
    path=env["PATH_INFO"]

    @name = ROUTES[http_method][path] ? ROUTES[http_method][path] : :not_found
    @status =  @name ? 200 : 404
  end

end
