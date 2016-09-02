====================================
Overview of the contribution process
====================================

.. image:: ./_assets/os_background.png
   :class: fill
   :width: 100%

Picking Your Project
====================

- Each project has its own purpose
- Each project has its own culture
- Does your company want you to work on something specific?

Getting to Know Your Project
============================

- Clone and be familiar with the code

.. code-block:: console

   git clone git://git.openstack.org/openstack/<your_project>

- Example:

.. code-block:: console

   git clone git://git.openstack.org/openstack/training-guides


- Run the tests
- Join the project's the IRC channel
  https://wiki.openstack.org/wiki/IRC
- Look at open reviews
- Join the openstack-dev mailing list

Interacting with the Project
============================

- Talking in the IRC channel
- Follow and participate in project related mail threads in the mailing list
- Attending regular meetings
- Filing, fixing, and triaging bugs
- Filing a blueprint/spec
- Implementing a blueprint/spec

General Contribution Workflow
=============================

- Pick a task (bug, trivial fix, documentation, implementation)
- Make a new branch in your local repository

  git checkout -b name_whatever_you_want
- Make code changes
- Update and add tests (unit, functional, etc.)
- Run tests (unit, functional, etc.)
- Create your commit
    - Add files to your commit
    - Commit added files and explain changes in the commit message
- Push upstream for review

Your Patch Upstream
===================

- Jenkins and vendor CIs will review your patch
- Community members will review your patch
- Reply to comments
- Make changes and push new patchsets
- Resolve merge conflicts

Speeding the Acceptance
=======================

- Be on top of people's comments
    - Be patient
    - Be communicative
    - Be collaborative

REMEMBER: This is open source.
Things happen on the community's schedule, not yours.

Building Karma
==============

- Review other's code
- Fix the documentation
- Answer questions
- Attend the meetings

Build Your Network
==================

- Personal message or talk in the channel to people
- Ask people you know about the project
- Ask people about their contributions
- Ask people about their contribution experience
- Pay attention to who is an expert in what area
