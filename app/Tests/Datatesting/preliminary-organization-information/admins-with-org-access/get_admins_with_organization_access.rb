require_relative '../organization_details'

OrganizationDetails.class_eval do

  def self.get_admins_with_organization_access(org_id)
    process_each_admin(org_id)
  end

  def self.process_each_admin(org_id)
    result = { }
    admins = get_admin_emails_with_access(org_id)
    admins.each do |admin|
      result[admin] = {}
      result[admin][:admin_email]     = admin
      result[admin][:is_in_database?] = is_in_database? admin
      result[admin][:can_log_in?]     = can_log_in? admin
    end

    return result
  end

  def self.get_admin_emails_with_access(org_id)
    return Database.get_admin_emails_with_access_to_organization(org_id)
  end

  def self.is_in_database?(admin)
    DB_CLIENT.query("SELECT * FROM scidea_users where email='#{admin}'").each do |row|
      return row.empty? ? 'no' : 'yes'
    end
  end

  def self.can_log_in?(admin)
    begin
      t = Tester.new(SESSION_BASEURL + "/")
      t.visit_home_url
      t.login_type_selector(:admin_email => admin)
      if has_text? "Online Key Manager"
        t.logout
        return 'yes'
      else
        t.logout
        return 'no'
      end
    rescue Capybara::ElementNotFound
      #try to stop capybara failure from killing the test, also capture timeouts as well as element not found
    end
  end
end