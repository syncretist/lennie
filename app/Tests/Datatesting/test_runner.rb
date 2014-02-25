class TestRunner

  def preliminary_organization_information(views, org_ids)
    # views => [], [:cli], [:cli, :post], etc...
    # org_ids => [12, 13, ...]
    Tach.meter do
      tach('preliminary-organization-information') do
        ## begin test instructions header ##
        puts ""
        puts "\nYou can run these again a la carte with:\n\nOrganizationDetails.organization_information\nOrganizationDetails.admins_with_organization_access\netc..."
        #TODO replace this header and have optional args to choose which to run-- first thing is question to pick which tests to run, blank for all
        ## end test instructions header ##
        org_ids.each do |org|
          #OrganizationDetails.organization_information(views, [org])
          #OrganizationDetails.admins_with_organization_access(views, [org])
          OrganizationDetails.organization_key_counts(views, [org])
          #OrganizationDetails.all_org_key_users_exist?(views, [org])
          #OrganizationDetails.duplicate_course_records?(views, [org])
          #OrganizationDetails.doubled_groups?(views, [org])
        end
      end
    end
    return nil #clean final return
  end
end