require_relative '../organization_details'

OrganizationDetails.class_eval do
  def self.cli_display_doubled_groups(result)
    result[:doubled_groups?].each do |org_id, org_detail|
      cli_display_doubled_groups_per_org(org_id, org_detail)
    end
  end

  def self.cli_display_doubled_groups_per_org(org_id, org_detail)
    # returns pretty string for testing org info for each org entered

    puts ""

    underline_puts "Doubled groups"
    puts ""

    if org_detail[:doubled_group_names].empty?
      puts ""
      puts "There are no doubled groups in ORG #{org_id}"
      puts ""
    else
      puts ""
      puts "Here are the doubled groups in ORG #{org_id}: \n#{org_detail[:doubled_group_names]}"
      puts ""
    end

    puts ""
  end

  def self.post_display_doubled_groups(result)
    p = StatusPoster.new

    test_name = result.keys[0].to_s

    result[:doubled_groups?].each do |org_id, org_detail|
      p.post(POST_URIS['the-migrator'], { :organization_id => org_id, :test_name => test_name, :test_results => org_detail })
    end
  end
end