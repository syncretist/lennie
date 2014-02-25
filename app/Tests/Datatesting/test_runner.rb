class TestRunner

  def preliminary_organization_information(*org_ids)
    Tach.meter do
      tach('preliminary-organization-information') do
        ## begin test instructions header ##
        puts ""
        puts "\nYou can run these again a la carte with:\n\nOrganizationDetails.organization_information\nOrganizationDetails.admins_with_organization_access\netc..."
        #TODO remove this header and have optional args to choose which to run, blank is all
        ## end test instructions header ##
        ## begin tests ##
        OrganizationDetails.organization_information([:cli, :post], org_ids)               # [], [:cli], [:cli, :post], etc...
        OrganizationDetails.admins_with_organization_access([:cli, :post], org_ids)
        OrganizationDetails.organization_key_counts([:cli, :post], org_ids)
        #DatabaseAccess.all_org_key_users_exist?(*org_ids)
        OrganizationDetails.duplicate_course_records?([:cli, :post], org_ids)
        OrganizationDetails.doubled_groups?([:cli, :post], org_ids)
        ## end tests ##
      end
    end
    return nil #clean final return
  end
end