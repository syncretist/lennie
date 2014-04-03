module ProjectFiles

  ELEMENT_CONFIGURATION_MANAGER = './app/Elements/element_configuration_manager.rb'
  PAGE_CONFIGURATION_MANAGER    = './app/Pages/page_configuration_manager.rb'

  safe_require(ELEMENT_CONFIGURATION_MANAGER) do
    error_puts "NOTE: To properly run this suite:\n\
     * You must have access to the private yml files containing sensitive data @ ./app/Elements/<project>/element_configuration/**\n\
     Send an email to #{PROJECT_INFORMATION[:maintainer_email]} with any questions."
  end

  safe_require(PAGE_CONFIGURATION_MANAGER) do
    error_puts "NOTE: To properly run this suite:\n\
     * You must have access to the private yml files containing sensitive data @ ./app/Pages/<project>**\n\
     Send an email to #{PROJECT_INFORMATION[:maintainer_email]} with any questions."
  end

end