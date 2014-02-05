** lennie **
************

  ```"Where we goin', George?"```

## Philosophy
  * Role of the test suite
    * http://www.satisfice.com/blog/archives/58
  * Use of page objects to have objects as entities at a higher level that can have thier details swapped out when fragile changes occur
    * http://www.cheezyworld.com/2011/07/29/introducing-page-object-gem/
    * http://watirmelon.com/2012/06/04/roll-your-own-page-objects/
  * http://watirmelon.com/2011/12/03/a-tale-of-three-ruby-automated-testing-apis-redux/


## Installation
```git clone <>```
```bundle install``` *(from root of the project)*

## Interactive mode

#### added to `/home/qa-eric/.bash_aliases` for quick startup with ```lennie``` at bash

```
function start-lennie(){
echo -e "\n"
echo -e " \e[00;31mlennie\e[00m : QUICK DOC"
echo -e ""
echo -e "==== One offs ===="
echo -e ""
echo -e "== Login as SA =="
echo -e "Tester.new.standard_login(SECURE_INFO[:sa_email], SECURE_INFO[:sa_password])"
echo -e ""
echo -e "==== Tasks ===="
echo -e ""
echo -e "== Key count tests (with standard user login and with become) =="
echo -e "TestRunner.new.key_count( :home_url => 'http://f.scitent.us/', :admin_email => 'okmtester2@dispostable.com', :admin_password => 'password', :org_id => 12)"
echo -e "TestRunner.new.key_count( :home_url => 'http://f.scitent.us/', :admin_email => 'pierson.shelby@mayo.edu', :org_id => 981 )"
echo -e ""
echo -e "== Sco record tests =="
echo -e "TestRunner.new.sco_record_verification( :home_url => 'http://f.scitent.us/', :admin_email => 'pierson.shelby@mayo.edu', :key_code => '0ED5A98C69A7') # BLS HCP"
echo -e "TestRunner.new.sco_record_verification( :home_url => 'http://f.scitent.us/', :admin_email => 'pierson.shelby@mayo.edu', :key_code => 'CEC80561D744') # ACLS"
echo -e ""
rvm use 1.9.3-p0@integration-suite
pry -r ./lib/startup
}

alias  lennie='cd ~/code/lennie && start-lennie'
```

#### To run manually directives for quick startup

```cd ~/code/lennie/ && pry```
```Dir["./config/config.rb", "./app/tempactions.rb"].each {|file| require file }; include Configuration::Temptest```

1. GO TO DIR FOR RVM SWITCH                         => cd ~/code/lennie/
2. START PRY                                        => pry
3. LOAD IN CONFIG MODULES                           => Dir["./config.rb"].each {|file| require file }
4. GET INTO TEST SCOPE VIA INTERACTIVE SESSION      => include Configuration::Temptest
5. LOAD TEMP ACTIONS FILE WITH APP CODE             => Dir["./tempactions.rb"].each {|file| require file }
6. RUN TEMP TESTS AS NEEDED                         => TestRunner.new.<name of test>(<params>)

## Resources

#### Gathered Related Links
- http://www.one-tab.com/page/jQszpx-5QAmXfEnZ48WS4Q

#### API References
- https://gist.github.com/egman24/ab9088b47c157d5d8253


## TODO

- make this a git repo
- seperate nested config modules in config directory (base site settings, location of template files..)
- eventually abstract to have all 'data' about sites in template files as hashes or yaml... then single model that initializes with current data
- scraper with nokogiri etc to open page and pull all info and get into form
- AspectOrientedProgramming for screenshots etc? special method that includes screenshots but has hook in the middle to run other code
- credentials etc to get to hidden pages: roles and contexts

## Vernacular

* PAGE OBJECTS: models and controllers, state and behavior on the specific state elements
* LAYOUTS: mixins to pages that has shared elements and functionality