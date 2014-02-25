require_relative '../organization_details'

OrganizationDetails.class_eval do
  def self.cli_display_admins_with_organization_access(test_name, result)
    result.each do |org_id, org_detail|
      cli_display_admins_with_organization_access_per_org(org_id, org_detail)
    end
  end

  def self.cli_display_admins_with_organization_access_per_org(org_id, org_detail)
    # returns pretty string for testing org info for each org entered

    puts ""

    underline_puts "Admins with email access"
    puts ""
    puts"These emails have admin access to organization #{org_id}:"
    puts ""
    org_detail.each do |admin, results|
      puts "#{results[:admin_email]}"
      puts "Does this user exist in the scidea database: #{results[:is_in_database?]}"
      puts "Can this user log in to access their OKM: #{results[:can_log_in?]}"
      puts ""
    end
  end

  def self.post_display_admins_with_organization_access(test_name, result)
    p = StatusPoster.new

    result.each do |org_id, org_detail|
      p.post(POST_URIS['the-migrator'], { :organization_id => org_id, :test_name => test_name, :test_results => org_detail.to_json })
    end
  end
end