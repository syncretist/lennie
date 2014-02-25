class DestructiveDatabaseAccess
  # !! updates, deletes, etc.. should be wrapped here so mistakes are not made!!!, find ways to rollback by saving temp ?

  def self.create_course_record(user)
    # USE:
    # user = { :id => 3557681, :enrollment_id => 2226172 } OR { :id => DatabaseAccess.get_user_id_from_email(), :enrollment_id => DatabaseAccess.get_enrollment_id_from_user_id() }
    # DestructiveDatabaseAccess.create_course_record(user)

    #TODO add parameter flag of 'status' (default to incomplete), which allows you to choose status of created course... use string interpolation to drop status in query string

    remove_course_record(user) # wipe record first to make sure there are no duplicates

    DB_CLIENT.query("INSERT INTO scidea_course_records (course_id, status, created_at, updated_at, user_id, enrollment_id, settings, completed_at) VALUES ((select course_id from scidea_enrollments where id=#{user[:enrollment_id]}), 'in_progress', '#{database_datetime_now}', '#{database_datetime_now}', #{user[:id]}, #{user[:enrollment_id]}, NULL, NULL);")

    puts ""
    puts "User #{user[:id]} now has this course record for enrollment #{user[:enrollment_id]}:"
    puts ""
    DB_CLIENT.query("select * from scidea_course_records where user_id = #{user[:id]} and enrollment_id = #{user[:enrollment_id]};").each do |row|
      puts "course record id: #{row['id']}\n status: #{row['status']}\n"
    end
    puts ""

  end

  def self.remove_course_record(user)
    # USE:
    # user = { :id => 3557681, :enrollment_id => 2226172 } OR { :id => DatabaseAccess.get_user_id_from_email(), :enrollment_id => DatabaseAccess.get_enrollment_id_from_user_id() }
    # DestructiveDatabaseAccess.remove_course_record(user)

    DB_CLIENT.query("delete from scidea_course_records where user_id = #{user[:id]} and enrollment_id = #{user[:enrollment_id]};")

    puts ""
    puts "User #{user[:id]} now has the course record for enrollment #{user[:enrollment_id]} wiped, here is what is left (blank if correct):"
    puts ""
    DB_CLIENT.query("select * from scidea_course_records where user_id = #{user[:id]} and enrollment_id = #{user[:enrollment_id]};").each do |row|
      puts "course record id: #{row['id']}\n status: #{row['status']}\n"
    end
    puts ""
  end

  def self.create_all_course_sco_records(course_scos, user)
    # USE:
    # bls = [{:id => 31, :identifier_ref => 'AHA_901403_SCO_ID1_RES'}, {:id => 32, :identifier_ref => 'AHA_901403_SCO_ID2_RES'}, {:id => 42, :identifier_ref => 'AHA_901403_SCO_ID3_RES'}, {:id => 43, :identifier_ref => 'AHA_901403_SCO_ID4_RES'}, {:id => 44, :identifier_ref => 'AHA_901403_SCO_ID6_RES'}, {:id => 45, :identifier_ref => 'AHA_901403_SCO_ID7_RES'}, {:id => 46, :identifier_ref => 'AHA_901403_SCO_ID8_RES'}, {:id => 47, :identifier_ref => 'AHA_90_1403_SCO_ID9_RES'}, {:id => 48, :identifier_ref => 'AHA_901403_SCO_ID10_RES'}, {:id => 49, :identifier_ref => 'AHA_901403_SCO_ID11_RES'}, {:id => 50, :identifier_ref => 'AHA_901403_SCO_ID12_RES'}, {:id => 51, :identifier_ref => 'AHA_901403_SCO_ID13_RES'}, {:id => 52, :identifier_ref => 'AHA_901403_SCO_ID14_RES'}, {:id => 53, :identifier_ref => 'AHA_901403_SCO_ID15_RES'}, {:id => 54, :identifier_ref => 'AHA_901403_SCO_ID16_RES'}, {:id => 55, :identifier_ref => 'AHA_901403_SCO_ID17_RES'}, {:id => 56, :identifier_ref => 'AHA_901403_SCO_ID18_RES'}, {:id => 57, :identifier_ref => 'AHA_901403_SCO_ID19_RES'}, {:id => 58, :identifier_ref => 'AHA_901403_SCO_ID20_RES'}, {:id => 59, :identifier_ref => 'AHA_901403_SCO_ID21_RES'}, {:id => 62, :identifier_ref => 'AHA_901403_SCO_ID22_RES'}, {:id => 142, :identifier_ref => 'AHA_901403_SCO_ID5_RES'}]
    # user = { :id => 3557681, :enrollment_id => 2226172 } OR { :id => DatabaseAccess.get_user_id_from_email(), :enrollment_id => DatabaseAccess.get_enrollment_id_from_user_id() }
    # DestructiveDatabaseAccess.create_all_course_sco_records(bls, user)

    #TODO add parameter flag of 'status' (default to incomplete), which allows you to choose status of created scos in bulk or singly... use string interpolation to drop status in query string

    remove_all_course_sco_records(course_scos, user) # wipe records first to make sure there are no duplicates

    course_scos.each do |sco|
      DB_CLIENT.query("INSERT INTO scidea_sco_records (status, score, suspend_data, created_at, updated_at, lesson_location, last_session_time_sec, total_session_time_sec, sco_id, sco_identifier_ref, completed_at, user_id, enrollment_id, aicc_session_id, aicc_time, completed_by_shared) VALUES ('incomplete', NULL, NULL, '#{database_datetime_now}', '#{database_datetime_now}', NULL, '0', '0', #{sco[:id]}, '#{sco[:identifier_ref]}', NULL, #{user[:id]}, #{user[:enrollment_id]}, NULL, NULL, '0');")
    end

    puts ""
    puts "User #{user[:id]} now has these sco records for enrollment #{user[:enrollment_id]}:"
    puts ""
    DB_CLIENT.query("select * from scidea_sco_records where user_id = #{user[:id]} and enrollment_id = #{user[:enrollment_id]};").each do |row|
      puts "sco record id: #{row['id']}\n status: #{row['status']}\n sco id: #{row['sco_id']}\n"
    end
    puts ""

  end

  def self.create_all_course_sco_test_records(course_scos, user)
    # USE:
    # bls = [{:id => 31, :identifier_ref => 'AHA_901403_SCO_ID1_RES'}, {:id => 32, :identifier_ref => 'AHA_901403_SCO_ID2_RES'}, {:id => 42, :identifier_ref => 'AHA_901403_SCO_ID3_RES'}, {:id => 43, :identifier_ref => 'AHA_901403_SCO_ID4_RES'}, {:id => 44, :identifier_ref => 'AHA_901403_SCO_ID6_RES'}, {:id => 45, :identifier_ref => 'AHA_901403_SCO_ID7_RES'}, {:id => 46, :identifier_ref => 'AHA_901403_SCO_ID8_RES'}, {:id => 47, :identifier_ref => 'AHA_90_1403_SCO_ID9_RES'}, {:id => 48, :identifier_ref => 'AHA_901403_SCO_ID10_RES'}, {:id => 49, :identifier_ref => 'AHA_901403_SCO_ID11_RES'}, {:id => 50, :identifier_ref => 'AHA_901403_SCO_ID12_RES'}, {:id => 51, :identifier_ref => 'AHA_901403_SCO_ID13_RES'}, {:id => 52, :identifier_ref => 'AHA_901403_SCO_ID14_RES'}, {:id => 53, :identifier_ref => 'AHA_901403_SCO_ID15_RES'}, {:id => 54, :identifier_ref => 'AHA_901403_SCO_ID16_RES'}, {:id => 55, :identifier_ref => 'AHA_901403_SCO_ID17_RES'}, {:id => 56, :identifier_ref => 'AHA_901403_SCO_ID18_RES'}, {:id => 57, :identifier_ref => 'AHA_901403_SCO_ID19_RES'}, {:id => 58, :identifier_ref => 'AHA_901403_SCO_ID20_RES'}, {:id => 59, :identifier_ref => 'AHA_901403_SCO_ID21_RES'}, {:id => 62, :identifier_ref => 'AHA_901403_SCO_ID22_RES'}, {:id => 142, :identifier_ref => 'AHA_901403_SCO_ID5_RES'}]
    # user = { :id => 3557681, :enrollment_id => 2226172 } OR { :id => DatabaseAccess.get_user_id_from_email(), :enrollment_id => DatabaseAccess.get_enrollment_id_from_user_id() }
    # DestructiveDatabaseAccess.create_all_course_sco_records(bls, user)

    #TODO add parameter flag of 'status' (default to incomplete), which allows you to choose status of created scos in bulk or singly... use string interpolation to drop status in query string

    remove_all_course_sco_test_records(course_scos, user) # wipe records first to make sure there are no duplicates

    DB_CLIENT.query("INSERT INTO scidea_sco_records (status, score, suspend_data, created_at, updated_at, lesson_location, last_session_time_sec, total_session_time_sec, sco_id, sco_identifier_ref, completed_at, user_id, enrollment_id, aicc_session_id, aicc_time, completed_by_shared) VALUES ('not attempted', NULL, NULL, '#{database_datetime_now}', '#{database_datetime_now}', NULL, '0', '0', 61, 'AHA_901403_SCO_ID23_RES', NULL, #{user[:id]}, #{user[:enrollment_id]}, NULL, NULL, '0');")
    DB_CLIENT.query("INSERT INTO scidea_sco_records (status, score, suspend_data, created_at, updated_at, lesson_location, last_session_time_sec, total_session_time_sec, sco_id, sco_identifier_ref, completed_at, user_id, enrollment_id, aicc_session_id, aicc_time, completed_by_shared) VALUES ('not attempted', NULL, NULL, '#{database_datetime_now}', '#{database_datetime_now}', NULL, '0', '0', 60, 'AHA_901403_SCO_ID24_RES', NULL, #{user[:id]}, #{user[:enrollment_id]}, NULL, NULL, '0');")

    puts ""
    puts "User #{user[:id]} now has these sco test records for enrollment #{user[:enrollment_id]}:"
    puts ""
    #DB_CLIENT.query("select * from scidea_sco_records where user_id = #{user[:id]} and enrollment_id = #{user[:enrollment_id]} and sco_id=61 or sco_id=60;").each do |row|
    #  puts "sco record id: #{row['id']}\n status: #{row['status']}\n sco id: #{row['sco_id']}\n"
    #end
    puts ""

  end

  def self.remove_all_course_sco_records(course_scos, user)
    # USE:
    # bls = [{:id => 31, :identifier_ref => 'AHA_901403_SCO_ID1_RES'}, {:id => 32, :identifier_ref => 'AHA_901403_SCO_ID2_RES'}, {:id => 42, :identifier_ref => 'AHA_901403_SCO_ID3_RES'}, {:id => 43, :identifier_ref => 'AHA_901403_SCO_ID4_RES'}, {:id => 44, :identifier_ref => 'AHA_901403_SCO_ID6_RES'}, {:id => 45, :identifier_ref => 'AHA_901403_SCO_ID7_RES'}, {:id => 46, :identifier_ref => 'AHA_901403_SCO_ID8_RES'}, {:id => 47, :identifier_ref => 'AHA_90_1403_SCO_ID9_RES'}, {:id => 48, :identifier_ref => 'AHA_901403_SCO_ID10_RES'}, {:id => 49, :identifier_ref => 'AHA_901403_SCO_ID11_RES'}, {:id => 50, :identifier_ref => 'AHA_901403_SCO_ID12_RES'}, {:id => 51, :identifier_ref => 'AHA_901403_SCO_ID13_RES'}, {:id => 52, :identifier_ref => 'AHA_901403_SCO_ID14_RES'}, {:id => 53, :identifier_ref => 'AHA_901403_SCO_ID15_RES'}, {:id => 54, :identifier_ref => 'AHA_901403_SCO_ID16_RES'}, {:id => 55, :identifier_ref => 'AHA_901403_SCO_ID17_RES'}, {:id => 56, :identifier_ref => 'AHA_901403_SCO_ID18_RES'}, {:id => 57, :identifier_ref => 'AHA_901403_SCO_ID19_RES'}, {:id => 58, :identifier_ref => 'AHA_901403_SCO_ID20_RES'}, {:id => 59, :identifier_ref => 'AHA_901403_SCO_ID21_RES'}, {:id => 62, :identifier_ref => 'AHA_901403_SCO_ID22_RES'}, {:id => 142, :identifier_ref => 'AHA_901403_SCO_ID5_RES'}]
    # user = { :id => 3557681, :enrollment_id => 2226172 } OR { :id => DatabaseAccess.get_user_id_from_email(), :enrollment_id => DatabaseAccess.get_enrollment_id_from_user_id() }
    # DestructiveDatabaseAccess.remove_all_course_sco_records(bls, user)

    course_scos.each do |sco|
      DB_CLIENT.query("delete from scidea_sco_records where user_id = #{user[:id]} and enrollment_id = #{user[:enrollment_id]} and sco_id=#{sco[:id]};")
    end

    puts ""
    puts "User #{user[:id]} now has these sco records for enrollment #{user[:enrollment_id]} wiped, here is what is left (blank if correct):"
    puts ""
    DB_CLIENT.query("select * from scidea_sco_records where user_id = #{user[:id]} and enrollment_id = #{user[:enrollment_id]};").each do |row|
      puts "sco record id: #{row['id']}\n status: #{row['status']}\n sco id: #{row['sco_id']}\n"
    end
    puts ""

  end

  def self.remove_all_course_sco_test_records(course_scos, user)
    # USE:
    # bls = [{:id => 31, :identifier_ref => 'AHA_901403_SCO_ID1_RES'}, {:id => 32, :identifier_ref => 'AHA_901403_SCO_ID2_RES'}, {:id => 42, :identifier_ref => 'AHA_901403_SCO_ID3_RES'}, {:id => 43, :identifier_ref => 'AHA_901403_SCO_ID4_RES'}, {:id => 44, :identifier_ref => 'AHA_901403_SCO_ID6_RES'}, {:id => 45, :identifier_ref => 'AHA_901403_SCO_ID7_RES'}, {:id => 46, :identifier_ref => 'AHA_901403_SCO_ID8_RES'}, {:id => 47, :identifier_ref => 'AHA_90_1403_SCO_ID9_RES'}, {:id => 48, :identifier_ref => 'AHA_901403_SCO_ID10_RES'}, {:id => 49, :identifier_ref => 'AHA_901403_SCO_ID11_RES'}, {:id => 50, :identifier_ref => 'AHA_901403_SCO_ID12_RES'}, {:id => 51, :identifier_ref => 'AHA_901403_SCO_ID13_RES'}, {:id => 52, :identifier_ref => 'AHA_901403_SCO_ID14_RES'}, {:id => 53, :identifier_ref => 'AHA_901403_SCO_ID15_RES'}, {:id => 54, :identifier_ref => 'AHA_901403_SCO_ID16_RES'}, {:id => 55, :identifier_ref => 'AHA_901403_SCO_ID17_RES'}, {:id => 56, :identifier_ref => 'AHA_901403_SCO_ID18_RES'}, {:id => 57, :identifier_ref => 'AHA_901403_SCO_ID19_RES'}, {:id => 58, :identifier_ref => 'AHA_901403_SCO_ID20_RES'}, {:id => 59, :identifier_ref => 'AHA_901403_SCO_ID21_RES'}, {:id => 62, :identifier_ref => 'AHA_901403_SCO_ID22_RES'}, {:id => 142, :identifier_ref => 'AHA_901403_SCO_ID5_RES'}]
    # user = { :id => 3557681, :enrollment_id => 2226172 } OR { :id => DatabaseAccess.get_user_id_from_email(), :enrollment_id => DatabaseAccess.get_enrollment_id_from_user_id() }
    # DestructiveDatabaseAccess.remove_all_course_sco_records(bls, user)

    DB_CLIENT.query("delete from scidea_sco_records where user_id = #{user[:id]} and enrollment_id = #{user[:enrollment_id]} and sco_id=61;")
    DB_CLIENT.query("delete from scidea_sco_records where user_id = #{user[:id]} and enrollment_id = #{user[:enrollment_id]} and sco_id=60;")

    puts ""
    puts "User #{user[:id]} now has these test sco records for enrollment #{user[:enrollment_id]} wiped, here is what is left (blank if correct):"
    puts ""
    #DB_CLIENT.query("select * from scidea_sco_records where user_id = #{user[:id]} and enrollment_id = #{user[:enrollment_id]} and sco_id=60 or sco_id=61;").each do |row|
    #  puts "sco record id: #{row['id']}\n status: #{row['status']}\n sco id: #{row['sco_id']}\n"
    #end
    puts ""

  end

  def self.set_all_course_sco_records(course_scos, user, status)
    # USE:
    # bls = [{:id => 31, :identifier_ref => 'AHA_901403_SCO_ID1_RES'}, {:id => 32, :identifier_ref => 'AHA_901403_SCO_ID2_RES'}, {:id => 42, :identifier_ref => 'AHA_901403_SCO_ID3_RES'}, {:id => 43, :identifier_ref => 'AHA_901403_SCO_ID4_RES'}, {:id => 44, :identifier_ref => 'AHA_901403_SCO_ID6_RES'}, {:id => 45, :identifier_ref => 'AHA_901403_SCO_ID7_RES'}, {:id => 46, :identifier_ref => 'AHA_901403_SCO_ID8_RES'}, {:id => 47, :identifier_ref => 'AHA_90_1403_SCO_ID9_RES'}, {:id => 48, :identifier_ref => 'AHA_901403_SCO_ID10_RES'}, {:id => 49, :identifier_ref => 'AHA_901403_SCO_ID11_RES'}, {:id => 50, :identifier_ref => 'AHA_901403_SCO_ID12_RES'}, {:id => 51, :identifier_ref => 'AHA_901403_SCO_ID13_RES'}, {:id => 52, :identifier_ref => 'AHA_901403_SCO_ID14_RES'}, {:id => 53, :identifier_ref => 'AHA_901403_SCO_ID15_RES'}, {:id => 54, :identifier_ref => 'AHA_901403_SCO_ID16_RES'}, {:id => 55, :identifier_ref => 'AHA_901403_SCO_ID17_RES'}, {:id => 56, :identifier_ref => 'AHA_901403_SCO_ID18_RES'}, {:id => 57, :identifier_ref => 'AHA_901403_SCO_ID19_RES'}, {:id => 58, :identifier_ref => 'AHA_901403_SCO_ID20_RES'}, {:id => 59, :identifier_ref => 'AHA_901403_SCO_ID21_RES'}, {:id => 62, :identifier_ref => 'AHA_901403_SCO_ID22_RES'}, {:id => 142, :identifier_ref => 'AHA_901403_SCO_ID5_RES'}]
    # user = { :id => 3557681, :enrollment_id => 2226172 } OR { :id => DatabaseAccess.get_user_id_from_email(), :enrollment_id => DatabaseAccess.get_enrollment_id_from_user_id() }
    # DestructiveDatabaseAccess.set_all_course_sco_records(bls, user, 'completed')

    course_scos.each do |sco|
      DB_CLIENT.query("update scidea_sco_records set status='#{status}' where user_id = #{user[:id]} and enrollment_id = #{user[:enrollment_id]} and sco_id=#{sco[:id]};")
    end

    puts ""
    puts "User #{user[:id]} now has these sco records for enrollment #{user[:enrollment_id]} with status set to #{status}, here is the outcome:"
    puts ""
    DB_CLIENT.query("select * from scidea_sco_records where user_id = #{user[:id]} and enrollment_id = #{user[:enrollment_id]};").each do |row|
      puts "sco record id: #{row['id']}\n status: #{row['status']}\n sco id: #{row['sco_id']}\n"
    end
    puts ""

  end

  def self.set_all_course_test_sco_records(course_scos, user, status)
    # USE:
    # bls = [{:id => 31, :identifier_ref => 'AHA_901403_SCO_ID1_RES'}, {:id => 32, :identifier_ref => 'AHA_901403_SCO_ID2_RES'}, {:id => 42, :identifier_ref => 'AHA_901403_SCO_ID3_RES'}, {:id => 43, :identifier_ref => 'AHA_901403_SCO_ID4_RES'}, {:id => 44, :identifier_ref => 'AHA_901403_SCO_ID6_RES'}, {:id => 45, :identifier_ref => 'AHA_901403_SCO_ID7_RES'}, {:id => 46, :identifier_ref => 'AHA_901403_SCO_ID8_RES'}, {:id => 47, :identifier_ref => 'AHA_90_1403_SCO_ID9_RES'}, {:id => 48, :identifier_ref => 'AHA_901403_SCO_ID10_RES'}, {:id => 49, :identifier_ref => 'AHA_901403_SCO_ID11_RES'}, {:id => 50, :identifier_ref => 'AHA_901403_SCO_ID12_RES'}, {:id => 51, :identifier_ref => 'AHA_901403_SCO_ID13_RES'}, {:id => 52, :identifier_ref => 'AHA_901403_SCO_ID14_RES'}, {:id => 53, :identifier_ref => 'AHA_901403_SCO_ID15_RES'}, {:id => 54, :identifier_ref => 'AHA_901403_SCO_ID16_RES'}, {:id => 55, :identifier_ref => 'AHA_901403_SCO_ID17_RES'}, {:id => 56, :identifier_ref => 'AHA_901403_SCO_ID18_RES'}, {:id => 57, :identifier_ref => 'AHA_901403_SCO_ID19_RES'}, {:id => 58, :identifier_ref => 'AHA_901403_SCO_ID20_RES'}, {:id => 59, :identifier_ref => 'AHA_901403_SCO_ID21_RES'}, {:id => 62, :identifier_ref => 'AHA_901403_SCO_ID22_RES'}, {:id => 142, :identifier_ref => 'AHA_901403_SCO_ID5_RES'}]
    # user = { :id => 3557681, :enrollment_id => 2226172 } OR { :id => DatabaseAccess.get_user_id_from_email(), :enrollment_id => DatabaseAccess.get_enrollment_id_from_user_id() }
    # DestructiveDatabaseAccess.set_all_course_sco_records(bls, user, 'completed')

    DB_CLIENT.query("update scidea_sco_records set status='#{status}' where user_id = #{user[:id]} and enrollment_id = #{user[:enrollment_id]} and sco_id=61;")

    puts ""
    puts "User #{user[:id]} now has this test sco record for enrollment #{user[:enrollment_id]} with status set to #{status}, here is the outcome:"
    puts ""
    #DB_CLIENT.query("select * from scidea_sco_records where user_id = #{user[:id]} and enrollment_id = #{user[:enrollment_id]} and sco_id=61;").each do |row|
    #  puts "sco record id: #{row['id']}\n status: #{row['status']}\n sco id: #{row['sco_id']}\n"
    #end
    puts ""

  end

  def self.remove_course_evaluation_records(course_scos, user)
    # USE:
    # bls = [{:id => 31, :identifier_ref => 'AHA_901403_SCO_ID1_RES'}, {:id => 32, :identifier_ref => 'AHA_901403_SCO_ID2_RES'}, {:id => 42, :identifier_ref => 'AHA_901403_SCO_ID3_RES'}, {:id => 43, :identifier_ref => 'AHA_901403_SCO_ID4_RES'}, {:id => 44, :identifier_ref => 'AHA_901403_SCO_ID6_RES'}, {:id => 45, :identifier_ref => 'AHA_901403_SCO_ID7_RES'}, {:id => 46, :identifier_ref => 'AHA_901403_SCO_ID8_RES'}, {:id => 47, :identifier_ref => 'AHA_90_1403_SCO_ID9_RES'}, {:id => 48, :identifier_ref => 'AHA_901403_SCO_ID10_RES'}, {:id => 49, :identifier_ref => 'AHA_901403_SCO_ID11_RES'}, {:id => 50, :identifier_ref => 'AHA_901403_SCO_ID12_RES'}, {:id => 51, :identifier_ref => 'AHA_901403_SCO_ID13_RES'}, {:id => 52, :identifier_ref => 'AHA_901403_SCO_ID14_RES'}, {:id => 53, :identifier_ref => 'AHA_901403_SCO_ID15_RES'}, {:id => 54, :identifier_ref => 'AHA_901403_SCO_ID16_RES'}, {:id => 55, :identifier_ref => 'AHA_901403_SCO_ID17_RES'}, {:id => 56, :identifier_ref => 'AHA_901403_SCO_ID18_RES'}, {:id => 57, :identifier_ref => 'AHA_901403_SCO_ID19_RES'}, {:id => 58, :identifier_ref => 'AHA_901403_SCO_ID20_RES'}, {:id => 59, :identifier_ref => 'AHA_901403_SCO_ID21_RES'}, {:id => 62, :identifier_ref => 'AHA_901403_SCO_ID22_RES'}, {:id => 142, :identifier_ref => 'AHA_901403_SCO_ID5_RES'}]
    # user = { :id => 3557681, :enrollment_id => 2226172 } OR { :id => DatabaseAccess.get_user_id_from_email(), :enrollment_id => DatabaseAccess.get_enrollment_id_from_user_id() }
    # DestructiveDatabaseAccess.set_all_course_sco_records(bls, user, 'completed')

    DB_CLIENT.query("delete from course_survey_records where user_id = #{user[:id]};")
    DB_CLIENT.query("delete from scidea_form_responses where user_id = #{user[:id]} and form_id=4;")
    #TODO REMOVE scidea_form_response_values that associate with the form response id found at last step, and zero in on course in last step to not remove evals for other courses!

    puts ""
    puts "User #{user[:id]} now has no course survey records or survey form data, here is the outcome:"
    puts ""
    #DB_CLIENT.query("select * from scidea_sco_records where user_id = #{user[:id]} and enrollment_id = #{user[:enrollment_id]} and sco_id=61;").each do |row|
    #  puts "sco record id: #{row['id']}\n status: #{row['status']}\n sco id: #{row['sco_id']}\n"
    #end
    puts ""

  end

  def self.remove_course_completion_certificate_records(course_scos, user)
    # USE:
    # bls = [{:id => 31, :identifier_ref => 'AHA_901403_SCO_ID1_RES'}, {:id => 32, :identifier_ref => 'AHA_901403_SCO_ID2_RES'}, {:id => 42, :identifier_ref => 'AHA_901403_SCO_ID3_RES'}, {:id => 43, :identifier_ref => 'AHA_901403_SCO_ID4_RES'}, {:id => 44, :identifier_ref => 'AHA_901403_SCO_ID6_RES'}, {:id => 45, :identifier_ref => 'AHA_901403_SCO_ID7_RES'}, {:id => 46, :identifier_ref => 'AHA_901403_SCO_ID8_RES'}, {:id => 47, :identifier_ref => 'AHA_90_1403_SCO_ID9_RES'}, {:id => 48, :identifier_ref => 'AHA_901403_SCO_ID10_RES'}, {:id => 49, :identifier_ref => 'AHA_901403_SCO_ID11_RES'}, {:id => 50, :identifier_ref => 'AHA_901403_SCO_ID12_RES'}, {:id => 51, :identifier_ref => 'AHA_901403_SCO_ID13_RES'}, {:id => 52, :identifier_ref => 'AHA_901403_SCO_ID14_RES'}, {:id => 53, :identifier_ref => 'AHA_901403_SCO_ID15_RES'}, {:id => 54, :identifier_ref => 'AHA_901403_SCO_ID16_RES'}, {:id => 55, :identifier_ref => 'AHA_901403_SCO_ID17_RES'}, {:id => 56, :identifier_ref => 'AHA_901403_SCO_ID18_RES'}, {:id => 57, :identifier_ref => 'AHA_901403_SCO_ID19_RES'}, {:id => 58, :identifier_ref => 'AHA_901403_SCO_ID20_RES'}, {:id => 59, :identifier_ref => 'AHA_901403_SCO_ID21_RES'}, {:id => 62, :identifier_ref => 'AHA_901403_SCO_ID22_RES'}, {:id => 142, :identifier_ref => 'AHA_901403_SCO_ID5_RES'}]
    # user = { :id => 3557681, :enrollment_id => 2226172 } OR { :id => DatabaseAccess.get_user_id_from_email(), :enrollment_id => DatabaseAccess.get_enrollment_id_from_user_id() }
    # DestructiveDatabaseAccess.set_all_course_sco_records(bls, user, 'completed')

    DB_CLIENT.query("delete from scidea_course_completion_certificates where user_id = #{user[:id]};")

    puts ""
    puts "User #{user[:id]} now has no course completion certificate records, here is the outcome:"
    puts ""
    #DB_CLIENT.query("select * from scidea_sco_records where user_id = #{user[:id]} and enrollment_id = #{user[:enrollment_id]} and sco_id=61;").each do |row|
    #  puts "sco record id: #{row['id']}\n status: #{row['status']}\n sco id: #{row['sco_id']}\n"
    #end
    puts ""

  end
end
