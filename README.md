** lennie **
************

  ```"Where we goin', George?"```

## Philosophy
  * Role of the test suite within a software development/testing effort
    * http://www.satisfice.com/blog/archives/58
    * http://www.satisfice.com/articles/agileauto-paper.pdf
  * Outside In Testing
    * http://www.youtube.com/watch?v=JDgOuKvRaf4
  * Use of page objects to have objects as entities at a higher level that can have thier details swapped out when fragile changes occur
    * http://www.cheezyworld.com/2011/07/29/introducing-page-object-gem/
    * http://watirmelon.com/2012/06/04/roll-your-own-page-objects/
  * Use of minitest as test runner
    * http://mattsears.com/articles/2011/12/10/minitest-quick-reference
    * http://crashruby.com/2013/05/10/running-a-minitest-suite/
    * http://wojtekmach.pl/blog/2013/07/17/sharing-examples-in-minitest/
    * http://ruby-journal.com/minitest-let-is-lazy/
  * Use of capybara as browser driver
    * http://watirmelon.com/2011/12/03/a-tale-of-three-ruby-automated-testing-apis-redux/
    * http://www.elabs.se/blog/51-simple-tricks-to-clean-up-your-capybara-tests
    * https://blog.jcoglan.com/2012/10/08/terminus-0-4-capybara-for-real-browsers/

## Installation
- ```git clone git@github.com:syncretist/lennie.git```
- setup files that are environment specific (*in gitignore*)
  - ```.rvmrc``` : [reccommended setup](http://sirupsen.com/get-started-right-with-rvm/) for proper use of bash scripts below ```rvm --create --rvmrc 1.9.3-p0@integration-suite```
  - ```./app/Elements/<project>/element_configuration/**.yml``` : sensitive information per project that cannot be publicly shared, must be manually setup in each environment (see Eric for structure if necessary)
  - ```./config/database.rb``` : database configuration
- may need to handle some environment specific dependencies from gems used
  - [mysql2](https://github.com/brianmario/mysql2#installing)
- ```bundle install``` *(from root of the project)*

## Bash script startup
*for simple access to Interactive mode and Test mode*

- add the following to your `~/.bash_aliases` for quick startup menu with ```lennie``` at bash

```
## lennie ##
############

function interactive-lennie(){
echo -e "\n"
echo -e " \e[00;31mlennie\e[00m : QUICK DOC"
echo -e ""
echo -e "=================="
echo -e "==== \e[1;39;49mOne offs\e[0m ===="
echo -e "=================="
echo -e ""
echo -e "== \e[1;39;49mLogin as SA\e[0m =="
echo -e "Tester.new.standard_login(AHA_USERS['scitent-admin']['email'], AHA_USERS['scitent-admin']['password'])"
echo -e ""
echo -e "==============="
echo -e "==== \e[1;39;49mTasks\e[0m ===="
echo -e "==============="
echo -e ""
echo -e "== \e[1;39;49mKey count tests\e[0m (with standard user login and with become) =="
echo -e "TestRunner.new.key_count( :home_url => 'http://f.scitent.us/', :admin_email => 'okmtester2@dispostable.com', :admin_password => 'password', :org_id => 12)"
echo -e "TestRunner.new.key_count( :home_url => 'http://f.scitent.us/', :admin_email => 'pierson.shelby@mayo.edu', :org_id => 981 )"
echo -e ""
echo -e "== \e[1;39;49mSco record tests\e[0m =="
echo -e "TestRunner.new.sco_record_verification( :home_url => 'http://f.scitent.us/', :admin_email => 'pierson.shelby@mayo.edu', :key_code => '0ED5A98C69A7') # BLS HCP"
echo -e "TestRunner.new.sco_record_verification( :home_url => 'http://f.scitent.us/', :admin_email => 'pierson.shelby@mayo.edu', :key_code => 'CEC80561D744') # ACLS"
echo -e ""
rvm use 1.9.3-p0@integration-suite
echo -e ""
pry -r ./lib/startup
}

function test-lennie(){
echo -e ""
echo -e " \e[00;31mlennie\e[00m : testrunner"
echo -e ""
echo -e "\e[1;39;49mDocumentation\e[0m"
echo -e ""
echo -e "[\e[1;36;42mcapybara\e[0m] => http://makandracards.com/makandra/1422-capybara-the-missing-api"
echo -e "[\e[1;36;42mminitest\e[0m] => http://mattsears.com/articles/2011/12/10/minitest-quick-reference"
echo -e ""
echo -e "\e[1;39;49mDebug Commands\e[0m"
echo -e ""
echo -e "\e[00;33mfocus\e[0m        'drop this breakpoint before any *it* block and it will only run those tests'"
echo -e "\e[00;33mbinding.pry\e[0m  'drop this breakpoint in any context and a pry debug session will open with access to *next*, *ls*, *cd*, etc...'"
echo -e ""
echo -e "Test files live @ ./app/Tests/**/**.rb"
echo -e "Single test files and/or full test categories can be run by using the menus below..."
echo -e ""
rvm use 1.9.3-p0@integration-suite
echo -e ""
ruby -r './lib/startup' app/Tests/test_manager.rb
}

function edit-lennie(){
echo -e ""
rvm use 1.9.3-p0@integration-suite
echo -e "Opening lennie in an editor..."
miner
echo -e ""
}

function menu-lennie(){
echo -e "\n"
echo -e "Please use the following commands to invoke lennie:"
echo -e ""
echo -e "\e[1;39;47mlennie-t\e[00m : Run automated test suite."
echo -e "\e[1;39;47mlennie-i\e[00m : Work within interactive mode."
echo -e "\e[1;39;47mlennie-e\e[00m : Open lennie in editor."
echo -e ""
}

alias  lennie='menu-lennie'
alias lennie-t='cd ~/code/lennie && test-lennie'
alias lennie-i='cd ~/code/lennie && interactive-lennie'
alias lennie-e='cd ~/code/lennie && edit-lennie'
```

- to run everything manually, here are some directives for quick startup

**Interactive Mode**

1. GO TO DIR FOR RVM SWITCH                                                      => ```cd ~/code/lennie/```
2. LOAD IN ALL CONFIGURATION AND HAND OFF TO PRY TO BEGIN                        => ```pry -r ./lib/startup_interactive```
3. RUN ACTIONS AS NEEDED                                                         => ```TestRunner.new.<name of test>(<params>)```

**Test Mode**

1. GO TO DIR FOR RVM SWITCH                                                      => ```cd ~/code/lennie/```
2. LOAD IN ALL CONFIGURATION AND HAND OFF TO TEST MANAGER TO BEGIN               => ```ruby -r './lib/startup_tests' app/Tests/test_manager.rb```

## API Documentation

#### TODO: link to docs and images @ /doc

#### Page
- ```.go``` : *navigates browser to the selected page*
- ```.is_current_page?``` : *lets tester know if the Page is the current browser context*

## Key Concepts

- Run in *test* mode to verify integrity or in *interactive* mode to experiment with capybara elements and context directly through pry.
- Page Object, Page Element, Element Inventory

## General Architecture

![lennie-architecture-20140221180555](https://raw.github.com/syncretist/lennie/master/doc/lennie-architecture-20140221180555.gif)

## Vernacular

* PAGE OBJECTS: aggregated state and behavior for each page in the application
* PAGE ELEMENTS: 'mixins' to pages that have shared elements and functionality
* ELEMENTS: aspects of the application to be modeled for reuse (ex. User, SCORM package, Course, Browser)

## Resources

#### Gathered Related Links
- http://www.one-tab.com/page/jQszpx-5QAmXfEnZ48WS4Q

#### Capybara API References
- https://gist.github.com/egman24/ab9088b47c157d5d8253

## To Do

- gitignore and seperate project specific files and configs, have each suite nameable when cloning to project, then add specific, include templates for what files 'should' look like
- seperate nested config modules in config directory (base site settings, location of template files..)
- eventually abstract to have all specific 'data' about sites in template files as hashes or yaml... then single model that initializes with current data
- scraper with nokogiri etc to open page and pull all info and get into form
- AspectOrientedProgramming for screenshots etc? special method that includes screenshots but has hook in the middle to run other code
- credentials etc to get to hidden pages: roles and contexts
