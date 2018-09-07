require 'test/unit'
require_relative '../models/users'

class UserTest < Test::Unit::TestCase
  class << self
    def startup
      ENV["test"]="test"

      post_fixtures = [
        {
          username: 'maria',
          password: 'maria_secret'
        },
        {
          username: 'daniel',
          password: 'daniel_secret'
        }
      ].map { |params| User.create_user(params[:username],params[:password])}
    end

    def shutdown
      db_dir=File.dirname(__FILE__) + "/../db/users_test.json"
      File.open("#{db_dir}", 'w') {|file| file.truncate(0)}
    end
  end

  def test_user_names_exists

     credentials=credentials=User.load_credentials

     user_name="#{credentials[0]['user_name']}"
     assert_equal("maria",user_name, "Maria should be exist")

     user_name="#{credentials[1]['user_name']}"
     assert_equal("daniel",user_name, "Daniel should be exist")
  end

  def test_user_uthenticated
     credentials=credentials=User.load_credentials

     user_name="#{credentials[0]['user_name']}"
     assert(User.autenticate?(user_name,"maria_secret"),"Should be autenticated")

     user_name="#{credentials[1]['user_name']}"
     assert(User.autenticate?(user_name,"daniel_secret"),"Should be autenticated")
  end

  def test_create_user
    User.create_user("pedro","secret")
    assert(User.autenticate?("pedro","secret"),"Should be autenticated")
  end

end
