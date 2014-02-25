## GET ALL DB HITS IN METHODS HERE -- so they are not scattered through the code base
## doing the same thing with capybara in the 'tester.rb

class Database

  def self.get_admin_emails_with_access_to_organization(org_id)
    admins = []

    DB_CLIENT.query("SELECT scidea_users.email FROM scidea_role_users LEFT JOIN scidea_users ON scidea_role_users.user_id=scidea_users.id LEFT JOIN scidea_organization_role_users ON scidea_role_users.id=scidea_organization_role_users.role_user_id WHERE scidea_organization_role_users.organization_id = #{org_id}").each do |row|
      admins << row['email']
    end

    return admins
  end

end