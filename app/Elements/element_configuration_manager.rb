module ElementConfigurationManager

require 'yaml'

AHA_USERS   = YAML.load_file('./app/Elements/Onlineaha/element_configuration/users.yml')
AHA_COURSES = YAML.load_file('./app/Elements/Onlineaha/element_configuration/courses.yml')

end

include ElementConfigurationManager