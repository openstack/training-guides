===========================
OpenStack Upstream Training
===========================

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

We've designed a training program to help professional developers negotiate
this hurdle. It shows them how to ensure their bug fix or feature is accepted
in the OpenStack project in a minimum amount of time. The educational program
requires students to work on real-life bug fixes or new features during two
days of real-life classes and online mentoring, until the work is accepted by
OpenStack. The live two-day class teaches them to navigate the intricacies of
the project's technical tools and social interactions. In a followup session,
the students benefit from individual online sessions to help them resolve any
remaining problems they might have.

For more information, see :doc:`upstream-details`.

When & Where to get OpenStack Upstream Training
===============================================

The next session of the OpenStack Upstream Training will be held in Barcelona,
before the OpenStack Summit Barcelona 2016:

**Sunday, October 23, 2016 at 1:00 p.m. to 5:00 p.m.
- Monday, October 24, 2016 at 10:00 a.m. to 4:00 p.m. (local time)**

For more information and registration, see the `OpenStack Academy page
<https://www.openstack.org/summit/barcelona-2016/openstack-academy/>`_.

How to prepare
==============

* Make sure you have a wifi enabled laptop with you.
* Create a virtual machine on your laptop with Ubuntu 14.04 installed and
  4+ GB of RAM.
  Alternatively, you can use your virtual machine on a public cloud.
* Check that you can ssh from your laptop to the virtual machine
* Check that :command:`apt install` works on the virtual machine
* Read and complete the :doc:`irc` guide.
* Read and complete the :doc:`accounts` guide.
* Read and complete the :doc:`git` guide.
* Get in touch with the team upstream-training@openstack.org to pick
  a contribution to work on.

`Etherpad for Austin Upstream Training
<https://etherpad.openstack.org/p/upstream-training-austin>`_

Staff
=====

The trainers for the upcoming training in Barcelona:

Ildiko Vancsa, Kendall Nelson, Mark Korondi, and Marton Kiss

We would like to make as many matches before the Barcelona Summit as we can
so you can meet with your mentee/mentor there if you are both attending.

`Sign-up to get involved here
<https://openstackfoundation.formstack.com/forms/mentor_mentee_signup_pre_barcelona>`__.

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

How OpenStack is Made
---------------------

* `Official OpenStack projects <howitsmade-official-projects.html>`_
* `OpenStack Design Summit <howitsmade-design-summit.html>`_
* `Metrics <howitsmade-metrics.html>`_
* `Release cycle <howitsmade-release-cycle.html>`_
* `OpenStack Governance <howitsmade-technical-committee.html>`_
* `IRC meetings <howitsmade-irc-meetings.html>`_

Workflow and Tools for Participation
------------------------------------

* `Overview of the contribution process
  <workflow-training-contribution-process.html>`_
* `How to Contribute <workflow-howtocontribute.html>`_
* `Tracking <workflow-launchpad.html>`_
* `Gerrit <workflow-gerrit.html>`_
* `Reviewing <workflow-reviewing.html>`_
* `Commit Messages <workflow-commit-message.html>`_
* `Jenkins <workflow-jenkins.html>`_
* `Guide to SetUp and Push First Patch
  <workflow-setup-and-first-patch.html>`_

Code Deep Dive
--------------

* `devstack.org <code-devstack.html>`_

Archive of additional training activities
-----------------------------------------

.. note:: Activities listed here are not realised at every Upstream training.

* `Lego applied to Free Software contributions
  <archive-training-agile-for-contributors.html>`_


`Complete index in slide format only <slide-index.html>`_
