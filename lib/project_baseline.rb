#############################
##  low level dependencies ##
#############################

require 'rake'
require 'yaml'

############################################
## global, project-wide low level helpers ##
############################################

module ProjectBaseline

  PROJECT_INFORMATION = {
      :maintainer_email => 'eglassman@scitent.com'
  }

  def error_puts(message)
    $stderr.puts message
  end

  def logging_puts(message)
    puts message
  end

  def safe_require(dependency, &instructional_message)
    begin
      require dependency
    rescue LoadError
      if block_given?
        yield
      else
        error_puts "Could not find #{dependency} to require it..."
      end
    end
  end

  def safe_yaml_load(dependency, &instructional_message)
    begin
      YAML.load_file(dependency)
    rescue Errno::ENOENT
      if block_given?
        yield
      else
        error_puts "Could not find #{dependency} to load it..."
      end
    end
  end



end

include ProjectBaseline