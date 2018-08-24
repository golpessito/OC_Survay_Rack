require 'json'
require 'bcrypt'

data = [{"user_name" => "Administrator", "password" => ""}]

my_password = BCrypt::Password.create("secret")
#=> "$2a$10$vI8aWBnW3fID.ZQ4/zo1G.q1lRps.9cGLcZEiGDMVr5yUP1KUOYTa"

data[0]["password"]=my_password
json_password=JSON.generate(data)
File.open('users.json','w') { |file| file.write(json_password)}

#
#
# my_password.version              #=> "2a"
# my_password.cost                 #=> 10
# my_password == "secret"     #=> true
# my_password == "not my password" #=> false
#
my_password = BCrypt::Password.new("$2a$10$vI8aWBnW3fID.ZQ4/zo1G.q1lRps.9cGLcZEiGDMVr5yUP1KUOYTa")
my_password == "my password"     #=> true
my_password == "not my password" #=> false
