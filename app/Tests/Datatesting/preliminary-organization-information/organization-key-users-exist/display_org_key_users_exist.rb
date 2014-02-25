require_relative '../organization_details'

OrganizationDetails.class_eval do
  def self.cli_display_org_key_users_exist(test_name, result)
    result.each do |org_id, org_detail|
      cli_display_org_key_users_exist_per_org(org_id, org_detail)
    end
  end

  def self.cli_display_org_key_users_exist_per_org(org_id, org_detail)
    puts ""

    puts "For ORG #{org_id}:"
    puts "The following users (by email) have not been migrated over properly: \n#{org_detail[:missing_emails]}" if org_detail[:missing_emails].length > 0
    puts "The following users (by id) have not been migrated over properly: \n#{org_detail[:missing_ids]}" if org_detail[:missing_ids].length > 0
    puts "* All users have been properly migrated over!" if org_detail[:missing_emails].empty? && org_detail[:missing_ids].empty?
    puts ""
  end

  def self.post_display_org_key_users_exist(test_name, result)
    p = StatusPoster.new

    result.each do |org_id, org_detail|
      p.post(POST_URIS['the-migrator'], { :organization_id => org_id, :test_name => test_name, :test_results => org_detail.to_json })
    end
  end
end