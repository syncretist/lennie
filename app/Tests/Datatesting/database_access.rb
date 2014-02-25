# encoding: utf-8
# Need to change encoding to handle '®', '✔', '✘'
# http://stackoverflow.com/questions/1739836/invalid-multibyte-char-us-ascii-with-rails-and-ruby-1-9
# http://stackoverflow.com/questions/3678172/ruby-1-9-invalid-multibyte-char-us-ascii
# http://www.stefanwille.com/2010/08/ruby-on-rails-fix-for-invalid-multibyte-char-us-ascii/

class DatabaseAccess

  def self.get_enrollment_id_from_user

  end

  def self.get_user_id_from_email

  end

  def self.get_key_sample_per_org(*org_ids)
    #TODO allow for choices of different sample sizes based on input, 1/2, 1/4, etc...
    organization_samples = {}

    puts ""
    puts "Preparing key sample, this could take quite a while, please be patient while data is collected...".light_blue
    puts ""
    puts "                                     "+ "――" + "――" + "――" + "――" + "――" + "――" + "――" + "――" + "――"
    puts "          " + "――――――" + "――".blink + "――" + "―――".blink + "――" + "―".blink + "✈         "+ "【".light_yellow + ":".light_green + "c" + "o" + "l" + "l" + "e" + "c" + "t" + "i" + "n" + "g" + " d" + "a" + "t" + "a" + ":".light_green + " 】".light_yellow
    puts "                                     "+ "――" + "――" + "――" + "――" + "――" + "――" + "――" + "――" + "――"
    puts ""

    org_ids.each do |id|
      organization_samples[id] = { :raw_samples => [], :size => '', :subset_samples => [] }

      DB_CLIENT.query("SELECT scidea_keys.id, scidea_keys.activation_code, scidea_keys.learner_id, scidea_users.email, scidea_enrollments.id AS enrollment_id FROM scidea_keys LEFT JOIN scidea_users ON scidea_keys.learner_id=scidea_users.id LEFT JOIN scidea_enrollments ON scidea_keys.id=scidea_enrollments.key_id WHERE scidea_keys.consuming_organization_id=#{id}").each do |row|
        organization_samples[id][:raw_samples] << {:key_id => row['id'], :key_code => row['activation_code'], :learner_id => row['learner_id'], :learner_email => row['email'], :enrollment_id => row['enrollment_id'], :test_string => "TestRunner.new.sco_record_verification( :home_url => '#{SESSION_BASEURL}/', :admin_email => '#{get_org_admin_email(id)}', :key_code => '#{row['activation_code']}')"}
      end

      organization_samples[id][:size] = organization_samples[id][:raw_samples].size
      organization_samples[id][:subset_samples] = organization_samples[id][:raw_samples].sample( (organization_samples[id][:size] / 8).ceil )

    end

    return organization_samples
  end

  def sco_record_verification( params = {} )
    Tach.meter do
      tach('sco_record_verification') do
        # can be PER USER or array of users (by email, key)
        t = Tester.new(params[:home_url])
        t.visit_home_url
        t.login_type_selector(params)
        t.prepare_to_gather_status_scidea(params[:key_code])
        # [opt] status from user UI
        # [opt] status from OKM key state
        t.logout
        t.prepare_to_gather_status_legacy(params[:key_code])
        t.compare_sco_records_selector(params)
      end
    end
    return nil #clean final return
  end

  def self.org_scorecord_tests(mode, *org_ids)
    if mode == :run
      run_org_scorecord_tests(*org_ids)
    else
      display_org_scorecord_tests(:verbose, *org_ids) # :verbose for full output with info, :simple for just test output
    end
  end

  def self.display_org_scorecord_tests(mode, *org_ids)
    #TODO have two modes of display, brief and verbose, get all info for verbose with user email and enrollment stuff, but just the test string for brief

    if mode == :verbose
      org_ids.each do |id|
        samples = get_key_sample_per_org(id)

        puts ""
        puts "Sco Record Test Sample for ORG #{id} ↴"
        puts "┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉"
        puts ""
        samples[id][:subset_samples].each do |sample|
          puts "Test for key:#{sample[:key_code]}, used by #{sample[:learner_email]} [#{sample[:learner_id]}] as enrollment #{sample[:enrollment_id]}".bold
          puts sample[:test_string]
        end
        puts ""
      end
    else
      org_ids.each do |id|
        samples = get_key_sample_per_org(id)

        puts ""
        puts "Sco Record Test Sample for ORG #{id} ↴"
        puts "┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉"
        puts ""
        samples[id][:subset_samples].each do |sample|
          puts sample[:test_string]
        end
        puts ""
      end
    end

  end

  def self.run_org_scorecord_tests(*org_ids)
    org_ids.each do |id|
      samples = get_key_sample_per_org(id)

      puts ""
      puts "Running Sco Records Tests for Sample at ORG #{id} ↴"
      puts "┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉"
      puts ""
      puts "#{(organization_samples[id][:size] / 4).ceil} tests to run...".light_blue
      puts ""

      samples[id][:subset_samples].each do |sample|
        eval(sample[:test_string])
      end
    end
  end

  def self.get_user_by_id(id)
    DB_CLIENT.query("SELECT * FROM scidea_users where id=#{id}").each do |row|
      row
    end
  end

  def self.get_user_by_email(email)
    DB_CLIENT.query("SELECT * FROM scidea_users where email='#{email}'").each do |row|
      row
    end
  end

  def self.all_org_key_users_exist?(*org_ids)
    org_ids.each do |id|
      missing_emails = []
      missing_ids    = []

      get_key_sample_per_org(id)[id][:raw_samples].each do |single_sample|

        puts "ID: #{single_sample[:learner_id]} EMAIL: #{single_sample[:learner_email]}"

        # [skip] sample is an unused key
        if single_sample[:learner_id].nil? && single_sample[:learner_email].nil?
          next
        end

        # [catch] sample with learner id, but no email is an error
        if single_sample[:learner_email].nil? && !single_sample[:learner_id].nil?
          missing_emails << single_sample
          next
        end

        # [catch] sample with learner email, but no id is an error
        if !single_sample[:learner_email].nil? && single_sample[:learner_id].nil?
          missing_ids << single_sample
          next
        end

        # [catch] samples which have no record at all in the scidea database, but have references transferred from legacy
        missing_emails << single_sample if get_user_by_id(single_sample[:learner_id]).empty?
        missing_ids << single_sample if get_user_by_email(single_sample[:learner_email]).empty?
      end

      puts ""
      puts "For ORG #{id}:"
      puts "The following users (by email) have not been migrated over properly: \n#{missing_emails}" if missing_emails.length > 0
      puts "The following users (by id) have not been migrated over properly: \n#{missing_ids}"if missing_ids.length > 0
      puts "☆ All users have been properly migrated over!" if missing_emails.empty? && missing_ids.empty?
      puts ""

    end
  end



end