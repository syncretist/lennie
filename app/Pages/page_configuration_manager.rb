module PageConfigurationManager

  require 'yaml'

  AHA_PAGES   = YAML.load_file('./app/Pages/Onlineaha/page_inventory.yml')

end

include PageConfigurationManager