class DatabaseTestRunner

  def data_test_prep(*org_ids)
    Tach.meter do
      tach('data_test_prep') do
        puts ""
        DatabaseAccess.display_org_information(*org_ids)
        DatabaseAccess.display_admins_with_org_access(*org_ids)
        DatabaseAccess.org_keycount_tests :display, *org_ids  # :display to show test strings, :run to run the tests
        #DatabaseAccess.org_scorecord_tests :display, *org_ids # :display to show test strings, :run to run the tests
        DatabaseAccess.all_org_key_users_exist?(*org_ids)
        DatabaseAccess.doubled_groups?(*org_ids)
      end
    end
    return nil #clean final return
  end

  def complete_course_for_user
    #TODO get rid of info below and use the OBJECTS themselves passed in as parameters to choose, based on object flags (test exist, unlimited, etc...)

    user = { :id => 3570093, :enrollment_id => 2770139 }
    bls = [{:id => 31, :identifier_ref => 'AHA_901403_SCO_ID1_RES'}, {:id => 32, :identifier_ref => 'AHA_901403_SCO_ID2_RES'}, {:id => 42, :identifier_ref => 'AHA_901403_SCO_ID3_RES'}, {:id => 43, :identifier_ref => 'AHA_901403_SCO_ID4_RES'}, {:id => 44, :identifier_ref => 'AHA_901403_SCO_ID6_RES'}, {:id => 45, :identifier_ref => 'AHA_901403_SCO_ID7_RES'}, {:id => 46, :identifier_ref => 'AHA_901403_SCO_ID8_RES'}, {:id => 47, :identifier_ref => 'AHA_90_1403_SCO_ID9_RES'}, {:id => 48, :identifier_ref => 'AHA_901403_SCO_ID10_RES'}, {:id => 49, :identifier_ref => 'AHA_901403_SCO_ID11_RES'}, {:id => 50, :identifier_ref => 'AHA_901403_SCO_ID12_RES'}, {:id => 51, :identifier_ref => 'AHA_901403_SCO_ID13_RES'}, {:id => 52, :identifier_ref => 'AHA_901403_SCO_ID14_RES'}, {:id => 53, :identifier_ref => 'AHA_901403_SCO_ID15_RES'}, {:id => 54, :identifier_ref => 'AHA_901403_SCO_ID16_RES'}, {:id => 55, :identifier_ref => 'AHA_901403_SCO_ID17_RES'}, {:id => 56, :identifier_ref => 'AHA_901403_SCO_ID18_RES'}, {:id => 57, :identifier_ref => 'AHA_901403_SCO_ID19_RES'}, {:id => 58, :identifier_ref => 'AHA_901403_SCO_ID20_RES'}, {:id => 59, :identifier_ref => 'AHA_901403_SCO_ID21_RES'}, {:id => 62, :identifier_ref => 'AHA_901403_SCO_ID22_RES'}, {:id => 142, :identifier_ref => 'AHA_901403_SCO_ID5_RES'}]

    Tach.meter do
      tach('complete_course_for_user') do

        # create course record if it does not exist based on user|key|enrollment
        DestructiveDatabaseAccess.create_course_record(user)

        # create sco records if they do not exist for the course
        DestructiveDatabaseAccess.create_all_course_sco_records(bls, user)

        # pass all scos and tests
        DestructiveDatabaseAccess.set_all_course_sco_records(bls, user, 'completed') # completed, in_progress
        DestructiveDatabaseAccess.create_all_course_sco_test_records(bls, user)
        DestructiveDatabaseAccess.set_all_course_test_sco_records(bls, user, 'passed') # 'passed', 'failed', 'not attempted'

        # remove course eval records and form records for user (eventually zero in on specific course)
        DestructiveDatabaseAccess.remove_course_evaluation_records(bls, user)

        # remove certificate records
        DestructiveDatabaseAccess.remove_course_completion_certificate_records(bls, user)

        # verify all elements exist: certificate, survey record, form and form values for survey, sco records completed, courses completed

      end
    end
    return nil #clean final return
  end

  def reset_course_for_user

  end
end