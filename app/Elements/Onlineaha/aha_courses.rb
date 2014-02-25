# encoding: utf-8
# Need to change encoding to handle '®', '✔', '✘'
# http://stackoverflow.com/questions/1739836/invalid-multibyte-char-us-ascii-with-rails-and-ruby-1-9
# http://stackoverflow.com/questions/3678172/ruby-1-9-invalid-multibyte-char-us-ascii
# http://www.stefanwille.com/2010/08/ruby-on-rails-fix-for-invalid-multibyte-char-us-ascii/

class AhaCourses
  @@courses = {
            # add enumerated possible completion statuses for course and for sco
            # add elements for special cases, like single sco shares completion between tests, :unlimited_try test, etc...

            "80-1055" => { :course_title_raw=>"BLS for Healthcare Providers Online part 1",
                           :course_title => "BLS for Healthcare Providers Online part 1",
                           :course_type=> :internal,
                           :completion_criteria => [] },
            "80-1095" => { :course_title_raw=>"Heartsaver® First Aid Online part 1",
                           :course_title =>"Heartsaver First Aid Online part 1",
                           :course_type=> :internal,
                           :completion_criteria => [] },
            "80-1461" => { :course_title_raw=>"Heartsaver® First Aid Online With CPR & AED part 1",
                           :course_title=>"Heartsaver First Aid Online With CPR & AED part 1",
                           :alternate_title => "Heartsaver First Aid Online With CPR and AED part 1 80 1461",
                           :course_type=> :internal,
                           :completion_criteria => [] },
            "80-1468" => { :course_title_raw=>"Stroke: Prehospital Care Online",
                           :course_title=>"Stroke Prehospital Care Online",
                           :course_type=> :internal,
                           :completion_criteria => [] },
            "80-1469" => { :course_title_raw=>"", :course_title=>"",         :course_type=> :internal, :completion_criteria => [] },
            "80-1471" => { :course_title_raw=>"", :course_title=>"",         :course_type=> :internal, :completion_criteria => [] },
            "80-1473" => { :course_title_raw=>"Learn:® Rapid STEMI ID",
                           :course_title=>"Learn Rapid STEMI ID",
                           :course_type=> :internal,
                           :completion_criteria => [] },
            "80-1474" => { :course_title_raw=>"", :course_title=>"",         :course_type=> :internal, :completion_criteria => [] },
            "80-1480" => { :course_title_raw=>"Acute Stroke Online",
                           :course_title=>"Acute Stroke Online",
                           :course_type=> :internal,
                           :completion_criteria => [] },
            "80-1494" => { :course_title_raw=>"", :course_title=>"",         :course_type=> :internal, :completion_criteria => [] },
            "80-1501" => { :course_title_raw=>"Heartsaver Bloodborne Pathogens",
                           :course_title=>"Heartsaver Bloodborne Pathogens",
                           :course_type=> :internal,
                           :completion_criteria => [] },
            "80-1516" => { :course_title_raw=>"HeartCode™ ACLS Part 1",
                           :course_title=>"HeartCode ACLS Part 1",
                           :course_type=> :external,
                           :completion_criteria => [] },
            "80-1531" => { :course_title_raw=>"", :course_title=>"",         :course_type=> :internal, :completion_criteria => [] },
            "90-1083" => { :course_title_raw=>"", :course_title=>"",         :course_type=> :internal, :completion_criteria => [] },
            "90-1400" => { :course_title_raw=>"Heartsaver® First Aid Online Part 1", :course_title=>"Heartsaver First Aid Online Part 1",         :course_type=> :internal, :completion_criteria => [] },
            "90-1401" => { :course_title_raw=>"Heartsaver® First Aid CPR AED Online Part 1", :course_title=>"Heartsaver First Aid CPR AED Online Part 1", :course_type=> :internal, :completion_criteria => [] },
            "90-1402" => { :course_title_raw=>"Heartsaver® CPR AED Online Part 1", :course_title=>"Heartsaver CPR AED Online Part 1",           :course_type=> :internal, :completion_criteria => [] },
            "90-1403" => { :course_title_raw=>"BLS for Healthcare Providers Online part 1", :course_title=>"BLS for Healthcare Providers Online part 1",  :course_type=> :external, :completion_criteria => [:test, :eval] },
            "90-1404" => { :course_title_raw=>"", :course_title=> "",         :course_type=> :internal, :completion_criteria => [] },
            "90-1405" => { :course_title_raw=>"HeartCode® ACLS Part 1", :course_title=>"HeartCode ACLS Part 1",                      :course_type=> :external, :completion_criteria => [:aicc_record] },
            "90-1415" => { :course_title_raw=>"", :course_title=> "",         :course_type=> :internal, :completion_criteria => [] },
            "90-1420" => { :course_title_raw=>"HeartCode® PALS Part 1", :course_title=>"HeartCode PALS Part 1",                      :course_type=> :external, :completion_criteria => [:aicc_record] },
            "90-1421" => { :course_title_raw=>"Learn:® Rhythm Adult", :course_title=>"Learn: Rhythm Adult",                        :course_type=> :external, :completion_criteria => [:aicc_record] },
            "90-1423" => { :course_title_raw=>"", :course_title=> "",         :course_type=> :internal, :completion_criteria => [] },
            "90-1425" => { :course_title_raw=>"Acute Stroke Online", :course_title=>"Acute Stroke Online",                         :course_type=> :internal, :completion_criteria => [] },
            "90-1428" => { :course_title_raw=>"", :course_title=> "",        :course_type=> :internal, :completion_criteria => [] },
            "90-1429" => { :course_title_raw=>"BLS Instructor Essentials", :course_title=>"BLS Instructor Essentials",                   :course_type=> :internal, :completion_criteria => [] },
            "90-1430" => { :course_title_raw=>"PALS Instructor Essentials", :course_title=>"PALS Instructor Essentials",                  :course_type=> :internal, :completion_criteria => [] },
            "90-1431" => { :course_title_raw=>"Heartsaver® Instructor Essentials", :course_title=>"Heartsaver Instructor Essentials",           :course_type=> :internal, :completion_criteria => [] },
            "90-1432" => { :course_title_raw=>"ACLS Instructor Essentials", :course_title=>"ACLS Instructor Essentials",                  :course_type=> :internal, :completion_criteria => [] }
        }

  def self.get_course_name_by_course_id(course_id)
    @@courses.each do |id, course_information|
      result = ''

      if course_id == id
        return course_information[:course_title]
      end
    end
    #TODO catch an id missing from list, return ''
  end
end