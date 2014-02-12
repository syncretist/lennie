class AdminTechsupportUserPage < AbstractPage

  ################
  ## ATTRIBUTES ##
  ################

  def self.route( id )
    "/admin/tech_support/user/#{id}"
  end

  def self.name
    'admin techsupport user page'
  end

  def self.page_elements
    [TechsupportUserHeaderInfo, TechsupportUserGeneralInfo, TechsupportUserInfoNav, TechsupportUserActionsNav, TechsupportUserCourseResults, TechsupportUserPurchasesResults]
  end
end