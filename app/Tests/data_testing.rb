# encoding: utf-8
# Need to change encoding to handle '®', '✔', '✘'
# http://stackoverflow.com/questions/1739836/invalid-multibyte-char-us-ascii-with-rails-and-ruby-1-9
# http://stackoverflow.com/questions/3678172/ruby-1-9-invalid-multibyte-char-us-ascii
# http://www.stefanwille.com/2010/08/ruby-on-rails-fix-for-invalid-multibyte-char-us-ascii/

module UIHelpers
  def green_check
    # should be called within a double quoted string as "#{green_check} "...
    return "[ " + "✔".green + " ]"
  end
  def red_x
    # should be called within a double quoted string as "#{red_x} "...
    return "[ " + "✘".red + " ]"
  end
  def marquee_raw(text)

    marquee_general(:text             => text,
                    :text_color       => :red,
                    :background_color => :on_blue,
                    :emphasis         => :bold,
                    :table_width      => 70,
                    #:padding_left     => 3,
                    :border_x         => "*",
                    :border_i         => "*")

  end
  def marquee_intermediate(text)

    marquee_general(:text             => text,
                    :text_color       => :blue,
                    :background_color => :on_white,
                    :emphasis         => :bold,
                    :table_width      => 30,
                    #:padding_left     => 3,
                    :border_x         => "-",
                    :border_i         => "|")

  end
  def marquee_final(text)

    marquee_general(:text             => text,
                    :text_color       => :yellow,
                    :background_color => :on_green,
                    :emphasis         => :bold,
                    :table_width      => 70,
                    #:padding_left     => 3,
                    :border_x         => "=",
                    :border_i         => "x")
  end
  def marquee_general( params = {} )

    # beware, table widths manually set under 40 appear to be causing error, maybe something else caused this?
    # NameError: undefined local variable or method `wanted' for #<Terminal::Table:0x9cf6e54>

    rows    = []
    content = []

    content << params[:text].send(params[:text_color]).send(params[:background_color]).send(params[:emphasis])
    rows << content

    marquee = Terminal::Table.new :rows => rows
    marquee.style = {:width => params[:table_width], :padding_left => 3, :border_x => params[:border_x], :border_i => params[:border_i]}

    puts ""
    puts ""
    puts marquee
    puts ""

  end
  def table_course_record
    # heading and single section
  end
  def table_key_count
    # heading and two sections
  end
  def table_sco_comparison
    # wind and array up
  end
  def table_general( params = {} )

    headings        = []
    content_middle  = []
    rows            = []

    headings        << params[:heading]
    content_middle  << params[:middle_row]
    rows            << content_middle

    table = Terminal::Table.new :headings => headings, :rows => rows

    puts table

  end
end


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

  def compare_counts
    marquee_final "Final Key Count Comparison"

    ## Compare number of courses.

    scidea_number = @final_counts_scidea.size
    legacy_number = @final_counts_legacy.size

    if scidea_number == legacy_number
      puts "#{green_check} Number of courses in scidea and legacy match."
    else
      puts "#{red_x} Number of courses in scidea and legacy are off by #{(scidea_number - legacy_number).abs}"
    end

    puts ""
    puts ""

    ## Compare key counts per course.

      # use HASH.has_value? to compare instead of iterate?

    @final_counts_scidea.each do |s|
      scidea_course = s[:course_id]
      scidea_counts = s[:key_counts]

      @final_counts_legacy.each do |l|
        legacy_course = l[:course_id]
        legacy_counts = l[:key_counts]
        if scidea_course == legacy_course

          course_title   = "Course #{scidea_course} [#{COURSES[scidea_course] ? COURSES[scidea_course][:course_title] : '::no matching course title::'}]"
          puts course_title
          underline_size = course_title.length
          underline_size.times { print "-" }
          puts ""

          count_differences("Total Keys",    scidea_counts[:total_keys],     legacy_counts[:total_keys])
          count_differences("Used Keys",     scidea_counts[:used_keys],      legacy_counts[:used_keys])
          count_differences("Available Keys",scidea_counts[:available_keys], legacy_counts[:available_keys])
          count_differences("Assigned Keys", scidea_counts[:assigned_keys],  legacy_counts[:assigned_keys])
          count_differences("In Progress",   scidea_counts[:in_progress],    legacy_counts[:in_progress])
          count_differences("Completed",     scidea_counts[:completed],      legacy_counts[:completed])
          count_differences("Failed",        scidea_counts[:failed],         legacy_counts[:failed])
          count_differences("Archived",      scidea_counts[:archived],       legacy_counts[:archived])

          puts ""

        else
          #No Course Match!, this will print for every iteration, only want once at the end
          #puts "Scidea(#{scidea_course}) | Legacy(#{legacy_course}): No matching course in both."
        end
      end
    end

    return nil # to suppress return of the hash

    # cut in and experiment
    # require 'pry'; binding.pry

  end

  def count_differences(category, scidea_number, legacy_number)
    scidea = scidea_number.to_i
    legacy = legacy_number.to_i
    intro = " => For #{category},"

    if scidea > legacy
      puts "#{red_x} #{intro} Scidea count is greater than Legacy by #{scidea - legacy}"
    elsif scidea < legacy
      puts "#{red_x} #{intro} Scidea count is less than Legacy by #{legacy - scidea}"
    else
      puts "#{green_check} #{intro} counts are equal."
    end
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

    @final_counts_legacy = []

    courses.each { |course_id| @final_counts_legacy << { :course_id => course_id[0] } }
    counts.each_with_index do |a, i|
      course_count = a[0].split(' ')
      @final_counts_legacy[i][:key_counts] = Hash[ :total_keys => course_count[6], :used_keys => course_count[7], :available_keys => course_count[0], :assigned_keys => course_count[1], :in_progress => course_count[2], :completed => course_count[3], :failed => course_count[4], :archived => course_count[5] ]
    end

    @final_counts_legacy = @final_counts_legacy.sort { |x, y| x[:course_id] <=> y[:course_id] }

    ## Report final raw data
    table_general( :heading => "LEGACY", :middle_row => "There are #{@final_counts_legacy.size} courses.")

    pp @final_counts_legacy

    #@final_counts_legacy[0]                       # this will give you full course element
    #@final_counts_legacy[0][:course_name]         # this will give you name at any index
    #@final_counts_legacy[0][:key_counts]          # this will give you key count hash at any index
    #@final_counts_legacy[0][:key_counts][:failed] # this will give you failed in the counts at any index

  end
  
  def gather_key_counts_scidea
    @final_counts_scidea = []
    all('div.client_package').each { |div| @final_counts_scidea << { :course_id => "#{div.text.scan(/(\s\d\d-\d+)/)[0][0].lstrip}" } }
    all('div.client_package_alt').each { |div| @final_counts_scidea << { :course_id => "#{div.text.scan(/(\s\d\d-\d+)/)[0][0].lstrip}" } }
    temp_counts = []
    all('div.client_package').each { |div| temp_counts << div.text.gsub(/Part 1|part 1|\d\d-\d+|[a-zA-Z]|[(|)]|:|-|&|®|\|/, '').lstrip.split(/\s+/) }
    all('div.client_package_alt').each { |div| temp_counts << div.text.gsub(/Part 1|part 1|\d\d-\d+|[a-zA-Z]|[(|)]|:|-|&|®|\|/, '').lstrip.split(/\s+/) }
    temp_counts.each_with_index { |a, i| @final_counts_scidea[i][:key_counts] = Hash[:total_keys => a[0], :used_keys => a[1], :available_keys => a[2], :assigned_keys => a[3], :in_progress => a[4], :completed => a[5], :failed => a[6], :archived => a[7] ] }

    @final_counts_scidea = @final_counts_scidea.sort { |x, y| x[:course_id] <=> y[:course_id] }

    ## Title of raw data report
    marquee_raw "Raw Key Count Data"

    # Report final raw data
    table_general( :heading => "SCIDEA", :middle_row => "There are #{@final_counts_scidea.size} courses.")

    pp @final_counts_scidea

    #@final_counts_scidea[0]                       # this will give you full course element
    #@final_counts_scidea[0][:course_name]         # this will give you name at any index
    #@final_counts_scidea[0][:key_counts]          # this will give you key count hash at any index
    #@final_counts_scidea[0][:key_counts][:failed] # this will give you failed in the counts at any index

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
    if @legacy_course_record[:course_name] == COURSES["80-1461"][:course_title] || COURSES["80-1461"][:alternate_title]
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
    if @scidea_course_record[:course_name] == COURSES["80-1461"][:course_title] || COURSES["80-1461"][:alternate_title]
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
          if e[1].to_i >= 80 # assumption that >= 80 is the pass threshold
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

class TestRunner

  def key_count( params = {} )
    Tach.meter do
      tach('key_count') do
        t = Tester.new(params[:home_url])
        puts ""
        puts "ORG ID: #{params[:org_id]}"
        t.visit_home_url
        t.login_type_selector(params)
        t.prepare_to_gather_key_counts_scidea
        t.logout
        t.prepare_to_gather_key_counts_legacy(params[:org_id])
        t.compare_counts
      end
    end
    return nil #clean final return
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
end

class DataTestRunner
  def data_test_prep(*org_ids)
    Tach.meter do
      tach('data_test_prep') do
        puts ""
        DatabaseAccess.display_org_information(*org_ids)
        DatabaseAccess.display_admins_with_org_access(*org_ids)
        DatabaseAccess.org_keycount_tests :display, *org_ids  # :display to show test strings, :run to run the tests
        DatabaseAccess.org_scorecord_tests :display, *org_ids # :display to show test strings, :run to run the tests
        DatabaseAccess.all_org_key_users_exist?(*org_ids)
        DatabaseAccess.doubled_groups?(*org_ids)
      end
    end
    return nil #clean final return
  end
end

class DestructiveDatabaseAccess
  # !! updates, deletes, etc.. should be wrapped here so mistakes are not made!!!, find ways to rollback by saving temp ?
end

class DatabaseAccess

  def self.get_org_admin_email(*org_ids)
    # returns admin email(s), string if one, array if > than 1
    emails = []

    org_ids.each do |id|
      DB_CLIENT.query("SELECT admin_email FROM scidea_organizations WHERE id=#{id}").each do |row|
        emails << row['admin_email']
      end
    end

    return emails.first if emails.size <= 1
    return emails
  end

  def self.get_org_name(*org_ids)
    # returns org name(s), string if one, array if > than 1
    names = []

    org_ids.each do |id|
      DB_CLIENT.query("SELECT name FROM scidea_organizations WHERE id=#{id}").each do |row|
        names << row['name']
      end
    end

    return names.first if names.size <= 1
    return names
  end

  def self.get_org_key_count(*org_ids)
    # returns org key count(s), integer if one, array if > than 1
    counts = []

    org_ids.each do |id|
      DB_CLIENT.query("SELECT COUNT(*) FROM scidea_keys WHERE consuming_organization_id=#{id}").each do |row|
        counts << row['COUNT(*)']
      end
    end

    return counts.first if counts.size <= 1
    return counts
  end

  def self.get_org_subdomain(*org_ids)
    # returns org subdomain(s), string if one, array if > than 1
    subdomains = []

    org_ids.each do |id|
      DB_CLIENT.query("SELECT subdomain FROM scidea_organizations WHERE id=#{id}").each do |row|
        subdomains << row['subdomain']
      end
    end

    return subdomains.first if subdomains.size <= 1
    return subdomains
  end

  def self.get_admins_with_org_access(*org_ids)
    admins = []
    org_ids.each do |id|
      DB_CLIENT.query("SELECT scidea_users.email FROM scidea_role_users LEFT JOIN scidea_users ON scidea_role_users.user_id=scidea_users.id LEFT JOIN scidea_organization_role_users ON scidea_role_users.id=scidea_organization_role_users.role_user_id WHERE scidea_organization_role_users.organization_id = #{id}").each do |row|
        admins << row['email']
      end
    end

    return admins.first if admins.size <= 1
    return admins
  end

  def self.display_admins_with_org_access(*org_ids)

    puts""
    org_ids.each do |id|

      admins = get_admins_with_org_access(id)

      puts"These emails have admin access to organization #{id}:"
      puts admins
      puts ""

      # show that admins all exist as true db users

      if admins.is_a? Array
        admins.each do |admin|
          if get_user_by_email(admin).empty?
            puts "#{admin} is a proper user in the scidea database!".red
          else
            puts "#{admin} is a proper user in the scidea database".green
          end
        end
      else
        if get_user_by_email(admins).empty?
          puts "#{admins} is not a proper user in the scidea database!".red
        else
          puts "#{admins} is a proper user in the scidea database".green
        end
      end

      puts ""

      # makes sure admins can log into their okm
      if admins.is_a? Array
        admins.each do |admin|
          t = Tester.new(SESSION_BASEURL + "/")
          t.visit_home_url
          t.login_type_selector(:admin_email => admin)
          if has_text? "Online Key Manager"
            puts "#{admin} can log into their OKM".green
          else
            puts "#{admin} cannot log into their OKM".red
          end
          t.logout
        end
      else
        t = Tester.new(SESSION_BASEURL + "/")
        t.visit_home_url
        t.login_type_selector(:admin_email => admins)
        if has_text? "Online Key Manager"
          puts "#{admins} can log into their OKM".green
        else
          puts "#{admins} cannot log into their OKM".red
        end
        t.logout
      end

      puts ""

    end
  end

  def self.display_org_information(*org_ids)
    # returns pretty string for testing org info for each org entered

    org_ids.each do |id|
      admin_email   = get_org_admin_email(id)
      org_name      = get_org_name(id)
      org_key_count = get_org_key_count(id)
      org_subdomain = get_org_subdomain(id)
      org_id        = id

      puts ""
      puts "Organization ID        => #{id}"
      puts "Organization Name      => #{org_name}"
      puts "Organization Subdomain => #{org_subdomain}"
      puts "Primary Admin Email    => #{admin_email}"
      puts "Number of org keys     => #{org_key_count}"
      puts ""


    end

    return nil

  end

  def self.org_keycount_tests(mode, *org_ids)
    if mode == :run
      run_org_keycount_tests(*org_ids)
    else
      display_org_keycount_tests(*org_ids)
    end
  end

  def self.display_org_keycount_tests(*org_ids)
    puts "Test key counts for organization(s) with:".bold
    org_ids.each do |id|
      puts "TestRunner.new.key_count( :home_url => '#{SESSION_BASEURL}/', :admin_email => '#{get_org_admin_email(id)}', :org_id => #{id} )"
    end
    puts ""
  end

  def self.run_org_keycount_tests(*org_ids)
    org_ids.each do |id|
      TestRunner.new.key_count( :home_url => 'http://f.scitent.us/', :admin_email => get_org_admin_email(id), :org_id => id )
    end
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

  def self.doubled_groups?(*org_ids)
    org_ids.each do |id|
      groups           = []
      group_count      = Hash.new(0)
      duplicate_groups = []

      # get all groups for the org into 'set', if any one cannot be entered into set, put it in an arry of 'dupe groups'
      DB_CLIENT.query("SELECT * FROM scidea_key_groups WHERE organization_id=#{id}").each do |row|
        groups << row['name']
      end

      groups.each { |e| group_count[e] += 1 }

      duplicate_groups_selection = group_count.select { |group, count| count > 1 }
      duplicate_groups_selection.each { |group, count| duplicate_groups << group }

      if duplicate_groups.empty?
        puts ""
        puts "There are no duplicate groups in ORG #{id}"
        puts ""
      else
        puts ""
        puts "Here are the duplicate groups in ORG #{id}: \n#{duplicate_groups}"
        puts ""
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

