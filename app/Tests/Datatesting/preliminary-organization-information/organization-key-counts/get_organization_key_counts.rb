require_relative '../organization_details'

OrganizationDetails.class_eval do
  def self.get_organization_key_counts(org_id)
    counts = prepare_organization_key_counts(org_id)

    {
        :scidea_courses                         => counts[:scidea_count],
        :legacy_courses                         => counts[:legacy_count],
        :number_of_courses_scidea               => get_number_of_courses_scidea(counts),
        :number_of_courses_legacy               => get_number_of_courses_legacy(counts),
        :discrepancy_between_numbers_of_courses => get_discrepancy_between_numbers_of_courses(counts),
        :course_key_count_comparisons           => compare_key_counts(counts)

    }
  end

  def self.prepare_organization_key_counts(org_id)
    t           = Tester.new(SESSION_BASEURL + "/")
    admin_email = Database.get_admin_emails_with_access_to_organization(org_id).last # handle case of this being empty

    t.visit_home_url
    t.login_type_selector( { :admin_email => admin_email } )
    scidea_count = t.prepare_to_gather_key_counts_scidea
    t.logout
    legacy_count = t.prepare_to_gather_key_counts_legacy(org_id)
    return { :scidea_count => scidea_count, :legacy_count => legacy_count }
  end

  def self.get_number_of_courses_scidea(counts)
    counts[:scidea_count].size
  end

  def self.get_number_of_courses_legacy(counts)
    counts[:legacy_count].size
  end

  def self.get_discrepancy_between_numbers_of_courses(counts)
    (counts[:scidea_count].size - counts[:legacy_count].size).abs
  end

  def self.compare_key_counts(counts)
    final_result = []

    # use HASH.has_value? to compare instead of iterate in both methods?
    counts[:scidea_count].each_with_index do |scidea_course, i|

      course_result = {}

      scidea_course_id = scidea_course[:course_id]
      scidea_counts    = scidea_course[:key_counts]

      #TODO fix cases where there are different numbers of courses, and legacy blows up here
      legacy_course_id = counts[:legacy_count][i][:course_id]
      legacy_counts    = counts[:legacy_count][i][:key_counts]

      course_result[:course_id]    = scidea_course_id
      course_result[:course_title] = AhaCourses.get_course_name_by_course_id(scidea_course_id)

      if scidea_course_id == legacy_course_id

        course_result[:course_count_differences] = {}

        course_result[:course_count_differences][:keys_total]       = course_count_differences(scidea_counts[:total_keys],     legacy_counts[:total_keys])
        course_result[:course_count_differences][:keys_used]        = course_count_differences(scidea_counts[:used_keys],      legacy_counts[:used_keys])
        course_result[:course_count_differences][:keys_available]   = course_count_differences(scidea_counts[:available_keys], legacy_counts[:available_keys])
        course_result[:course_count_differences][:keys_assigned]    = course_count_differences(scidea_counts[:assigned_keys],  legacy_counts[:assigned_keys])
        course_result[:course_count_differences][:keys_in_progress] = course_count_differences(scidea_counts[:in_progress],    legacy_counts[:in_progress])
        course_result[:course_count_differences][:keys_completed]   = course_count_differences(scidea_counts[:completed],      legacy_counts[:completed])
        course_result[:course_count_differences][:keys_failed]      = course_count_differences(scidea_counts[:failed],         legacy_counts[:failed])
        course_result[:course_count_differences][:keys_archived]    = course_count_differences(scidea_counts[:archived],       legacy_counts[:archived])

      else
        course_result[:course_count_differences] = 'Course IDs do not match.'
      end

      final_result << course_result
    end

    return final_result

  end

  def self.course_count_differences(scidea_number, legacy_number)
    scidea = scidea_number.to_i
    legacy = legacy_number.to_i

    #TODO refactor to only send number as second value make it a hash with clear names and then add the sentences to the view

    if scidea > legacy
      return [:greater, "scidea greater than legacy by #{scidea - legacy}"]
    elsif scidea < legacy
      return [:lessthan, "scidea less than legacy by #{legacy - scidea}"]
    else
      return [:equal, "equal count"]
    end
  end
end