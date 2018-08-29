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

  def self.create_user(user_name,password)
    users=self.load_credentials

    my_user={}
    my_user["user_name"]=user_name
    my_user["password"]=BCrypt::Password.create(password)

    #Maybe I can add another answer without read all answers
    json_users=users << my_user
    File.open('db/users.json', 'w') {|file| file.write(JSON.generate(json_users))}
    return true
  end

  def self.autenticate?(user_name,password)

   my_credentials=self.load_credentials
   is_authenticate = false

   my_credentials.each do |user|
     user_name_credentials=user["user_name"]
     password_credentials=password_credentials=BCrypt::Password.new(user["password"])
     if ((user_name==user_name_credentials) && (password_credentials==password))
       return true
     end
   end

   return is_authenticate

 end

end
