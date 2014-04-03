class TestRunner

  def organization_initial_information_sweep(views, org_ids)
    org_ids.each do |org|
      OrganizationDetails.organization_information(views, [org])
      OrganizationDetails.admins_with_organization_access(views, [org])
    end
    # send email to oksana, eric, laurent
  end

  def organization_checks(views, org_ids)
    org_ids.each do |org|
      OrganizationDetails.all_org_key_users_exist?(views, [org])
      OrganizationDetails.duplicate_course_records?(views, [org])
      OrganizationDetails.doubled_groups?(views, [org])
    end
  end

  def organization_key_counts(views, org_ids)
    org_ids.each do |org|
      OrganizationDetails.organization_key_counts(views, [org])
    end
  end

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
          OrganizationDetails.organization_information(views, [org])
          OrganizationDetails.admins_with_organization_access(views, [org])
          OrganizationDetails.organization_key_counts(views, [org])
          OrganizationDetails.all_org_key_users_exist?(views, [org])
          OrganizationDetails.duplicate_course_records?(views, [org])
          OrganizationDetails.doubled_groups?(views, [org])
        end
      end
    end
    return nil #clean final return
  end




  ## MOVE THIS TO THE PROPER PLACE  #############################
  def sco_record_verification( params = {} )
    Tach.meter do
      tach('sco_record_verification') do
        # can be PER USER or array of users (by email, key)
        t = Tester.new(params[:home_url])
        t.visit_home_url
        t.login_type_selector(params)
        t.prepare_to_gather_status_scidea(params[:key_code])
        # [opt] status from user UI
        # [opt] status from OKM key state
        t.logout
        t.prepare_to_gather_status_legacy(params[:key_code])
        t.compare_sco_records_selector(params)
      end
    end
    return nil #clean final return
  end
  ################################################################

end
