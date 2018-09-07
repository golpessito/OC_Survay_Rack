require 'json'

class Answer

  attr_accessor :mail, :answers

  def self.dir_db
    env="_test" if ENV["test"]
    dir_db=File.dirname(__FILE__) + "/../db/answers#{env}.json"
  end

  def initialize(mail, answers)
    @mail=mail
    @answers=answers
  end

  def self.all
    begin
      db=dir_db
      json_answers=File.read("#{db}")
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
      db=dir_db
      my_answers={}
      my_answers["mail"]=mail
      my_answers["answers"]=answers

      #Maybe I can add another answer without read all answers
      json_answers=self.all << my_answers
      File.open("#{db}", 'w') {|file| file.write(JSON.generate(json_answers))}
      return true
    else
      return nil
    end
  end

end
