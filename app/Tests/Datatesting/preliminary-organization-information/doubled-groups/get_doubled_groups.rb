require_relative '../organization_details'

OrganizationDetails.class_eval do
  def self.get_doubled_groups(org_id)
    {
        :doubled_group_names => get_doubled_group_names(org_id)
    }
  end

  def self.get_doubled_group_names(org_id)
    groups           = []
    group_count      = Hash.new(0)
    doubled_groups = []

    # get all groups for the org into 'set', if any one cannot be entered into set, put it in an arry of 'dupe groups'
    DB_CLIENT.query("SELECT * FROM scidea_key_groups WHERE organization_id=#{org_id}").each do |row|
      groups << row['name']
    end

    groups.each { |e| group_count[e] += 1 }

    duplicate_groups_selection = group_count.select { |group, count| count > 1 }
    duplicate_groups_selection.each { |group, count| doubled_groups << group }

    return doubled_groups
  end
end