require 'bcrypt'
require 'json'

class User

  attr_accessor :user_name, :password

  def self.load_credentials
    begin
      ## I have to use __FILE__
      json_answers=File.read("db/users.json")
      return JSON.parse(json_answers)
    rescue
      #Check this because if is the answers.json is bad we will be reset
      #the file
      return []
    end
  end

  def self.autenticate?(user_name,password)

   my_credentials=self.load_credentials
   user_name_credentials=my_credentials[0]["user_name"]
   password_credentials=BCrypt::Password.new(my_credentials[0]["password"])

   ((user_name==user_name_credentials) && (password_credentials==password)) ? true : false
   
 end

end
