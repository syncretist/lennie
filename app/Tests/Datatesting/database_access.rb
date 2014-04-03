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
        samples = DatabaseQuery.get_key_sample_per_org_with_test_string(id)
        collected_tests = []

        puts ""
        puts "Sco Record Test Sample for ORG #{id} ↴"
        puts "┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉┉"
        puts ""
        samples[id][:subset_samples].each do |sample|
          collected_tests << ["Test for key:#{sample[:key_code]}, used by #{sample[:learner_email]} [#{sample[:learner_id]}] as enrollment #{sample[:enrollment_id]}", sample[:test_string]]
          puts "Test for key:#{sample[:key_code]}, used by #{sample[:learner_email]} [#{sample[:learner_id]}] as enrollment #{sample[:enrollment_id]}".bold
          puts sample[:test_string]
        end
        puts ""

        # temporary placement, should be broken out seperately
        p = StatusPoster.new
        p.post(POST_URIS['the-migrator'], { :organization_id => id, :test_name => 'sco_sample_investigation', :test_results => collected_tests.to_json })
      end
    else
      org_ids.each do |id|
        samples = DatabaseQuery.get_key_sample_per_org_with_test_string(id)

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
      samples = DatabaseQuery.get_key_sample_per_org_with_test_string(id)

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
end