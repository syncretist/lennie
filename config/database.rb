## mysql2 gem
## https://github.com/brianmario/mysql2#usage
## final database chosen in Configuration::Testcontext @ ./config/config.rb

module Database
  safe_require 'mysql2'

  DATABASE_INFORMATION = safe_yaml_load('./config/database_secret.yml') do
    error_puts "NOTE: To properly run this suite:\n\
     * The file ./config/database_secret.yml must exist with the properly formatted information.\n\
     Send an email to #{PROJECT_INFORMATION[:maintainer_email]} with any questions."
  end
end

class DatabaseConnection

  def self.connect
    #TODO figure out way to allow for non db use during sessions, and way to connect to local db(s)
    # http://stackoverflow.com/questions/8336090/cant-connect-ruby-on-rails-to-remote-mysql-database
    # http://stackoverflow.com/questions/4103809/how-to-create-a-ssh-tunnel-in-ruby-and-then-connect-to-mysql-server-on-the-remot
    safe_require 'net/ssh/gateway'

    begin

      logging_puts ""
      logging_puts "Connecting to the session database, please be patient..."
      logging_puts ""

      gateway     = Net::SSH::Gateway.new( SESSION_DATABASE['host'], SESSION_DATABASE['username'] )
      local_host  = '127.0.0.1'
      tunnel_port = gateway.open(local_host, 3306)

      @@client = Mysql2::Client.new(
          :connect_timeout => 30, #seconds,
          :encoding => SESSION_DATABASE['encoding'],
          :reconnect => SESSION_DATABASE['reconnect'],
          :database => SESSION_DATABASE['database'],
          :username => SESSION_DATABASE['username'],
          :password => SESSION_DATABASE['password'],
          :host => local_host, # port forward to remote db through net/ssh/gateway,
          :port => tunnel_port
      )
      logging_puts "... database connected!"
      logging_puts ""

      return @@client
    rescue Mysql2::Error
      error_puts "The database was not configured properly, please check all configurations to repair..."
      error_puts ""
    end
  end
end

