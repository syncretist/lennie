# encoding: utf-8
# Need to change encoding to handle '®'
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

class Tester
  include UIHelpers

  attr_accessor :home_url

  COURSES = {
      # add enumerated possible completion statuses for course and for sco
      # add elements for special cases, like single sco shares completion between tests, :unlimited_try test, etc...

      "80-1055" => { :course_title=>"",                         :course_type=> :internal, :completion_criteria => [] },
      "80-1480" => { :course_title=>"Acute Stroke Online",                         :course_type=> :internal, :completion_criteria => [] },
      "80-1501" => { :course_title=>"",                         :course_type=> :internal, :completion_criteria => [] },
      "80-1516" => { :course_title=>"",                         :course_type=> :internal, :completion_criteria => [] },
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
      "90-1431" => { :course_title=>"",                         :course_type=> :internal, :completion_criteria => [] },
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
    if current_url == @home_url
      fill_in('user_email', :with => email)
      fill_in('user_password', :with => password)
      click_button('Sign In')
    else
      puts "You are at #{current_url}, you should be at #{@home_url} to sign in!!! I am logging you out, please try again."
      logout
    end
  end

  def become_login(email)
    standard_login(SECURE_INFO[:sa_email], SECURE_INFO[:sa_password])
    visit("#{@home_url}admin/tech_support")
    fill_in('email', :with => email)
    click_button('Find Users')
    # assumes first result is correct!
    visit("#{@home_url}admin/tech_support/user/#{all('td a').first.text}")
    click_link("#{all('a')[5].text}")
    fill_in('reason', :with => 'autotest login')
    click_button("#{all('button')[4].text}")
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

          course_title   = "Course #{scidea_course} [#{COURSES[scidea_course][:course_title]}]"
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

  def compare_sco_records_selector
    marquee_final "Final Sco Record Comparison"

    if @scidea_course_record[:non_active] || @legacy_course_record[:non_active]
      compare_sco_records_unusual
    else
      compare_sco_records_standard
    end

  end

  def compare_sco_records_unusual
    if @scidea_course_record[:non_active] && @legacy_course_record[:non_active]
      puts "#{green_check} This course is not active in either scidea or legacy, it is a properly unused key."
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
    all('div.client_package').each { |div| temp_counts << div.text.gsub(/Part 1|part 1|\d\d-\d+|[a-zA-Z]|[(|)]|:|-|®|\|/, '').lstrip.split(/\s+/) }
    all('div.client_package_alt').each { |div| temp_counts << div.text.gsub(/Part 1|part 1|\d\d-\d+|[a-zA-Z]|[(|)]|:|-|®|\|/, '').lstrip.split(/\s+/) }
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

    binding.pry

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
    visit("#{@home_url}keys")
    gather_key_counts_scidea
  end

  def prepare_to_gather_status_legacy(key_code)
    visit_oksanas_sco_record_interface(key_code)
    gather_status_legacy_type_selector
  end
  
  def prepare_to_gather_status_scidea(key_code)
    setup_user_modal(key_code)
    gather_status_scidea_type_selector
  end
  
  def setup_user_modal(key_code)
    fill_in('q', :with => key_code) # use the key for unique record, email may turn up for many courses
    find('#q').native.send_keys(:return) # click enter to submit

    ## be sure the page has loaded (some of its elements flicker after it loads)
    find('#key_datatable')
    sleep 3 # increase this number (seconds) if intermittent failures continue at the course progress modal
    modal = find('a.btn')  # be double sure the element has loaded on the page by caching it
    
    modal.click # assumes there is only one result
  end

  def visit_home_url
    visit(@home_url)
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
        t.compare_sco_records_selector
      end
    end
    return nil #clean final return
  end
end
