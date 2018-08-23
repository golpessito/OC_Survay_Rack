require 'json'

class Answer

  attr_accessor :mail, :answers

  def initialize(mail, answers)
    @mail=mail
    @answers=answers
  end

  def self.all
    begin
      ## I have to use __FILE__
      json_answers=File.read("db/answers.json")
      return JSON.parse(json_answers)
    rescue
      #Check this because if is the answers.json is ba we will be reset
      #the file
      return []
    end
  end

  def self.show_all
    puts all
  end

  def self.exists?(mail)
    exist=false
    all.each do |answers|
      #We can improve with return
      return exist=true if answers['mail'] == mail
    end
    return exist
  end

  def self.find(mail)
    all.each do |answers|
      #We can improve with return
      return self.new(answers['mail'],answers['answers']) if answers['mail'] == mail
    end
    return nil
  end

  def self.create(mail,answers)
    unless self.exists?(mail)
      my_answers={}
      my_answers["mail"]=mail
      my_answers["answers"]=answers

      #Maybe I can add another answer without read all answers
      json_answers=self.all << my_answers
      File.open('db/answers.json', 'w') {|file| file.write(JSON.generate(json_answers))}
      return true
    else
      puts "This mail has already used"
      return nil
    end
  end

end
