# encoding: utf-8
# Need to change encoding to handle '®', '✔', '✘'
# http://stackoverflow.com/questions/1739836/invalid-multibyte-char-us-ascii-with-rails-and-ruby-1-9
# http://stackoverflow.com/questions/3678172/ruby-1-9-invalid-multibyte-char-us-ascii
# http://www.stefanwille.com/2010/08/ruby-on-rails-fix-for-invalid-multibyte-char-us-ascii/

require_relative './ui_helpers'

##########################################################
##########################################################

=begin

==================
==== One offs ====
==================

    == Login as SA ==
    Tester.new.standard_login(AHA_USERS['scitent-admin']['email'], AHA_USERS['scitent-admin']['password'])

===============
==== Tasks ====
===============

    == Key count tests (with standard user login and with become) ==
    TestRunner.new.key_count( :home_url => 'http://f.scitent.us/', :admin_email => 'okmtester2@dispostable.com', :admin_password => 'password', :org_id => 12)
    TestRunner.new.key_count( :home_url => 'http://f.scitent.us/', :admin_email => 'pierson.shelby@mayo.edu', :org_id => 981 )

    == Sco record tests ==
    TestRunner.new.sco_record_verification( :home_url => 'http://f.scitent.us/', :admin_email => 'pierson.shelby@mayo.edu', :key_code => '0ED5A98C69A7') # BLS HCP
    TestRunner.new.sco_record_verification( :home_url => 'http://f.scitent.us/', :admin_email => 'pierson.shelby@mayo.edu', :key_code => 'CEC80561D744') # ACLS

=end

##########################################################
##########################################################

class Tester
  include UIHelpers

  attr_accessor :home_url

  COURSES = {
      # add enumerated possible completion statuses for course and for sco
      # add elements for special cases, like single sco shares completion between tests, :unlimited_try test, etc...

      "80-1055" => { :course_title=>"BLS for Healthcare Providers Online part 1",                         :course_type=> :internal, :completion_criteria => [] },
      "80-1095" => { :course_title=>"Heartsaver® First Aid Online part 1",                         :course_type=> :internal, :completion_criteria => [] },
      "80-1461" => { :course_title=>"Heartsaver® First Aid Online With CPR & AED part 1",
                     :alternate_title => "Heartsaver First Aid Online With CPR & AED part 1 (80-1461)",
                     :course_type=> :internal,
                     :completion_criteria => [] },
      "80-1468" => { :course_title=>"Stroke: Prehospital Care Online", :course_type=> :internal, :completion_criteria => [] },
      "80-1473" => { :course_title=>"Learn:® Rapid STEMI ID", :course_type=> :internal, :completion_criteria => [] },
      "80-1480" => { :course_title=>"Acute Stroke Online",                         :course_type=> :internal, :completion_criteria => [] },
      "80-1501" => { :course_title=>"Heartsaver Bloodborne Pathogens",                         :course_type=> :internal, :completion_criteria => [] },
      "80-1516" => { :course_title=>"HeartCode™ ACLS Part 1",                         :course_type=> :internal, :completion_criteria => [] },
      "90-1400" => { :course_title=>"Heartsaver® First Aid Online Part 1",         :course_type=> :internal, :completion_criteria => [] },
      "90-1401" => { :course_title=>"Heartsaver® First Aid CPR AED Online Part 1", :course_type=> :internal, :completion_criteria => [] },
      "90-1402" => { :course_title=>"Heartsaver® CPR AED Online Part 1",           :course_type=> :internal, :completion_criteria => [] },
      "90-1403" => { :course_title=>"BLS for Healthcare Providers Online part 1",  :course_type=> :external, :completion_criteria => [:test, :eval] },
      "90-1405" => { :course_title=>"HeartCode® ACLS Part 1",                      :course_type=> :external, :completion_criteria => [:aicc_record] },
      "90-1420" => { :course_title=>"HeartCode® PALS Part 1",                      :course_type=> :external, :completion_criteria => [:aicc_record] },
      "90-1421" => { :course_title=>"Learn:® Rhythm Adult",                        :course_type=> :external, :completion_criteria => [:aicc_record] },
      "90-1425" => { :course_title=>"Acute Stroke Online",                         :course_type=> :internal, :completion_criteria => [] },
      "90-1429" => { :course_title=>"BLS Instructor Essentials",                   :course_type=> :internal, :completion_criteria => [] },
      "90-1430" => { :course_title=>"PALS Instructor Essentials",                  :course_type=> :internal, :completion_criteria => [] },
      "90-1431" => { :course_title=>"Heartsaver® Instructor Essentials",                         :course_type=> :internal, :completion_criteria => [] },
      "90-1432" => { :course_title=>"ACLS Instructor Essentials",                  :course_type=> :internal, :completion_criteria => [] }
  }

  def initialize(home_url='http://f.scitent.us/')
    @home_url = home_url
  end

  def login_type_selector( params = {} )
    if params[:admin_password]
      standard_login(params[:admin_email], params[:admin_password])
    else
      become_login(params[:admin_email])
    end
  end

  def standard_login(email, password)
    if current_url == @home_url || current_url == @home_url + "/"
      fill_in('user_email', :with => email)
      fill_in('user_password', :with => password)
      click_button('Sign In')
    else
      puts "You are at #{current_url}, you should be at #{@home_url} to sign in!!! I am logging you out, please try again."
      logout
    end
  end

  def become_login(email)
    standard_login(AHA_USERS['scitent-admin']['email'], AHA_USERS['scitent-admin']['password'])
    visit("#{@home_url}admin/tech_support")
    fill_in('email', :with => email)
    click_button('Find Users')
    # assumes first result is correct!
    if all('td a')[1].text.include?('_inactive') # handle case where there is another result of the email, but it is inactive
      visit("#{@home_url}admin/tech_support/user/#{all('td a')[2].text}")
    else
      visit("#{@home_url}admin/tech_support/user/#{all('td a').first.text}")
    end
    click_link("#{all('a')[5].text}")
    fill_in('reason', :with => 'autotest login')
    click_button("#{all('button')[4].text}")
  end

  def legacy_techsupport_login
    fill_in('Email'   , :with => AHA_USERS['legacy-tech-support-user']['email'])
    fill_in('Password', :with => AHA_USERS['legacy-tech-support-user']['password'])
    click_button('Login')
  end

  def legacy_techsupport_logout
    visit("http://ts.onlineaha.org/index.cfm?view=Logoff")
  end

  def logout
    visit("#{@home_url}users/sign_out")
    visit("#{@home_url}users/sign_out") # second time for become user, then admin
  end

  def compare_key_usage
    if @legacy_course_record[:key_usage_status] == @scidea_course_record[:key_usage_status]
      if @legacy_course_record[:key_usage_status] == 'available'
        puts "#{green_check} Keys are available for use in both scidea and legacy OKM."
      else
        puts "#{red_x} The keys are not set to available, there must be a problem, see the raw data for details:"
        puts " => Legacy key usage status: " + "#{@legacy_course_record[:key_usage_status]}".bold
        puts " => Scidea key usage status: " + "#{@scidea_course_record[:key_usage_status]}".bold
      end
    else
      puts "#{red_x} The keys are not set to the same usage status, there must be a problem, see the raw data for details:"
      puts " => Legacy key usage status: " + "#{@legacy_course_record[:key_usage_status]}".bold
      puts " => Scidea key usage status: " + "#{@scidea_course_record[:key_usage_status]}".bold
    end
  end

  def compare_sco_records_selector(params)
    marquee_final "Final Sco Record Comparison"

    if @scidea_course_record[:non_active] || @legacy_course_record[:non_active]
      compare_sco_records_unusual(params)
    else
      compare_sco_records_standard
    end

  end

  def compare_sco_records_unusual(params)
    if @scidea_course_record[:non_active] && @legacy_course_record[:non_active]
      puts "#{green_check} This course is not active in either scidea or legacy, it is a properly unused key."
      prepare_to_gather_key_usage_scidea(params)
      logout
      prepare_to_gather_key_usage_legacy(params)
      legacy_techsupport_logout
      compare_key_usage
    else
      puts "#{red_x} This key is not activated properly in both scidea and legacy, there must be a problem, see the raw data for details."
    end
  end

  def compare_sco_records_standard
    marquee_intermediate "High level comparison:"

    scidea_record = @scidea_course_record
    legacy_record = @legacy_course_record

    # compare name

    if scidea_record[:course_name] == legacy_record[:course_name]
      puts "#{green_check} Comparison for course: " + "#{scidea_record[:course_name]}".bold
    else
      puts "#{red_x} Course names do not match, scidea is " + "#{scidea_record[:course_name]}".bold + " and legacy is " "#{legacy_record[:course_name]}".bold
    end

    # compare start date

    if scidea_record[:start_date] == legacy_record[:start_date]
      puts "#{green_check} Start date matches in scidea and legacy: " + "#{scidea_record[:start_date]}".bold
    else
      puts "#{red_x} Start date does not match, scidea has " + "#{scidea_record[:start_date]}".bold + " and legacy has " + "#{legacy_record[:start_date]}".bold
    end

    # compare status

    if scidea_record[:course_status] == legacy_record[:course_status]
      puts "#{green_check} Course status matches in scidea and legacy: " + "#{scidea_record[:course_status]}".bold
    else
      puts "#{red_x} Course status does not match, scidea has status of " + "#{scidea_record[:course_status]}".bold + " and legacy has status of " + "#{legacy_record[:course_status]}".bold
    end

    # compare completion date

    if scidea_record[:completion_date] == legacy_record[:completion_date]
      puts "#{green_check} Completion date matches in scidea and legacy: " + "#{scidea_record[:completion_date]}".bold
    else
      puts "#{red_x} Completion date does not match, scidea has " + "#{scidea_record[:completion_date]}".bold + " and legacy has " + "#{legacy_record[:completion_date]}".bold
    end

    # compare skills check
    # TODO

    # compare exercise statuses

    marquee_intermediate "Comparison per sco:"

    scidea_record[:exercise_status].each_with_index do |e, i|
      if e[0] == legacy_record[:exercise_status][i][0]
        if e[1] == legacy_record[:exercise_status][i][1]
          puts "#{green_check} Status in scidea and legacy matches for " + "#{e[0]}".light_magenta + " as " + "#{e[1]}".bold
        else
          puts "#{red_x} Status does not match in scidea and legacy, " + "#{e[0]}".light_magenta + " is listed as " + "#{e[1]}".bold + " in scidea and " + "#{legacy_record[:exercise_status][i][1]}".bold + " in legacy."
        end
      else
        puts "#{red_x} Exercise name does not match in scidea and legacy it is listed as " + "#{e[0]}".light_yellow.bold + " in scidea and " + "#{legacy_record[:exercise_status][i][0]}".light_yellow.bold + " in legacy."
      end
    end

    puts ""
    
  end

  def gather_key_counts_legacy

    courses = all('tbody').text.gsub(/Part 1|part 1|[a-zA-Z]|®/, '').scan(/(\d\d-\d+)/)
    counts  = all('tbody').text.gsub(/Part 1|part 1|[a-zA-Z]|®/, '').scan(/(\d+\s\d+\s\d+\s\d+\s\d+\s\d+\s\d+\s\d+)/)

    final_counts_legacy = []

    courses.each { |course_id| final_counts_legacy << { :course_id => course_id[0] } }
    counts.each_with_index do |a, i|
      course_count = a[0].split(' ')
      final_counts_legacy[i][:key_counts] = Hash[ :total_keys => course_count[6], :used_keys => course_count[7], :available_keys => course_count[0], :assigned_keys => course_count[1], :in_progress => course_count[2], :completed => course_count[3], :failed => course_count[4], :archived => course_count[5] ]
    end

    final_counts_legacy = final_counts_legacy.sort { |x, y| x[:course_id] <=> y[:course_id] }

    ## Report final raw data
    #table_general( :heading => "LEGACY", :middle_row => "There are #{@final_counts_legacy.size} courses.")

    return final_counts_legacy

    #final_counts_legacy[0]                       # this will give you full course element
    #final_counts_legacy[0][:course_name]         # this will give you name at any index
    #final_counts_legacy[0][:key_counts]          # this will give you key count hash at any index
    #final_counts_legacy[0][:key_counts][:failed] # this will give you failed in the counts at any index

  end
  
  def gather_key_counts_scidea

    final_counts_scidea = []
    all('div.client_package').each { |div| final_counts_scidea << { :course_id => "#{div.text.scan(/(\s\d\d-\d+)/)[0][0].lstrip}" } }
    all('div.client_package_alt').each { |div| final_counts_scidea << { :course_id => "#{div.text.scan(/(\s\d\d-\d+)/)[0][0].lstrip}" } }

    temp_counts = []
    all('div.client_package').each { |div| temp_counts << div.text.gsub(/Part 1|part 1|\d\d-\d+|[a-zA-Z]|[(|)]|:|-|&|®|\|/, '').lstrip.split(/\s+/) }
    all('div.client_package_alt').each { |div| temp_counts << div.text.gsub(/Part 1|part 1|\d\d-\d+|[a-zA-Z]|[(|)]|:|-|&|®|\|/, '').lstrip.split(/\s+/) }
    temp_counts.each_with_index { |a, i| final_counts_scidea[i][:key_counts] = Hash[:total_keys => a[0], :used_keys => a[1], :available_keys => a[2], :assigned_keys => a[3], :in_progress => a[4], :completed => a[5], :failed => a[6], :archived => a[7] ] }

    final_counts_scidea = final_counts_scidea.sort { |x, y| x[:course_id] <=> y[:course_id] }

    ## Title of raw data report
    #marquee_raw "Raw Key Count Data"

    # Report final raw data
    #table_general( :heading => "SCIDEA", :middle_row => "There are #{@final_counts_scidea.size} courses.")

    return final_counts_scidea

    #final_counts_scidea[0]                       # this will give you full course element
    #final_counts_scidea[0][:course_name]         # this will give you name at any index
    #final_counts_scidea[0][:key_counts]          # this will give you key count hash at any index
    #final_counts_scidea[0][:key_counts][:failed] # this will give you failed in the counts at any index

  end

  def gather_key_usage_legacy(params)
    popup  = page.driver.browser.window_handles[1]

    page.driver.browser.switch_to.window(popup)
    sleep 3 # wait for popup to fully load
    fill_in('key', :with => params[:key_code])
    click_button('Find')
    @legacy_course_record[:key_usage_status] = find('#tableReport').all('td')[3].text # "available" if the key can be assigned
    utility_close_selenium_popup_window
  end

  def gather_key_usage_scidea
    @scidea_course_record[:key_usage_status] = all('td')[5].text # "available" if the key can be assigned
  end

  def gather_status_legacy_type_selector
    @legacy_course_record = {}

    if all('body').text == "Unable to display this record. Please contact tech support."
      gather_status_legacy_unusual
    else
      gather_status_legacy_standard
    end

  end

  def gather_status_legacy_unusual

    # two known unusual cases
    # NOT ACTIVATED BOTH (in scidea with no user or enrollment associated with key)
    # need to change gather
    # NOT ACTIVATED SCIDEA (in scidea as no user but enrollment)
    # need to chance compare as well as gather

    @legacy_course_record[:non_active] = all('body').text

    # report final raw data
    table_general(:heading => "LEGACY", :middle_row => "There are no active scos.")
    pp @legacy_course_record


  end

  def gather_status_legacy_standard

    @legacy_course_record[:course_name]     = all('p')[1].text.gsub(/^Course:\s/, '').gsub(/\s\(\d\d-\d+\)/, '')
    @legacy_course_record[:start_date]      = all('p')[3].text.gsub(/^Start Date:\s/, '')
    @legacy_course_record[:course_status]   = all('p')[4].text.gsub(/^Completion Status:\s/, '').capitalize
    @legacy_course_record[:completion_date] = all('p')[5].text.gsub(/^Completion Date:\s/, '')
    @legacy_course_record[:skills_check]    = all('p')[6].text.gsub(/^Skills Check:\s/, '')

    @legacy_course_record[:exercise_status] = []

    # handle unique interface cases
    if (@legacy_course_record[:completion_date] =~ /^\d\d\/\d\d\/\d\d\d\d$/).nil? # if the string does not match date format, make it nil
      @legacy_course_record[:completion_date] = nil
    end

    if @legacy_course_record[:course_name] == "Acute Stroke Online (80-1480)"
      @legacy_course_record[:course_name] = "Acute Stroke Online"
    end

    # even: exercise
    # odd: exercise status
    # BLS
    # 0 | 1 -> 48 | 49 (eval)
    # (if blank not attempted?, if passed, complete)
    # HEARTCODE ACLS
    # ?

    ## BLS HCP
    if @legacy_course_record[:course_name] == COURSES["90-1403"][:course_title]
      48.times do |i| # will grab everything except for the eval at the end (need it? if so, go to 49)
        if i.even?
          @legacy_course_record[:exercise_status] << [all('td')[i].text, all('td')[i + 1].text]
        end
      end

      # translate to scidea terminology
      @legacy_course_record[:exercise_status].each do |e|
        if e[1] == "Passed"
          e[1] = "completed"
        end
        if e[1] == ""
          e[1] = "Not Started"
        end
        if e[1] == "Failed"
          e[1] = "failed"
        end
        if e[0] == "BLS/CPR Basics for Infants"
          e[0] = "BLS / CPR Basics for Infants"
        end
        if e[0] == "BLS HCP Test Version B"
          e[0] = "BLS Test B"
        end
        if e[0] == "BLS HCP Test Version A"
          e[0] = "BLS Test A"
        end
      end
    end

    ## HC ACLS
    if @legacy_course_record[:course_name] == COURSES["90-1405"][:course_title]
      @legacy_course_record[:exercise_status] << ['HeartCode 1', @legacy_course_record[:course_status].downcase] #temp use of course record to stand in for missing value
    end

    ## HC PALS
    if @legacy_course_record[:course_name] == COURSES["90-1420"][:course_title]
      @legacy_course_record[:exercise_status] << ['HeartCode 1', @legacy_course_record[:course_status].downcase] #temp use of course record to stand in for missing value
    end

    ## BLS IE
    if @legacy_course_record[:course_name] == COURSES["90-1429"][:course_title]
      4.times do |i|
        i = i + 2 # this removes the evaluation from results to match with scidea, to reinstate, remove this and change loop 4 times to 6
        if i.even?
          @legacy_course_record[:exercise_status] << [all('td')[i].text, all('td')[i + 1].text]
        end
      end

      # translate to scidea terminology
      @legacy_course_record[:exercise_status].each do |e|
        if e[1] == "Passed"
          e[1] = "completed"
        end
      end
    end

    ## HS FA CPR AED
    if @legacy_course_record[:course_name] == (COURSES["80-1461"][:course_title] || COURSES["80-1461"][:alternate_title])
      # 22 - 25 even odd pairs: even is sco, odd is status, 41 pairs
      83.times do |i|
        if i.even?
          @legacy_course_record[:exercise_status] << [all('td')[i].text, all('td')[i + 1].text]
        end
      end

      # translate to scidea terminology
      @legacy_course_record[:exercise_status].each do |e|
        if e[0] == "Heartsaver First Aid With CPR & AED Course Evaluation"
          @legacy_course_record[:exercise_status].delete_at(@legacy_course_record[:exercise_status].index(e)) # removes evaluation from results to match scidea
        end
        if e[0] == "Heartsaver First Aid & CPR/AED Review Question Test Version B"
          e[0] = "Heartsaver First Aid With CPR & AED Review Question Test Version B"
        end
        if e[1] == "Passed"
          e[1] = "completed"
        end
        if e[1] == ""
          e[1] = "Not Started"
        end
        if e[1] == "Failed"
          e[1] = "failed"
        end
      end
    end

    # sort to match properly, otherwise would need to search full array
    @legacy_course_record[:exercise_status] = @legacy_course_record[:exercise_status].sort { |x, y| x[0] <=> y[0] }

    # report final raw data
    table_general(:heading => "LEGACY", :middle_row => "There are #{@legacy_course_record[:exercise_status].size} scos.")
    pp @legacy_course_record

  end

  def gather_status_scidea_type_selector
    @scidea_course_record = {}

    ## be sure the course progress modal has loaded (some of its elements flicker after it loads)
    find('#CourseReportLabel')
    sleep 3 # increase this number (seconds) if intermittent failures continue at the course progress modal

    if all('p')[1].text == "This key has not been activated yet."
      gather_status_scidea_unusual
    else
      gather_status_scidea_standard
    end

  end

  def gather_status_scidea_unusual

    # two known unusual cases
    # NOT ACTIVATED BOTH (in scidea with no user or enrollment associated with key)
    # need to change gather
    # NOT ACTIVATED SCIDEA (in scidea as no user but enrollment)
    # need to chance compare as well as gather

    @scidea_course_record[:non_active] = all('p')[1].text

    # Title of raw data report
    marquee_raw "Raw Sco Record Data"

    # report final raw data
    table_general(:heading => "SCIDEA", :middle_row => "There are no active scos.")
    pp @scidea_course_record

  end

  def gather_status_scidea_standard

    @scidea_course_record[:course_name]     = all('p')[4].text
    @scidea_course_record[:start_date]      = all('td')[17].text
    @scidea_course_record[:course_status]   = all('td')[19].text.gsub(/\s\(.*\)/, '')
    @scidea_course_record[:completion_date] = all('td')[19].text.scan(/\d+\/\d+\/\d+/)[0]
    @scidea_course_record[:skills_check]    = ''

    @scidea_course_record[:exercise_status] = []

    # even: exercise
    # odd: exercise status
    # BLS
    # 22 | 23 -> 68 | 69
    # HEARTCODE ACLS
    # 22 | 23 (only)


    ## BLS HCP
    if @scidea_course_record[:course_name] == COURSES["90-1403"][:course_title]
      48.times do |i|
        i = i + 22
        if i.even?
          @scidea_course_record[:exercise_status] << [all('td')[i].text, all('td')[i + 1].text]
        end
      end

      # translate to legacy terminology
      @scidea_course_record[:exercise_status].each do |e|
        if e[1] == "\"Not Started\""
          e[1] = "Not Started"
        end
        unless e[1][/\d+/].nil? # catch numerical string
          if e[1].to_i >= 80 # assumption that >= 80 is the pass threshold
            e[1] = "completed"
          else
            e[1] = "failed"
          end
        end
      end
    end

    ## HC ACLS
    if @scidea_course_record[:course_name] == COURSES["90-1405"][:course_title]
      1.times do |i|
        i = i + 22
        if i.even?
          @scidea_course_record[:exercise_status] << [all('td')[i].text, all('td')[i + 1].text]
        end
      end

      # translate to legacy terminology
      @scidea_course_record[:exercise_status].each do |e|
        if e[1] == "in_progress"
          e[1] = "in progress"
        end
      end
    end

    ## HC PALS
    if @scidea_course_record[:course_name] == COURSES["90-1420"][:course_title]
      1.times do |i|
        i = i + 22
        if i.even?
          @scidea_course_record[:exercise_status] << [all('td')[i].text, all('td')[i + 1].text]
        end
      end

      # translate to legacy terminology
      @scidea_course_record[:exercise_status].each do |e|
        if e[1] == "in_progress"
          e[1] = "in progress"
        end
      end
    end


    ## BLS IE
    if @scidea_course_record[:course_name] == COURSES["90-1429"][:course_title]
      # 22 - 25 even odd pairs: even is sco, odd is status
      4.times do |i|
        i = i + 22
        if i.even?
          @scidea_course_record[:exercise_status] << [all('td')[i].text, all('td')[i + 1].text]
        end
      end
    end

    ## HS FA CPR AED
    if @scidea_course_record[:course_name] == (COURSES["80-1461"][:course_title] || COURSES["80-1461"][:alternate_title])
      # 22 - 25 even odd pairs: even is sco, odd is status, 41 pairs
      82.times do |i|
        i = i + 22
        if i.even?
          @scidea_course_record[:exercise_status] << [all('td')[i].text, all('td')[i + 1].text]
        end
      end

      # translate to legacy terminology
      @scidea_course_record[:exercise_status].each do |e|
        if e[1] == "\"Not Started\""
          e[1] = "Not Started"
        end
        unless e[1][/\d+/].nil? # catch numerical string
          if e[1].to_i >= 84 # assumption that >= 80 is the pass threshold
            e[1] = "completed"
          else
            e[1] = "failed"
          end
        end
      end
    end

    # sort to match properly, otherwise would need to search full array
    @scidea_course_record[:exercise_status] = @scidea_course_record[:exercise_status].sort { |x, y| x[0] <=> y[0] }

    # Title of raw data report
    marquee_raw "Raw Sco Record Data"

    # report final raw data
    table_general(:heading => "SCIDEA", :middle_row => "There are #{@scidea_course_record[:exercise_status].size} scos.")
    pp @scidea_course_record

  end
  
  def prepare_to_gather_key_counts_legacy(org_id)
    visit_oksanas_totals_interface(org_id)
    gather_key_counts_legacy
  end
  
  def prepare_to_gather_key_counts_scidea
    visit_okm_route
    gather_key_counts_scidea
  end

  def prepare_to_gather_key_usage_legacy(params)
    visit_legacy_techsupport_tool
    setup_legacy_techsupport_tool_to_open_legacy_okm(params)
    gather_key_usage_legacy(params)
  end

  def prepare_to_gather_key_usage_scidea(params)
    visit_home_url
    login_type_selector(params)
    visit_okm_route
    setup_okm_search_by_key(params[:key_code])
    gather_key_usage_scidea
  end

  def prepare_to_gather_status_legacy(key_code)
    visit_oksanas_sco_record_interface(key_code)
    gather_status_legacy_type_selector
  end
  
  def prepare_to_gather_status_scidea(key_code)
    setup_user_modal(key_code)
    gather_status_scidea_type_selector
  end

  def setup_legacy_techsupport_tool_to_open_legacy_okm(params)
    legacy_techsupport_login
    setup_become_admin_in_legacy_okm(params[:admin_email])
  end

  def setup_become_admin_in_legacy_okm(admin_email)
    click_link('Links')
    click_link('Allow logins as AHA user')
    fill_in('person_email', :with => admin_email)
    fill_in('days', :with => 1)
    click_button('Create Access Window')
    all('td', :text => admin_email )[1].first(:xpath,".//..").choose('deleteID') # select radio button option
    click_button('Log in to OKM through this window')
  end

  def setup_okm_search_by_key(key_code)
    fill_in('q', :with => key_code) # use the key for unique record, email may turn up for many courses
    find('#q').native.send_keys(:return) # click enter to submit
    ## be sure the page has loaded (some of its elements flicker after it loads)
    find('#key_datatable')
    sleep 3 # increase this number (seconds) if intermittent failures continue at the course progress modal
  end
  
  def setup_user_modal(key_code)
    setup_okm_search_by_key(key_code)
    modal = find('a.btn')  # be double sure the element has loaded on the page by caching it
    modal.click # assumes there is only one result
  end

  def utility_close_selenium_popup_window
    # Find our target window
    parent = page.driver.browser.window_handles[0]
    popup  = page.driver.browser.window_handles[1]

    # Close it
    page.driver.browser.switch_to.window(popup)
    page.driver.browser.close

    # Have the Selenium driver point to another window
    page.driver.browser.switch_to.window(parent)
  end

  def visit_home_url
    visit(@home_url)
  end

  def visit_legacy_techsupport_tool
    visit("http://ts.onlineaha.org")
  end

  def visit_okm_route
    visit("#{@home_url}keys")
  end

  def visit_oksanas_sco_record_interface(key_code)
    visit("http://web2.onlineaha.org/index.cfm?fuseaction=info.cqry&pk=#{key_code}&plaintext=1")
  end

  def visit_oksanas_totals_interface(org_id)
    visit("http://web2.onlineaha.org/index.cfm?fuseaction=info.cqry&org=#{org_id}")
  end
  
end