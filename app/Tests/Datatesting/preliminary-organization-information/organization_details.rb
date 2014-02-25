class OrganizationDetails
  extend UIHelpers

  def self.organization_information(display, org_ids)
    result = { :organization_information => {} }

    # collects the data
    org_ids.each do |org_id|
      result[:organization_information][org_id] = get_organization_information(org_id)
    end

    # display in various formats; abstract this to reuseable lambda method, try to run it in a different thread
    cli_display_organization_information(result)  if display.member?  :cli
    post_display_organization_information(result) if display.member?  :post
    csv_display_organization_information(result)  if display.member?  :csv
    raw_display_organization_information(result)  if display.member? :raw

    # returns the data
    result
  end

  def self.admins_with_organization_access(display, org_ids)
    result = { :admins_with_organization_access => {} }

    # collects the data
    org_ids.each do |org_id|
      result[:admins_with_organization_access][org_id] = get_admins_with_organization_access(org_id)
    end

    # display in various formats; abstract this to reuseable lambda method, try to run it in a different thread
    cli_display_admins_with_organization_access(result)  if display.member?  :cli
    post_display_admins_with_organization_access(result) if display.member?  :post
    csv_display_admins_with_organization_access(result)  if display.member?  :csv
    raw_display_admins_with_organization_access(result)  if display.member? :raw

    # returns the data
    result
  end

  def self.doubled_groups?(display, org_ids)
    result = { :doubled_groups? => {} }

    # collects the data
    org_ids.each do |org_id|
      result[:doubled_groups?][org_id] = get_doubled_groups(org_id)
    end

    # display in various formats; abstract this to reuseable lambda method, try to run it in a different thread
    cli_display_doubled_groups(result)  if display.member?  :cli
    post_display_doubled_groups(result) if display.member?  :post
    csv_display_doubled_groups(result)  if display.member?  :csv
    raw_display_doubled_groups(result)  if display.member? :raw

    # returns the data
    result
  end

  def self.duplicate_course_records?(display, org_ids)
    result = { :duplicate_course_records? => {} }

    # collects the data
    org_ids.each do |org_id|
      result[:duplicate_course_records?][org_id] = get_duplicate_course_records(org_id)
    end

    # display in various formats; abstract this to reuseable lambda method, try to run it in a different thread
    cli_display_duplicate_course_records(result)  if display.member?  :cli
    post_display_duplicate_course_records(result) if display.member?  :post
    csv_display_duplicate_course_records(result)  if display.member?  :csv
    raw_display_duplicate_course_records(result)  if display.member? :raw

    # returns the data
    result
  end

  def self.organization_key_counts(display, org_ids)
    result = { :organization_key_counts => {} }

    # collects the data
    org_ids.each do |org_id|
      result[:organization_key_counts][org_id] = get_organization_key_counts(org_id)
    end

    # display in various formats; abstract this to reuseable lambda method, try to run it in a different thread
    cli_display_organization_key_counts(result)  if display.member?  :cli
    post_display_organization_key_counts(result) if display.member?  :post
    csv_display_organization_key_counts(result)  if display.member?  :csv
    raw_display_organization_key_counts(result)  if display.member? :raw

    # returns the data
    result
  end
end