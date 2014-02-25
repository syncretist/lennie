class OrganizationDetails
  extend UIHelpers

  def self.organization_information(display, org_ids)
    result = { :organization_information => {} }

    org_ids.each do |org_id|

      # collects the data
      result[:organization_information][org_id] = get_organization_information(org_id)
      result_for_org = { org_id => result[:organization_information][org_id] }
      test_name = result.keys.first.to_s

      # display in various formats; abstract this to reuseable lambda method, try to run it in a different thread
      cli_display_organization_information(test_name, result_for_org)  if display.member?  :cli
      post_display_organization_information(test_name, result_for_org) if display.member?  :post
      csv_display_organization_information(test_name, result_for_org)  if display.member?  :csv
      raw_display_organization_information(test_name, result_for_org)  if display.member? :raw

    end

    # returns the data
    result
  end

  def self.admins_with_organization_access(display, org_ids)
    result = { :admins_with_organization_access => {} }


    org_ids.each do |org_id|

      # collects the data
      result[:admins_with_organization_access][org_id] = get_admins_with_organization_access(org_id)
      result_for_org = { org_id => result[:admins_with_organization_access][org_id] }
      test_name = result.keys.first.to_s

      # display in various formats; abstract this to reuseable lambda method, try to run it in a different thread
      cli_display_admins_with_organization_access(test_name, result_for_org)  if display.member?  :cli
      post_display_admins_with_organization_access(test_name, result_for_org) if display.member?  :post
      csv_display_admins_with_organization_access(test_name, result_for_org)  if display.member?  :csv
      raw_display_admins_with_organization_access(test_name, result_for_org)  if display.member? :raw

    end

    # returns the data
    result
  end

  def self.doubled_groups?(display, org_ids)
    result = { :doubled_groups? => {} }

    org_ids.each do |org_id|

      # collects the data
      result[:doubled_groups?][org_id] = get_doubled_groups(org_id)
      result_for_org = { org_id => result[:doubled_groups?][org_id] }
      test_name = result.keys.first.to_s

      # display in various formats; abstract this to reuseable lambda method, try to run it in a different thread
      cli_display_doubled_groups(test_name, result_for_org)  if display.member?  :cli
      post_display_doubled_groups(test_name, result_for_org) if display.member?  :post
      csv_display_doubled_groups(test_name, result_for_org)  if display.member?  :csv
      raw_display_doubled_groups(test_name, result_for_org)  if display.member? :raw

    end

    # returns the data
    result
  end

  def self.duplicate_course_records?(display, org_ids)
    result = { :duplicate_course_records? => {} }

    org_ids.each do |org_id|

      # collects the data
      result[:duplicate_course_records?][org_id] = get_duplicate_course_records(org_id)
      result_for_org = { org_id => result[:duplicate_course_records?][org_id] }
      test_name = result.keys.first.to_s

      # display in various formats; abstract this to reuseable lambda method, try to run it in a different thread
      cli_display_duplicate_course_records(test_name, result_for_org)  if display.member?  :cli
      post_display_duplicate_course_records(test_name, result_for_org) if display.member?  :post
      csv_display_duplicate_course_records(test_name, result_for_org)  if display.member?  :csv
      raw_display_duplicate_course_records(test_name, result_for_org)  if display.member? :raw

    end

    # returns the data
    result
  end

  def self.all_org_key_users_exist?(display, org_ids)
    result = { :all_org_key_users_exist? => {} }

    org_ids.each do |org_id|

      # data collection messaging
      loading_message_for_data_collection "Preparing key sample, this could take quite a while, please be patient while data is collected..."

      # collects the data
      result[:all_org_key_users_exist?][org_id] = get_org_key_users_exist(org_id)
      result_for_org = { org_id => result[:all_org_key_users_exist?][org_id] }
      test_name = result.keys.first.to_s

      # display in various formats; abstract this to reuseable lambda method, try to run it in a different thread
      cli_display_org_key_users_exist(test_name, result_for_org)  if display.member?  :cli
      post_display_org_key_users_exist(test_name, result_for_org) if display.member?  :post
      csv_display_org_key_users_exist(test_name, result_for_org)  if display.member?  :csv
      raw_display_org_key_users_exist(test_name, result_for_org)  if display.member? :raw

    end

    # returns the data
    result
  end

  def self.organization_key_counts(display, org_ids)
    result = { :organization_key_counts => {} }

    org_ids.each do |org_id|

      # collects the data
      result[:organization_key_counts][org_id] = get_organization_key_counts(org_id)
      result_for_org = { org_id => result[:organization_key_counts][org_id] }
      test_name = result.keys.first.to_s

      # display in various formats; abstract this to reuseable lambda method, try to run it in a different thread
      cli_display_organization_key_counts(test_name, result_for_org)  if display.member?  :cli
      post_display_organization_key_counts(test_name, result_for_org) if display.member?  :post
      csv_display_organization_key_counts(test_name, result_for_org)  if display.member?  :csv
      raw_display_organization_key_counts(test_name, result_for_org)  if display.member? :raw

    end

    # returns the data
    result
  end
end