require 'bcrypt'
require 'json'

class User

  attr_accessor :user_name, :password

  def self.dir_db
    env="_test" if ENV["test"]
    dir_db=File.dirname(__FILE__) + "/../db/users#{env}.json"
  end

  def self.load_credentials
    begin
      db=dir_db
      json_users=File.read("#{db}")
      return JSON.parse(json_users)
    rescue
      #Check this because if is the answers.json is bad we will be reset
      #the file
      return []
    end
  end

  def self.create_user(user_name,password)

    db=dir_db

    users=self.load_credentials
    my_user={}
    my_user["user_name"]=user_name
    my_user["password"]=BCrypt::Password.create(password)

    #Maybe I can add another answer without read all answers
    json_users=users << my_user
    File.open("#{db}", 'w') {|file| file.write(JSON.generate(json_users))}
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
