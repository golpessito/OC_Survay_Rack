require 'test/unit'
require_relative '../models/answers'

class UserTest < Test::Unit::TestCase

  class << self
    def startup
      ENV["test"]="test"
      @@answers=Answer.all
    end
  end

  def test_load_answers
     assert_equal(@@answers[0]["mail"],"david.ruizdelarosa@gmail.com")
     assert_equal(@@answers[0]["answers"]["age"],"23")
     assert_equal(@@answers[0]["answers"]["gender"],"male")
     assert_equal(@@answers[0]["answers"]["smoke"],"yes")
     assert_equal(@@answers[0]["answers"]["alcohol"],"on_weekend")
     assert_equal(@@answers[0]["answers"]["hour_of_sport"],"more_of_3")
     assert_equal(@@answers[0]["answers"]["litre_per_day"],"3")
  end

  def test_load_not_permit_same_email
     mail="david.ruizdelarosa@gmail.com"
     answer_create=Answer.create(mail,"")
     assert_nil(answer_create)
  end

  def test_find_answer_by_email
     mail="david.ruizdelarosa@gmail.com"
     answer=Answer.find(mail)
     assert_equal(mail,answer.mail)
  end

end
