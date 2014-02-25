require_relative '../organization_details'

OrganizationDetails.class_eval do
  def self.get_duplicate_course_records(org_id)
    {
        :duplicate_course_enrollment_ids => get_duplicate_course_enrollment_ids(org_id)
    }
  end

  def self.get_duplicate_course_enrollment_ids(org_id)
    enrollment_ids = []

    DB_CLIENT.query("SELECT scidea_course_records.enrollment_id, COUNT(*) c FROM scidea_course_records LEFT JOIN scidea_enrollments ON scidea_course_records.enrollment_id=scidea_enrollments.id LEFT JOIN scidea_keys ON scidea_enrollments.key_id=scidea_keys.id  WHERE scidea_keys.consuming_organization_id IN (#{org_id}) GROUP BY enrollment_id HAVING c > 1;").each do |row|
      enrollment_ids << row['enrollment_id']
    end

    return enrollment_ids
  end
end