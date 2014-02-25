class StatusPoster
  include UIHelpers
  require 'net/http'
  require 'uri'

  #TODO subclass.. and make json specific poster, with converters so that js can get it directly and update in real time
  #TODO get this happening in seperate thread so the tests are not blocked during post

  def post_form_action(uri, message)
    Net::HTTP.post_form(uri, message)
  end

  def post(recipient, message)
    # recipient should be from POST_URIS global config, ex. POST_URIS['the-migrator']
    # message should be hash form { "post_text" => "YEAHA", ...}
    uri = URI.parse(recipient)
    response_logger( post_form_action( uri, message ), uri )
  end

  def response_logger(response, uri)
    #TODO build intellegence to know if it was success or not...
    # Net::HTTPInternalServerError (500)
    # Net::HTTPSeeOther            (redirect after POST, but most likely success)
    # Net::HTTPNotFound            (404)
    # Net::HTTPOK                  (200, success)
    # Errno::ECONNREFUSED: Connection refused - connect(2) (site is not started up, this is error code)

  if response
      puts "POST TO".red + ": " + uri.to_s
      puts "POST STATUS".red + ": " + response.code_type.to_s
      puts ""
    else
      puts "POST TO".red + ": " + uri.to_s
      puts "POST STATUS".red + ": FAILED @ #{now}"
      puts ""
    end
  end
end