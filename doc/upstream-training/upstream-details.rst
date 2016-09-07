===================================
OpenStack Upstream Training Details
===================================

Introduction
============

With over 2000 developers from 80 different companies worldwide, OpenStack is
one of the largest collaborative software-development projects. Because of its
size, it is characterized by a huge diversity in social norms and technical
conventions. These can significantly slow down the speed at which newcomers
are successful at integrating their own roadmap into that of the OpenStack
project.

We've designed a training program to help professional developers negotiate
this hurdle. It shows them how to ensure their bug fix or feature is accepted
in the OpenStack project in a minimum amount of time. The educational program
requires students to work on real-life bug fixes or new features during two
days of real-life classes and online mentoring, until the work is accepted by
OpenStack. The live two-day class teaches them to navigate the intricacies of
the project's technical tools and social interactions. In a followup session,
the students benefit from individual online sessions to help them resolve any
remaining problems they might have.

Objectives
==========

- Faster integration of the companies product roadmap into the OpenStack
  release cycle
- Successfully contribute one real world patch to an OpenStack component
- Master the technical tools
- Understand the OpenStack contribution workflow and social norms

Target Audience
===============

- Developers
- System administrators

Prerequisites
=============

- Being able to read and write English at a technical level
- If contributing code, being technically proficient enough to carry out
  simple bug fixes in the project
- If contributing documentation, being able to produce documents in the
  project's chosen infrastructure
- Having at least 8 hours a week to dedicate to the project, be it through
  programming or through interacting with the community

Duration
========

- Face-to-face section: 2 days
- Online section: 10 one-hour individual mentoring sessions over a period of
  4 to 10 weeks

Infrastructure
==============

- `ready to use DevStack VM <https://wiki.openstack.org/wiki/OpenStack_Upstream_Training/Setup_DevStack>`_
  for participants with network connectivity but troubles with their laptop

Course Outline
==============

First day
=========

Introduction
~~~~~~~~~~~~

* A week before Day 1: choice of a contribution, via email, with each
  participant
* Day 1: Introduction
* Day 1: How OpenStack is made
* Day 1: Learn and practice Git, Gerrit, IRC

* Day 2: The theory of contribution
* Day 2: Lego contribution simulation
* Day 2: Individual presentation of the contribution plan
* Day 2: Online mentoring

Introduction
~~~~~~~~~~~~

* `Training introduction <00-00-introduction.html>`__
* `OpenStack as software <00-01-openstack-as-software.html>`__
* `OpenStack as a community <00-02-openstack-as-community.html>`__

How OpenStack is made (3h including 1h30 exercises)
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

* `Release cycle <https://wiki.openstack.org/wiki/Release_Cycle>`_
  (`slides <01-release-cycle.html>`__)

  * `Planning (Design, Discuss and Target) <https://wiki.openstack.org/wiki/Release_Cycle#Planning_.28Design.2C_Discuss_and_Target.29>`_
  * `Implementation (Milestone iterations <https://wiki.openstack.org/wiki/Release_Cycle#Implementation_.28Milestone_iterations.29>`_
  * `Pre-release (Release Candidates dance) <https://wiki.openstack.org/wiki/Release_Cycle#Pre-release_.28Release_Candidates_dance.29>`_

    * `Release candidate 1 <https://wiki.openstack.org/wiki/Release_Cycle#Release_candidate_1>`_
    * `Other release candidates <https://wiki.openstack.org/wiki/Release_Cycle#Other_release_candidates>`_
    * `Release day <https://wiki.openstack.org/wiki/Release_Cycle#Release_day>`_

  * Exercise: based on the `Kilo release schedule <https://wiki.openstack.org/wiki/Kilo_Release_Schedule>`_
    find the URL of a document or a patch that belongs to each of the above
    steps.

* Relevant actors (`slides <02-relevant-actors.html>`__)

  * `committers <http://www.stackalytics.com/?release=kilo&metric=commits&project_type=integrated&module=&company=&user_id=>`_
    companies
  * `commiters <http://www.stackalytics.com/?release=kilo&metric=commits&project_type=integrated&module=&company=&user_id=>`_
    individuals (bottom of the page)
  * Your management

* `OpenStack Governance <http://governance.openstack.org/>`_
  (`slides <03-technical-committee.html>`__)

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
  (`slides <04-program-ecosystem.html>`__)

  * `OpenStack Project Teams <http://governance.openstack.org/reference/projects/index.html>`__
  * `List of approved tags <http://governance.openstack.org/reference/tags/index.html>`_
  * `Understanding the DefCore Guidelines <https://git.openstack.org/cgit/openstack/defcore>`_
  * `Core Definition <https://git.openstack.org/cgit/openstack/defcore/plain/doc/source/process/CoreDefinition.rst>`_
  * `How to create a project <http://docs.openstack.org/infra/manual/creators.html>`_
  * Exercise: What kind of Program do you contribute to ?

* `Design summits <https://wiki.openstack.org/wiki/Design_Summit>`_
  (`slides <05-design-summit.html>`__)

  * `Propose sessions <https://wiki.openstack.org/wiki/Design_Summit/Planning>`_
  * `List of sessions <https://libertydesignsummit.sched.org/overview/type/design+summit#.VVeYTt-uNNw>`_
  * `Liberty Summit Etherpads <https://wiki.openstack.org/wiki/Design_Summit/Liberty/Etherpads>`_
  * Exercise: Add a session proposal regarding your contribution in an
    etherpad, review two proposals

* `IRC meetings <https://wiki.openstack.org/wiki/Meetings>`_
  (`slides <06-irc-meetings.html>`__)

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
  (`slides <11-devstack.html>`__)

  * Ubuntu or Fedora
  * ``git clone https://git.openstack.org/openstack-dev/devstack``
  * `minimal configuration <http://docs.openstack.org/developer/devstack/configuration.html#minimal-configuration>`_
  * ``cd devstack; ./stack.sh``
  * Exercise: get the code for the targeted contribution

* `How_To_Contribute URL <https://wiki.openstack.org/wiki/How_To_Contribute>`_
  (`slides <12-howtocontribute.html>`__)

  * `Puppet <https://wiki.openstack.org/wiki/Puppet#Contributing_to_the_modules>`_
  * `Documentation <https://wiki.openstack.org/wiki/Documentation/HowTo>`_
  * `Training guides <https://wiki.openstack.org/wiki/Training-guides#How_To>`_
  * Exercise: Apply for individual membership and sign the CLA

* `Launchpad <https://help.launchpad.net/>`_ (`slides <13-launchpad.html>`__)

  * `Blueprints <https://wiki.openstack.org/wiki/Blueprints>`_
  * `Bugs <https://wiki.openstack.org/wiki/Bugs>`_

    * `Status, Importance, Assigned To, Milestone, Tags <https://wiki.openstack.org/wiki/Bugs#Bugs_reference>`_
    * `reporting a bug <https://wiki.openstack.org/wiki/Bugs#Reporting>`_
    * `confirming and prioritizing <https://wiki.openstack.org/wiki/Bugs#Confirming_.26_prioritizing>`_
    * `debugging <https://wiki.openstack.org/wiki/Bugs#Debugging_.28optional.29>`_
    * `bugfixing <https://wiki.openstack.org/wiki/Bugs#Bugfixing>`_

  * Exercise: review other launchpad bugs and improve yours

* How to contribute
  (`slides <14-gerrit.html>`__)

  * `Developer’s Guide <http://docs.openstack.org/infra/manual/developers.html>`_
  * `Account setup <http://docs.openstack.org/infra/manual/developers.html#account-setup>`_
  * `Git review installation <http://docs.openstack.org/infra/manual/developers.html#installing-git-review>`_
  * `Starting Work on a New Repository <http://docs.openstack.org/infra/manual/developers.html#starting-work-on-a-new-repository>`_
  * `Development workflow <http://docs.openstack.org/infra/manual/developers.html#development-workflow>`_
  * `Running unit tests <http://docs.openstack.org/infra/manual/developers.html#running-unit-tests>`_
  * `Cross-Repository Dependencies <http://docs.openstack.org/infra/manual/developers.html#cross-repository-dependencies>`_
  * Exercise: push a WIP or draft and invite reviewers

* Branching model
  (`slides <15-branching-model.html>`__)

  * `Branch model <https://wiki.openstack.org/wiki/Branch_Model>`_
  * `Stable branch <https://wiki.openstack.org/wiki/StableBranch>`_
  * Exercise: checkout the latest stable branch

* `Code Review <http://docs.openstack.org/infra/manual/developers.html#code-review>`_
  (`slides <16-reviewing.html>`__)
* `Peer Review <http://docs.openstack.org/infra/manual/developers.html#peer-review>`_
  (`slides <17-commit-message.html>`__)

  * `Git Commit Good Practice <https://wiki.openstack.org/wiki/GitCommitMessages>`_
  * Gerrit Documentation: `Gerrit Code Review - A Quick Introduction <https://review.openstack.org/Documentation/intro-quick.html>`_
  * Gerrit Documentation: `Reviewing the Change <https://review.openstack.org/Documentation/intro-quick.html#_reviewing_the_change>`_
  * Exercise: review each other messages on the draft

* `Jenkins (Automated testing) <http://docs.openstack.org/infra/manual/developers.html#automated-testing>`_
  (`slides <18-jenkins.html>`__)

  * Exercise: add an error and match it to the Jenkins message

Second day
==========

The Contribution Process (1 hour)
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Overview of the contribution process
(`slides <19-training-contribution-process.html>`__)

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

Lego applied to Free Software contributions (15 min)
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Lego applied to Free Software contributions
(`slides <20-training-agile-for-contributors.html>`__)

These slides prepare students for the Lego activity, and ensure they
understand the metaphors in use. The Lego in the exercise represents the
code of a software project, in this case OpenStack. The students all take
on roles that represent various facets of the OpenStack community, including
upstream roles like Foundation and TCT, and contributors like corporations,
and unaffiliated individuals animated by unknown motives (free agents).

The group is split into their new 'teams' at this stage. Facilitators can
choose any way they prefer to do this (selecting teams, or allowing students
to self-select). The recommended numbers are in the slides, but can be
changed to suit the number of participants in the room. For a very large
group, consider separating into two 'communities', which then have to
fit their streets together to complete the session. Having more
communities requires an extra level of coordination to reach
`interoperability` between the results of their work.

Give each person a nametag to wear, with their first name and their
role written on it. For free agents, don't disclose who is distracted,
controversial, or agreeable. The community will need to work this out
on their own.

Contribution Simulation (2 hour)
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Ahead of time: ensure the existing Lego buildings are set out on a table,
but not connected to each other. All the unsorted bricks should be available
in several smaller boxes in a different part of the room, for participants
to use. There is no need to display the boxes or instruction manuals.

Once the students are separated into their new roles, and have an
understanding of the project, begin the timer for the first sprint. During
the five minutes planning time, encourage each group to get together and
think about their project. If possible, give each group a corner of the room
and access to a whiteboard or flipchart. For companies, ensure the CEO sets
a direction, and the team is on board. Their responsibility is to
deliver value to their stakeholders. For upstream, have them think about
the community standards they want to set: they are responsible for the
quality of the finished product. For free agent contributors,
use this time to get them to understand their role in the simulation:
explain their part as agents of chaos. They can get straight to work
as soon as they understand their role, no need to wait for the timer
to go off. The free agents should not be forced to coordinate among
themselves: there are better results if they find out how hard it is
to accomplish anything without coordinating with others. In theory,
the free agents can decide to demolish things, too: try suggesting
this option to one of them, see what happens.

Suggestions of projects to work on:

* Companies: big industrial items like a shopping mall, carpark, energy
  plant, datacenter, and hospital.

* Free agents: community items like vegetable patches, bicycle paths,
  public artworks, playgrounds. For the controversial agent, problematic
  items such as a jail, skate bowl, and dog park.

* Upstream: consider guidelines around consistency in the bricks used, how to
  connect the road and sidewalk between the buildings, the kinds of
  buildings they should request the community to make, and the things they
  simply will not accept. Make them understand that they are
  responsible for the finished product.

Start the timer for building time, and allow everyone to start work. During
each building phase, have mentors wander around the groups listening in and
making suggestions, without actually doing any of the work or giving
answers. The role of the mentors is to ask questions to orient the
conversations among the teams. For example, during the first sprint it
is common that the CEO and the PTL will face incompatibility of their
plans. Mentors should ask the teams how to address those issues.

In your interactions with the students, do not be afraid to provoke some
issues. For example, bring up the idea of an API (a way of connecting the
buildings to each other) with individual companies, but don't mention it
to upstream, so that upstream are finally faced with the challenge of
standardizing the API. You could also, in the second or third sprint,
encourage one group to call for a meeting off the sprint cycle to sort
the problem out.

During the final five minutes of the sprint (review time), ask everyone to
take their hands off the Lego, and gather around the in-progress street. At
this stage, upstream get to vote on the changes, and anything rejected gets
sent back to the contributing group to be fixed. Ensure upstream give good
reasons for rejections, along with suggestions for improvement. Encourage
Upstream to reject a few things early on, to try and ensure contributors
understand the need to have Foundation on board before they throw something
over the wall.

At the end of the four sprints, ensure you take a group photo!

Contribution Planning (2 hours)
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

`ODP slides <http://dachary.org/loic/openstack-training/training-student-project-sample.odp>`_
`PDF slides <http://dachary.org/loic/openstack-training/training-student-project-sample.pdf>`_

* The students use template slides to prepare a 5-minute presentation of
  their planned contribution
* A sample presentation is given by the teacher, as an example
* Each student group prepares a presentation describing:

  * the contribution they plan to work on during the online sessions
  * how they will engage with the Upstream
  * how it contributes to the company's agenda
  * and whom they will be working with

* Each student group presents its slides to the class

Etherpad
~~~~~~~~

https://etherpad.openstack.org/p/upstream-training-vancouver

`Complete index in slide format only <http://docs.openstack.org/upstream-training/slide-index.html>`_
