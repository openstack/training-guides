============================
OpenStack Upstream Institute
============================

.. All documents in the source directory must occur in some toctree directive.
   Otherwise Sphinx will emit a warning if it finds a file that is not
   included. Documents which belong to no toctree should be added to the
   hidden toctree below.

.. toctree::
   :hidden:

   upstream-details
   irc
   accounts
   git
   upstream-archives
   upstream-trainers-guide

Abstract
========

With over 2,000 developers from over 300 different organizations worldwide,
OpenStack is one of the largest collaborative software-development projects.
Because of its size, it is characterized by a huge diversity in social norms
and technical conventions.
These can significantly slow down the speed at which newcomers are successful
at integrating their own roadmap into that of the OpenStack project.

We've designed a training program to share knowledge about the different ways
of contributing to OpenStack like providing new features, writing
documentation, participating in working groups, and so forth. The educational
program is built on the principle of open collaboration and will teach the
students how to find information and navigate the intricacies of the
project’s technical tools and social interactions in order to get their
contributions accepted. The live one and a half day class is focusing on
hands-on practice like the students can use a prepared development
environment to learn how to test, prepare and upload new code snippets or
documentation for review. The attendees are also given the opportunity to
join a mentoring program to get further help and guidance on their journey
to become an active and successful member of the OpenStack community.

For more information, see :doc:`upstream-details`.

Please note that the language of the training is English.

When and where to get an OpenStack Upstream Institute class
===========================================================

Summits
-------

We run the full training prior to each OpenStack Summit, see this web page and
the schedule of the upcoming event for more details and registration.

OpenStack Summit Sydney
+++++++++++++++++++++++

The upcoming `OpenStack Summit
<https://www.openstack.org/summit/sydney-2017/>`_ will be in Sydney in
November with a full training running prior to the event.

`Etherpad for Sydney Upstream Collaboration Training
<https://etherpad.openstack.org/p/upstream-institute-sydney-2017>`_

 **Saturday, November 04, 2017 - Sunday, November 05, 2017**

 More details coming soon...

Other events
------------

We are bringing a one day long version of the training to some of the local
OpenStack Days events and other industry events. Keep your eyes open for these
events and check back on this website to find new occasions.

OpenStack Days UK
+++++++++++++++++

You can access the training in parallel to the `OpenStack Days UK
<https://openstackdays.uk/2017/>`_ event.

 **Tuesday, September 26, 2017 at 11:00 a.m. to 5:45 p.m. (local time)**

Please see the `Upstream Developer Training
<https://openstackdays.uk/2017/?schedule=upstream-developer-training>`_ class
information for more details.

`Etherpad for London Upstream Collaboration Training
<https://etherpad.openstack.org/p/upstream-institute-uk-2017>`_

See YOU in London!

OpenStack Days Nordic
+++++++++++++++++++++

You can access the training on the first day of the `OpenStack Days Nordic
<http://openstacknordic.org/copenhagen2017/>`_ event.

 **Wednesday, October 18, 2017 at 08:30 a.m. to 4:30 p.m. (local time)**

Please see the `Becoming a member of the OpenStack community Part 1
<https://openstackdaysnordic2017.sched.com/event/9kSn>`_ and
`Becoming a member of the OpenStack community Part 2
<https://openstackdaysnordic2017.sched.com/event/BNkw>` pages for class
information and more details.

`Etherpad for Nordic Upstream Collaboration Training
<https://etherpad.openstack.org/p/upstream-institute-nordic-2017>`_

See YOU in Copenhagen!

.. _prepare-environment:

How to prepare
==============

* Make sure you have a wifi enabled laptop with you.
* Prepared virtual machine image with a development environment:

  * Image and instructions: https://github.com/kmARC/openstack-training-virtual-environment/

* Prepare an environment by yourself from scratch:

  * Create a virtual machine on your laptop with Ubuntu 16.04 installed and
    6+ GB of RAM.
  * Alternatively, you can use your virtual machine on a public cloud.
  * Check that you can ssh from your laptop to the virtual machine
  * Check that :command:`apt install` works on the virtual machine
  * Read and complete the :doc:`irc` guide.
  * Read and complete the :doc:`git` guide.

* Read and complete the :doc:`accounts` guide. (**Note:** you will need to sign
  the Individual Contributor License Agreement
  (`ICLA <https://review.openstack.org/static/cla.html>`_) during this.)

Staff
=====

Training organizers
-------------------

Ildiko Vancsa, Kendall Nelson

Further trainers/coaches
------------------------

You can find the list of trainers/coaches on the `training occaisons
<https://wiki.openstack.org/wiki/OpenStack_Upstream_Institute_Occasions>`_
wiki page.

Best Practices for Trainers
===========================

If you're joining the training activities as a trainer, coach, or if you hold
training sessions locally you can find some tips and best practices to consider
before hosting the class provided on the :doc:`upstream-trainers-guide` page.

We have collected the suggestions based on our experiences from previous
Upstream Institute trainings.

Outline and online slide index
==============================

.. tip:: Slides are made with `Hieroglyph <http://hieroglyph.io>`_.
   To skim through slides quickly to find something, or jump ahead or back,
   use *Slide table* (press :command:`t` in the browser). Some slides
   include additional explanation in the *Presenter notes* (press
   :command:`c` to see them).

Introduction
------------

* `Introduction <intro-introduction.html>`_
* `Introducing OpenStack as a Software <intro-openstack-as-software.html>`_
* `Introducing OpenStack as a Community <intro-openstack-as-community.html>`_

Setup the Development Environment
---------------------------------

* `Environment Setup <development-environment-setup.html>`_

How OpenStack is Made
---------------------

* `Official OpenStack projects <howitsmade-official-projects.html>`_
* `OpenStack Governance <howitsmade-governance.html>`_
* `Release cycle <howitsmade-release-cycle.html>`_
* `Communication <howitsmade-communication.html>`_
* `OpenStack Events <howitsmade-events.html>`_

Workflow and Tools for Participation
------------------------------------

* `Overview of the contribution process
  <workflow-training-contribution-process.html>`_
* `Registration and accounts <workflow-reg-and-accounts.html>`_
* `Task Tracking <workflow-task-tracking.html>`_
* `Gerrit <workflow-gerrit.html>`_
* `Reviewing <workflow-reviewing.html>`_
* `Commit Messages <workflow-commit-message.html>`_
* `Project Status and Zuul <workflow-project-status-and-zuul.html>`_
* `Metrics <workflow-metrics.html>`_
* `Guide to SetUp and Push First Patch
  <workflow-setup-and-first-patch.html>`_
* `Using Sandbox for Practice <workflow-using-sandbox.html>`_

Code Deep Dive
--------------

* `Demo environment <code-devstack.html>`_
* `Code exercises <code-exercises.html>`_

Other
-----------------------

* `Documentation Deep Dive <docs.html>`_

Archives
========

For more information about the past trainings and the local upstream trainings,
see :doc:`upstream-archives`.

Archive of additional training activities
-----------------------------------------

.. note:: Activities listed here are not realized at every Upstream training.

* `Lego applied to Free Software contributions
  <archive-training-agile-for-contributors.html>`_
* `Closing Exercise  <archive-closing-exercise.html>`_
* `Branching model <archive-branching-model.html>`_

`Complete index in slide format only <slide-index.html>`_
