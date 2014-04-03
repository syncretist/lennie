## GET ALL DB HITS IN METHODS HERE -- so they are not scattered through the code base
## doing the same thing with capybara in the 'tester.rb

class DatabaseQuery

  def self.get_admin_emails_with_access_to_organization(org_id)
    admins = []

    DB_CLIENT.query("SELECT scidea_users.email FROM scidea_role_users LEFT JOIN scidea_users ON scidea_role_users.user_id=scidea_users.id LEFT JOIN scidea_organization_role_users ON scidea_role_users.id=scidea_organization_role_users.role_user_id WHERE scidea_organization_role_users.organization_id = #{org_id}").each do |row|
      admins << row['email']
    end

    return admins
  end

  def self.get_user_by_id(user_id)
    DB_CLIENT.query("SELECT * FROM scidea_users where id=#{user_id}").each do |row|
      row
    end
  end

  def self.get_user_by_email(user_email)
    DB_CLIENT.query("SELECT * FROM scidea_users where email='#{user_email}'").each do |row|
      row
    end
  end

  def self.get_key_sample_per_org(*org_ids)
    #TODO allow for choices of different sample sizes based on input, 1/2, 1/4, etc...
    organization_samples = {}

    org_ids.each do |id|
      organization_samples[id] = { :raw_samples => [], :size => '', :subset_samples => [] }

      DB_CLIENT.query("SELECT scidea_keys.id, scidea_keys.activation_code, scidea_keys.learner_id, scidea_users.email, scidea_enrollments.id AS enrollment_id FROM scidea_keys LEFT JOIN scidea_users ON scidea_keys.learner_id=scidea_users.id LEFT JOIN scidea_enrollments ON scidea_keys.id=scidea_enrollments.key_id WHERE scidea_keys.consuming_organization_id=#{id}").each do |row|
        organization_samples[id][:raw_samples] << {:key_id => row['id'], :key_code => row['activation_code'], :learner_id => row['learner_id'], :learner_email => row['email'], :enrollment_id => row['enrollment_id']}
      end

      organization_samples[id][:size] = organization_samples[id][:raw_samples].size
      organization_samples[id][:subset_samples] = organization_samples[id][:raw_samples].sample( (organization_samples[id][:size] / 8).ceil )

    end

    return organization_samples
    # { <id> => {:raw_samples => [], :size => '', :subset_samples => []} }
  end

  def self.get_key_sample_per_org_with_test_string(*org_ids) # delete this method when converting final sco record test stuff
    #TODO allow for choices of different sample sizes based on input, 1/2, 1/4, etc...
    organization_samples = {}

    org_ids.each do |id|
      organization_samples[id] = { :raw_samples => [], :size => '', :subset_samples => [] }

      DB_CLIENT.query("SELECT scidea_keys.id, scidea_keys.activation_code, scidea_keys.learner_id, scidea_users.email, scidea_enrollments.id AS enrollment_id FROM scidea_keys LEFT JOIN scidea_users ON scidea_keys.learner_id=scidea_users.id LEFT JOIN scidea_enrollments ON scidea_keys.id=scidea_enrollments.key_id WHERE scidea_keys.consuming_organization_id=#{id}").each do |row|
        organization_samples[id][:raw_samples] << {:key_id => row['id'], :key_code => row['activation_code'], :learner_id => row['learner_id'], :learner_email => row['email'], :enrollment_id => row['enrollment_id'], :test_string => "TestRunner.new.sco_record_verification( :home_url => '#{SESSION_BASEURL}/', :admin_email => '#{get_admin_emails_with_access_to_organization(id).first}', :key_code => '#{row['activation_code']}')"}
      end

      organization_samples[id][:size] = organization_samples[id][:raw_samples].size
      organization_samples[id][:subset_samples] = organization_samples[id][:raw_samples].sample( (organization_samples[id][:size] / 8).ceil )

    end

    return organization_samples
    # { <id> => {:raw_samples => [], :size => '', :subset_samples => []} }
  end

end