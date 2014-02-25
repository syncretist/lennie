require_relative '../organization_details'

OrganizationDetails.class_eval do
  def self.get_org_key_users_exist(org_id)
    key_sample = process_org_key_users_exist(org_id)

    {
        :missing_emails => key_sample[:missing_emails],
        :missing_ids    => key_sample[:missing_ids]
    }
  end

  def self.process_org_key_users_exist(org_id)

    missing_emails = []
    missing_ids    = []

    Database.get_key_sample_per_org(org_id)[org_id][:raw_samples].each do |single_sample|

      # log information
      #puts "ID: #{single_sample[:learner_id]} EMAIL: #{single_sample[:learner_email]}"

      # [skip] sample is an unused key
      if single_sample[:learner_id].nil? && single_sample[:learner_email].nil?
        next
      end

      # [catch] sample with learner id, but no email is an error
      if single_sample[:learner_email].nil? && !single_sample[:learner_id].nil?
        missing_emails << single_sample
        next
      end

      # [catch] sample with learner email, but no id is an error
      if !single_sample[:learner_email].nil? && single_sample[:learner_id].nil?
        missing_ids << single_sample
        next
      end

      # [catch] samples which have no record at all in the scidea database, but have references transferred from legacy
      missing_emails << single_sample if Database.get_user_by_id(single_sample[:learner_id]).empty?
      missing_ids << single_sample if Database.get_user_by_email(single_sample[:learner_email]).empty?
    end

    return { :missing_emails => missing_emails, :missing_ids => missing_ids }
  end
end