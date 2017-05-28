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

When and where to get an OpenStack Upstream Institute class
===========================================================

The next session of the OpenStack Upstream Collaboration Training - OpenStack
Upstream Institute - will be held in Beijing, in parallel to the conference
part of the `OPNFV Summit
2017 <http://events.linuxfoundation.org/events/archive/2017/opnfv-summit>`_.

 **Wednesday, June 14, 2017 at 11:00 a.m. to 5:00 p.m.
 - Thursday, June 15, 2017 at 11:00 a.m. to 5:00 p.m. (local time)**

In order to RSVP you need to register to the OPNFV Summit first and you can add
the course to your registration as an Add-On. If you registered already you can
add the course to your registration later as well.

Please see the `OpenStack Upstream Institute
<http://events.linuxfoundation.org/events/archive/2017/opnfv-summit/extend-the-experience/openstack-upstream-institute>`_ class information for more
details.

See YOU in Beijing!

Please note that the language of the training is English.

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

`Etherpad for Beijing Upstream Collaboration Training
<https://etherpad.openstack.org/p/upstream-institute-beijing>`_

Staff
=====

Training organizers
-------------------

Ildiko Vancsa, Kendall Nelson

Further trainers/coaches
------------------------

You can find the list of trainers/coaches on the `training occaisons
<https://wiki.openstack.org/wiki/OpenStack_Upstream_Institute_Occasions#Beijing_Crew>`_ wiki page.


Archives
========

For more information about the past trainings and the local upstream trainings,
see :doc:`upstream-archives`.

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
* `Branching model <branching-model.html>`_

Other
-----------------------

* `Documentation Deep Dive <docs.html>`_

Archive of additional training activities
-----------------------------------------

.. note:: Activities listed here are not realized at every Upstream training.

* `Lego applied to Free Software contributions
  <archive-training-agile-for-contributors.html>`_
* `Closing Exercise  <archive-closing-exercise.html>`_

`Complete index in slide format only <slide-index.html>`_
