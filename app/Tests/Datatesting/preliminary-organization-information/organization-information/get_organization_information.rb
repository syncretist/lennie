require_relative '../organization_details'

OrganizationDetails.class_eval do
  def self.get_organization_information(org_id)
    {
        :organization_id     => org_id,
        :organization_name   => get_organization_name(org_id),
        :primary_admin_email => get_primary_admin_email(org_id),
        :total_key_count     => get_total_key_count(org_id),
        :subdomain           => get_subdomain(org_id)
    }
  end

  def self.get_organization_name(org_id)
    DB_CLIENT.query("SELECT name FROM scidea_organizations WHERE id=#{org_id}").each do |row|
      return row['name']
    end
  end

  def self.get_primary_admin_email(org_id)
    DB_CLIENT.query("SELECT admin_email FROM scidea_organizations WHERE id=#{org_id}").each do |row|
      return row['admin_email']
    end
  end

  def self.get_total_key_count(org_id)
    DB_CLIENT.query("SELECT COUNT(*) FROM scidea_keys WHERE consuming_organization_id=#{org_id}").each do |row|
      return row['COUNT(*)']
    end
  end

  def self.get_subdomain(org_id)
    DB_CLIENT.query("SELECT subdomain FROM scidea_organizations WHERE id=#{org_id}").each do |row|
      return row['subdomain']
    end
  end
end




