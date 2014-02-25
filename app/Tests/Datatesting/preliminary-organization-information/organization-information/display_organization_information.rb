require_relative '../organization_details'

OrganizationDetails.class_eval do
  def self.cli_display_organization_information(test_name, result)
    result.each do |org_id, org_detail|
      cli_display_organization_information_per_org(org_detail)
    end
  end

  def self.cli_display_organization_information_per_org(org_detail)
    # returns pretty string for testing org info for each org entered

    puts ""

    underline_puts "Organization Information"
    puts ""

    puts "Organization ID        => #{org_detail[:organization_id]}"
    puts "Organization Name      => #{org_detail[:organization_name]}"
    puts "Organization Subdomain => #{org_detail[:subdomain]}"
    puts "Primary Admin Email    => #{org_detail[:primary_admin_email]}"
    puts "Number of org keys     => #{org_detail[:total_key_count]}"
    puts ""
  end

  def self.post_display_organization_information(test_name, result)
    p = StatusPoster.new

    result.each do |org_id, org_detail|
      p.post(POST_URIS['the-migrator'], { :organization_id => org_id, :test_name => test_name, :test_results => org_detail.to_json })
    end
  end
end