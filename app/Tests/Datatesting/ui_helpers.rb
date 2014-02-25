# encoding: utf-8
# Need to change encoding to handle '®', '✔', '✘'
# http://stackoverflow.com/questions/1739836/invalid-multibyte-char-us-ascii-with-rails-and-ruby-1-9
# http://stackoverflow.com/questions/3678172/ruby-1-9-invalid-multibyte-char-us-ascii
# http://www.stefanwille.com/2010/08/ruby-on-rails-fix-for-invalid-multibyte-char-us-ascii/

module UIHelpers
  def green_check
    # should be called within a double quoted string as "#{green_check} "...
    return "[ " + "✔".green + " ]"
  end
  def red_x
    # should be called within a double quoted string as "#{red_x} "...
    return "[ " + "✘".red + " ]"
  end
  def marquee_raw(text)

    marquee_general(:text             => text,
                    :text_color       => :red,
                    :background_color => :on_blue,
                    :emphasis         => :bold,
                    :table_width      => 70,
                    #:padding_left     => 3,
                    :border_x         => "*",
                    :border_i         => "*")

  end
  def marquee_intermediate(text)

    marquee_general(:text             => text,
                    :text_color       => :blue,
                    :background_color => :on_white,
                    :emphasis         => :bold,
                    :table_width      => 30,
                    #:padding_left     => 3,
                    :border_x         => "-",
                    :border_i         => "|")

  end
  def marquee_final(text)

    marquee_general(:text             => text,
                    :text_color       => :yellow,
                    :background_color => :on_green,
                    :emphasis         => :bold,
                    :table_width      => 70,
                    #:padding_left     => 3,
                    :border_x         => "=",
                    :border_i         => "x")
  end
  def marquee_general( params = {} )

    # beware, table widths manually set under 40 appear to be causing error, maybe something else caused this?
    # NameError: undefined local variable or method `wanted' for #<Terminal::Table:0x9cf6e54>

    rows    = []
    content = []

    content << params[:text].send(params[:text_color]).send(params[:background_color]).send(params[:emphasis])
    rows << content

    marquee = Terminal::Table.new :rows => rows
    marquee.style = {:width => params[:table_width], :padding_left => 3, :border_x => params[:border_x], :border_i => params[:border_i]}

    puts ""
    puts ""
    puts marquee
    puts ""

  end
  def table_course_record
    # heading and single section
  end
  def table_key_count
    # heading and two sections
  end
  def table_sco_comparison
    # wind and array up
  end
  def table_general( params = {} )

    headings        = []
    content_middle  = []
    rows            = []

    headings        << params[:heading]
    content_middle  << params[:middle_row]
    rows            << content_middle

    table = Terminal::Table.new :headings => headings, :rows => rows

    puts table

  end

  def underline_puts(text)
    underline_size = text.length
    puts text
    underline_size.times { print "-" }
  end
end