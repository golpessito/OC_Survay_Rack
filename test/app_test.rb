require "test/unit"
require "rack/test"
require "erb"
require_relative "../app"
require_relative "../models/users"


class AppTest < Test::Unit::TestCase
  include Rack::Test::Methods

  class << self
    def startup
      post_fixtures = [
        {
          username: 'maria',
          password: 'maria_secret'
        },
        {
          username: 'daniel',
          password: 'daniel_secret'
        }
      ].map { |params| User.create_user(params[:username],params[:password],"_test")}
    end

    def shutdown
      db_dir=File.dirname(__FILE__) + "/../db/users_test.json"
      File.open("#{db_dir}", 'w') {|file| file.truncate(0)}
    end

  end


  def app
    #app = lambda { |env| [200, {'Content-Type' => 'text/plain'}, ['All responses are OK']] }
    builder = Rack::Builder.new
    builder.run App.new
  end

  def test_root
    get '/'
    assert last_response.ok?
  end

  def test_root_form
    get '/'

    assert last_response.body.include?('Survay form about healthy style life')
  end

  def test_answers
    get '/answrs'

    assert last_response.body.include?('Not Found')
  end

  def test_sets_when_user_login
    post "/answers", user_name:"Administrator", password:"secret"
    assert last_response.body.include?('Survay Results')
  end

  def test_sets_when_user_not_login
    post "/answers", user_name:"Administrator", password:"secrt"
    assert last_response.body.include?('Please sign in')
  end

end
