==========================================
OpenStack Upstream Institute Class Details
==========================================

Introduction
============

With over 2000 developers from 80 different companies worldwide, OpenStack is
one of the largest collaborative software-development projects. Because of its
size, it is characterized by a huge diversity in social norms and technical
conventions. Attending a live class to get an insight of how the community
operates and to learn about the insights and best practices can significantly
increase the speed at which newcomers are successful at integrating their own
roadmap into that of the OpenStack project.

We've designed a training program to provide an interactive environment to
newcomers where they can learn they ways of collaborating with our community.
We are relying on the principles of open collaboration and describe and show
how the 'Four Opens' work in OpenStack in practice.

The training has a modular structre by which it gives room to attendees with
different job roles.

For example if you are a project or program manager it is very important for
you to understand how the OpenStack releases are structured in order to be able
to plan the roadmap for the product you are responsible for. You might also be
interested in participating in Working Groups to actively participate in and
influence the community in you areas of interest. The training helps you to
find the information entry points you need.

If you are a developer we help you to find your way into the community to get
your bug fix or feature accepted in the OpenStack project in a minimum amount
of time.

The live one and a half day class teaches the students how to navigate the
intricacies of the project's technical tools and social interactions and shows
how they can collaborate with the community and find their place in the
ecosystem.

After the training students have the possibility to sign up for a longer term
mentoring to further stregthen the skills they've learnt during the training.

Objectives
==========

- Understand the OpenStack release cycle to the level of being able to
  sychronize and integrate it with your product's roadmap
- Get to know the technical tools
- Understand the OpenStack contribution workflow and social norms
- Know where to find information, where and how to get help if needed
- Be able to identify and start a task (bug fix, feature design and
  implementation, Working Group activity and so forth)

Target Audience
===============

- Developers/Software Engineers/Architects
- System administrators
- Project/Program managers/Product owners

Prerequisites to attend the class
=================================

- Being able to read and write English at a technical level

Recommendations to become an active community member
====================================================

- For code and/or documentation contributions having at least 40% of your work
  time dedicate to the project, be it through programming or through
  interacting with the community
- For Working Group participation having at least 15-20% of your work time
  allocated for community activities
- If contributing code, being technically proficient enough to carry out
  simple bug fixes in the project
- If contributing documentation, being able to produce documents in the
  project's chosen infrastructure


Duration
========

- Face-to-face section: 1.5 days

Infrastructure
==============

We are providing a virtual machine with the necessary tools pre-installed in
it. For further information about the system requirements on it please see the
`ref: prepare-environment` section.

Course Outline
==============

* Day 1: Introduction
* Day 1: How OpenStack is made
* Day 1: Learn and practice Git, Gerrit, IRC

* Day 2: The theory of contribution
* Day 2: Deep dive sessions

First day
---------

Introduction
~~~~~~~~~~~~

How OpenStack is made (3h including 1h30 exercises)
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

* `Release cycle <https://wiki.openstack.org/wiki/Release_Cycle>`_

  * `Planning (Design, Discuss and Target) <https://wiki.openstack.org/wiki/Release_Cycle#Planning_.28Design.2C_Discuss_and_Target.29>`_
  * `Implementation (Milestone iterations <https://wiki.openstack.org/wiki/Release_Cycle#Implementation_.28Milestone_iterations.29>`_
  * `Pre-release (Release Candidates dance) <https://wiki.openstack.org/wiki/Release_Cycle#Pre-release_.28Release_Candidates_dance.29>`_

    * `Release candidate 1 <https://wiki.openstack.org/wiki/Release_Cycle#Release_candidate_1>`_
    * `Other release candidates <https://wiki.openstack.org/wiki/Release_Cycle#Other_release_candidates>`_
    * `Release day <https://wiki.openstack.org/wiki/Release_Cycle#Release_day>`_

  * Exercise: based on the `Kilo release schedule <https://wiki.openstack.org/wiki/Kilo_Release_Schedule>`_
    find the URL of a document or a patch that belongs to each of the above
    steps.

* Relevant actors

  * `committers <http://www.stackalytics.com/?release=kilo&metric=commits&project_type=integrated&module=&company=&user_id=>`_
    companies
  * `commiters <http://www.stackalytics.com/?release=kilo&metric=commits&project_type=integrated&module=&company=&user_id=>`_
    individuals (bottom of the page)
  * Your management

* `OpenStack Governance <http://governance.openstack.org/>`_

  * `Technical Committee <http://governance.openstack.org/reference/charter.html>`_
  * `The role of the Technical Committee <http://governance.openstack.org/reference/charter.html#mission>`_
  * `OpenStack Project Teams <http://governance.openstack.org/reference/charter.html#openstack-project-teams>`_
  * `OpenStack Project Teams list <http://governance.openstack.org/reference/projects/index.html>`_
  * `Meetings <https://wiki.openstack.org/wiki/Meetings#Technical_Committee_meeting>`_
  * Exercise: read `archived <http://eavesdrop.openstack.org/meetings/tc/2014/tc.2014-04-01-20.03.log.html>`_
    and briefly comment on `keystone document <https://etherpad.openstack.org/p/keystone-incubation-integration-requirements>`_
  * `PTLs <http://governance.openstack.org/reference/charter.html#project-team-leads>`_
  * `APC <http://governance.openstack.org/reference/charter.html#voters-for-ptl-seats-apc>`_
  * `ATC <http://governance.openstack.org/reference/charter.html#voters-for-tc-seats-atc>`_
  * Exercise: each APC / ATC in the class add a URL to the etherpad proving it

* `"Big Tent" and tags <http://governance.openstack.org/reference/new-projects-requirements.html>`_

  * `OpenStack Project Teams <http://governance.openstack.org/reference/projects/index.html>`__
  * `List of approved tags <http://governance.openstack.org/reference/tags/index.html>`_
  * `Understanding the DefCore Guidelines <https://git.openstack.org/cgit/openstack/defcore>`_
  * `Core Definition <https://git.openstack.org/cgit/openstack/defcore/plain/doc/source/process/CoreDefinition.rst>`_
  * `How to create a project <http://docs.openstack.org/infra/manual/creators.html>`_
  * Exercise: What kind of Program do you contribute to ?

* `Design summits <https://wiki.openstack.org/wiki/Design_Summit>`_

  * `Propose sessions <https://wiki.openstack.org/wiki/Design_Summit/Planning>`_
  * `List of sessions <https://libertydesignsummit.sched.org/overview/type/design+summit#.VVeYTt-uNNw>`_
  * `Liberty Summit Etherpads <https://wiki.openstack.org/wiki/Design_Summit/Liberty/Etherpads>`_
  * Exercise: Add a session proposal regarding your contribution in an
    etherpad, review two proposals

* `IRC meetings <https://wiki.openstack.org/wiki/Meetings>`_

  * `IRC Services <http://docs.openstack.org/infra/system-config/irc.html>`_
  * `meetbot <http://wiki.debian.org/MeetBot>`_
  * `OpenStack IRC channels <https://wiki.openstack.org/wiki/IRC>`_
  * `IRC Logs <http://eavesdrop.openstack.org/irclogs/>`_
  * ``#info`` - Add an info item to the minutes. People should liberally use
    this for important things they say, so that they can be logged in the
    minutes.
  * ``#action`` - Document an action item in the minutes. Include any
    nicknames in the line, and the item will be assigned to them. (nicknames
    are case-sensitive)
  * ``#help`` - Add a "Call for Help" to the minutes. Use this command when
    you need to recruit someone to do a task. (Counter-intuitively, this
    doesn't provide help on the bot)
  * Exercise: lunch menu online meeting

Workflow of an OpenStack contribution and tools (3h including 2h exercises)
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

* `DevStack <http://docs.openstack.org/developer/devstack/>`_

  * Ubuntu or Fedora
  * ``git clone https://git.openstack.org/openstack-dev/devstack``
  * `minimal configuration <http://docs.openstack.org/developer/devstack/configuration.html#minimal-configuration>`_
  * ``cd devstack; ./stack.sh``
  * Exercise: get the code for the targeted contribution

* `How_To_Contribute URL <https://wiki.openstack.org/wiki/How_To_Contribute>`_

  * `Puppet <https://wiki.openstack.org/wiki/Puppet#Contributing_to_the_modules>`_
  * `Documentation <https://wiki.openstack.org/wiki/Documentation/HowTo>`_
  * `Training guides <https://wiki.openstack.org/wiki/Training-guides#How_To>`_
  * Exercise: Apply for individual membership and sign the CLA

* `Launchpad <https://help.launchpad.net/>`_

  * `Blueprints <https://wiki.openstack.org/wiki/Blueprints>`_
  * `Bugs <https://wiki.openstack.org/wiki/Bugs>`_

    * `Status, Importance, Assigned To, Milestone, Tags <https://wiki.openstack.org/wiki/Bugs#Bugs_reference>`_
    * `reporting a bug <https://wiki.openstack.org/wiki/Bugs#Reporting>`_
    * `confirming and prioritizing <https://wiki.openstack.org/wiki/Bugs#Confirming_.26_prioritizing>`_
    * `debugging <https://wiki.openstack.org/wiki/Bugs#Debugging_.28optional.29>`_
    * `bugfixing <https://wiki.openstack.org/wiki/Bugs#Bugfixing>`_

  * Exercise: review other launchpad bugs and improve yours

* How to contribute

  * `Developer’s Guide <http://docs.openstack.org/infra/manual/developers.html>`_
  * `Account setup <http://docs.openstack.org/infra/manual/developers.html#account-setup>`_
  * `Git review installation <http://docs.openstack.org/infra/manual/developers.html#installing-git-review>`_
  * `Starting Work on a New Repository <http://docs.openstack.org/infra/manual/developers.html#starting-work-on-a-new-repository>`_
  * `Development workflow <http://docs.openstack.org/infra/manual/developers.html#development-workflow>`_
  * `Running unit tests <http://docs.openstack.org/infra/manual/developers.html#running-unit-tests>`_
  * `Cross-Repository Dependencies <http://docs.openstack.org/infra/manual/developers.html#cross-repository-dependencies>`_
  * Exercise: push a WIP or draft and invite reviewers

* Branching model

  * `Branch model <https://wiki.openstack.org/wiki/Branch_Model>`_
  * `Stable branch <https://wiki.openstack.org/wiki/StableBranch>`_
  * Exercise: checkout the latest stable branch

* `Code Review <http://docs.openstack.org/infra/manual/developers.html#code-review>`_
* `Peer Review <http://docs.openstack.org/infra/manual/developers.html#peer-review>`_

  * `Git Commit Good Practice <https://wiki.openstack.org/wiki/GitCommitMessages>`_
  * Gerrit Documentation: `Gerrit Code Review - A Quick Introduction <https://review.openstack.org/Documentation/intro-quick.html>`_
  * Gerrit Documentation: `Reviewing the Change <https://review.openstack.org/Documentation/intro-quick.html#_reviewing_the_change>`_
  * Exercise: review each other messages on the draft

* `Jenkins (Automated testing) <http://docs.openstack.org/infra/manual/developers.html#automated-testing>`_

  * Exercise: add an error and match it to the Jenkins message

Second day
----------

The Contribution Process (1 hour)
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Overview of the contribution process

* Take the pulse of the project
* Figure out who's behind it
* Determine the project's social groups
* Assess your approach
* Engage immediately
* Play with your network
* Perform the smaller tasks
* Choose a question
* Familiarize yourself with the code of conduct
* Understand the conventions
* Explain what you do
* Prepare the backport
* Learn what's local and what's upstream
* Learn what distinguishes good work flow from bad work flow
* Quantify the delta
* Speed up the acceptance
* Determine the time frame
* Maximize karma
* Work in parallel
* Archive and collect

`Complete index in slide format only <http://docs.openstack.org/upstream-training/slide-index.html>`_
