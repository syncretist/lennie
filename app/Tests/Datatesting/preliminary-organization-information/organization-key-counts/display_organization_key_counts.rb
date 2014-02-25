require_relative '../organization_details'

OrganizationDetails.class_eval do
  def self.cli_display_organization_key_counts(result)
    result[:organization_key_counts].each do |org_id, org_detail|
      cli_display_organization_key_counts_per_org(org_id, org_detail)
    end
  end

  def self.cli_display_organization_key_counts_per_org(org_id, org_detail)
    # returns pretty string for testing org info for each org entered

    marquee_final "Final Key Count Comparison"

    ## Compare number of courses.
    if org_detail[:discrepancy_between_numbers_of_courses] > 0
      puts "#{red_x} Number of courses in scidea and legacy are off by #{org_detail[:discrepancy_between_numbers_of_courses]}"
    else
      puts "#{green_check} Number of courses in scidea and legacy match."
    end

    puts ""
    puts ""

    ## Compare key counts per course.

    org_detail[:course_key_count_comparisons].each do |course_comparison|
      puts ""
      puts course_comparison[:course_id]
      underline_puts course_comparison[:course_title]
      puts ""

      course_comparison[:course_count_differences].each do |category, result|
        intro = " => For #{category.to_s},"
        count_difference = result[0]
        result_text = result[1]

        if count_difference == :greater
          puts "#{red_x} #{intro} #{result_text}"
        elsif count_difference == :lessthan
          puts "#{red_x} #{intro} #{result_text}"
        elsif count_difference == :equal
          puts "#{green_check} #{intro} #{result_text}"
        else
          puts "?? indeterminate ??"
        end
      end
    end

    puts ""
  end

  def self.post_display_organization_key_counts(result)
    p = StatusPoster.new

    test_name = result.keys[0].to_s

    result[:organization_key_counts].each do |org_id, org_detail|
      p.post(POST_URIS['the-migrator'], { :organization_id => org_id, :test_name => test_name, :test_results => org_detail })
    end
  end
end