class Browser

  #TODO hold higher abstractions for browser manipulation here? using simple 'visit()' etc...

  ## handle popups
  def self.number_of_open_windows
    page.driver.browser.window_handles.size
  end

  def self.detect_current_window
    page.driver.browser.window_handle
  end

  def self.detect_popup_window
    page.driver.browser.window_handles[1]
  end

  def self.switch_to_window(window)
    page.driver.browser.switch_to.window(window)
  end

  def self.close_window
    # must be switched to window that gets closed, must switch back to available window afterwards
    page.driver.browser.close
  end

  ## handle tabs

end