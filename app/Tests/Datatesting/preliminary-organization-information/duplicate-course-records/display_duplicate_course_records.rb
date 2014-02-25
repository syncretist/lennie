require_relative '../organization_details'

OrganizationDetails.class_eval do
  def self.cli_display_duplicate_course_records(test_name, result)
    result.each do |org_id, org_detail|
      cli_display_duplicate_course_records_per_org(org_id, org_detail)
    end
  end

  def self.cli_display_duplicate_course_records_per_org(org_id, org_detail)
    # returns pretty string for testing org info for each org entered

    puts ""

    underline_puts "Course Record enrollment IDs which are referenced by more than one course record"
    puts ""

    if org_detail[:duplicate_course_enrollment_ids].empty?
      puts "CLEAN: This organization has no associated course records referencing the same enrollment ID more than once."
    else
      puts "These enrollment ids are referenced by more than one course record:"
      org_detail[:duplicate_course_enrollment_ids].each do |enrollment_id|
        puts "#{enrollment_id}"
      end
    end

    puts ""
  end

  def self.post_display_duplicate_course_records(test_name, result)
    p = StatusPoster.new

    result.each do |org_id, org_detail|
      p.post(POST_URIS['the-migrator'], { :organization_id => org_id, :test_name => test_name, :test_results => org_detail.to_json })
    end
  end
end