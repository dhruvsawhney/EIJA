# Shakespeare Script Editor

This project builds on previous year's work to create a collaborative Shakespeare script editor. Often in theater productions it is useful to be able to cut down a play as they span multiple acts and scenes. At the 5C's, various literature classes reenact Shakespeare plays. In its current state, students suggest edits to these plays via Google Docs. With students (organized into groups) editing multiple plays, it becomes difficult to keep track of the various Google docs. Furthermore, the course instructor, has little control over what is edited and feels removed from the students' work. Our script editing software seeks to address these issues. At a high level, our software provides an environment to edit plays and ensure instructor control over edits made. This makes it easier for the instructor to keep track of changes made by groups. 


## Architecture

### DataBase

All of the data is stored in an SQL database, using SQLite3. The data is organized such that plays and words form the highest and lowest form of data representation. There also exists connections between play data, user data and edits made to the play. All these features come together with our collaboration features that dynamically tracks edits made by a user, either as an individual or as part of a group, making edits to a play.


### Parsing

The following content is taken from the README.md of Team EIJA. We populate our database by parsing through a set of XML files from Folgers using the Nokogiri ruby gem. Our parsing system lives in the seeds.rb file which can be called to fill our database. Given a hardcoded list of file paths to parse through, it moves through the play looping in the following pattern (Acts -> Scenes -> Lines -> Words). Since parsing is only done on every play once, then that data is saved in the database, we haven’t worked at improving runtime performance at all.

### Cutting 

Edits made to the play (as cuts and uncuts to words in the play are executed by tracking the wordID associated for individual words, sending the payload to the server and making the corresponding cuts. In order to improve the runtime of the application, once the page is loaded, edits are made via JQuery’s AJAX, an asynchronous call function. Furthermore, play data is loaded specific to a scene of the play. This improves the overall runtime of the application, as opposed to loading the entire play.


## Prerequisites

Credits to team EIJA for installation guidelines.

The major components that need to be installed are: ruby, ruby bundler, rails and sqlite3


### MAC OSX

Note: Our project has a dependency for the Sessions gem. This gem works with versions less than Ruby 2.5. On our systems, we have Ruby 2.4.1 installed.

Using homebrew (https://brew.sh/) install ruby and rbenv. If you already have a working rails installation you can skip most of these steps just make sure to have installed sqlite3 through brew. Info for this section loving stolen with credit from this awesome guide: https://gorails.com/setup/osx/10.13-high-sierra

1. brew install rbenv ruby-build
2. echo 'if which rbenv > /dev/null; then eval "$(rbenv init -)"; fi' >> ~/.bash_profile source ~/.bash_profile
3. rbenv install 2.4.2
4. rbenv global 2.4.2
5. gem install rails -v 5.1.4
6. rbenv rehash
7. brew install sqlite3


### Gems

Note: Our project has a dependency for the Sessions gem. This gem works with versions less than Ruby 2.5. On our systems, we have Ruby 2.4.1 installed.

Nokogiri: An XML parser that is used to parse the Folger's Shakespeare texts and put the words, scenes, and Ac

Devise: Devise is a gem used to setup user accounts and encrypted logins on the website.

Boostrap-Sass: Bootstrap is a gem that helps set up basic UI elements, primarily the site navigation bar.

sqlite3: Gem that simplifies connection between Ruby on Rails and sqlite3.

Datatables:  Gem for adding tables to the Admin page


### Installation :: 

1. Go to GitHub
2. Git clone https://github.com/dhruvsawhney/EIJA.git
3. Open project in IDE of choice
4. Open terminal and navigate to script_editor directory 
5. Copy “bin/rails db:migrate RAILS_ENV=development” into Terminal and press Enter 
6. Copy “rake db:seed” into Terminal and press Enter 
7. Copy “rails s” into Terminal and press Enter 
8. Copy “http://localhost:3000” url and paste into browser 

### Seeding

Credits to Team EIJA for seeding instructions.

Our project requires parsing the folger’s shakespeare XML which can take quite some time depending on your hardware. We have a testing “demo” mode enabled by default. Follow the steps below to seed the database (with optional step 0 for switching to full deployment mode). If you have more specific needs, head on over to the seeds.rb file in the db/ directory. There you'll find comments about how to seed any subset of the plays manually.

Go into the script_editor/db/ directory and edit the seeds.rb file: Switch fullPlays = false to fullPlays = true If you want to seed all of the plays into the database.

In the script_editor directory enter these commands rails db:migrate

rails db:seed

Wait as the database populates (this should only take a max of 10 minutes if you are seeding the testing play, but upwards for 2 hours for seeding all of the plays.


## Functionality

The functionality for our play can be broken down into three components: user experience, collaborative editing and editing-analytics

### User Experience : User Interface

We have simplified the website design and minimized clicks required to use functionality. The visual quality of a website is fundamental to a positive experience, and minimizing clicks reduces cognitive workload for the user. In this regard, we have modified the two key pages the user interacts with: the homepage and the edits page.

As the user opens the website, one is redirected to the homepage. Once the user is registered, one can then choose plays from Tragedy, Comedy and History and edit the play.


### Collaborative Editing

### 1. Collaboration among students


Edits to a play can be made in one of two ways: either as a stand-alone user or as a member of a group, assigned by the instructor for the course. 

Once the instructor assigns a student to a group, the student can choose from a drop-down menu, the context in which to edit the play. From a technology perspective, steps are taken to ensure that multiple students can edit the play efficiently such that edits made by any-one member of the group are visible to all other members of the group. 


### 2. Admin mode

The instructor for the course, by default, is assigned as the admin. The admin has their own web-page that provides meta-functionality such as: creating groups to edit plays and review all changes made by group members. These features allow the admin to oversee key aspects of script editing. In particular, the admin can review changes made by a group to ensure that lines integral to a play are not accidentally edited. Admin login information is supplied inside the seeds.rb file and should be changed upon login.


## Editing Analytics

### 1. Cue-script

As students are assigned characters in a Shakespeare play, the ability to remember ones lines is of paramount importance. To this end, we have developed a cue-script feature. As opposed to the cumbersome task of sifting through lines of the play and finding the lines relevant to the user's character, this feature seamlessly provides all the lines for the particular character. 

In addition, a cue, in the form of words spoken by previous speakers, allows the user to understand when to speak their lines. This feature can be found by clicking the "Analytics" button, and then pressing the "Cue Script" tab in the pop-up. 

### 2. Lines per character

Often as students edit a play, it is important to know the modified number of lines for a given character. The lines analytics features provides such dynamic insights; lines spoken by all characters are updated as a result of edits made to the play. 



## Known Bugs

Occasionally, when the user mode is switched, a javascript error occurs of the form "invalid id". However, when cuts are made to the play, there are no issues with the core-functionality

Occsionally, the user needs to refresh the edits page (cmd + r) for the editing (cuts and uncuts) to start working.
