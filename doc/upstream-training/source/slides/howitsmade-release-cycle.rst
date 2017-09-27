=======================
OpenStack Release Cycle
=======================

.. image:: ./_assets/os_background.png
   :class: fill
   :width: 100%

.. note::
   Tags: [management] [operator] [user]

What makes a release
====================

- Coordinated development of multiple projects
- Release process is managed by the Release Management team
- Release models

  - *Common cycle with development milestones*
  - Common cycle with intermediary release
  - Trailing the common cycle
  - Independent release model

- A given project cannot follow more than one model

.. note::

  - Release management description:
    http://docs.openstack.org/project-team-guide/release-management.html
  - The training concentrates on the common cycle with the development
    milestones as that is what most students will work with. The other types
    should be described.
  - Common cycle with intermediary release:
    - Used for components needing more frequent releases. e.g. Oslo Libraries
    - Intermediary releases can also be used to time releases near the
    beginning and end of the release cycle. Horizon plug-ins do this.
  - Trailing the common cycle:
    - Projects dependent upon the output of a release, like packaging or
    deploying OpenStack follow this model; e.g. Fuel and Kolla
  - Independent release model:
    - These projects may hold tools used for OpenStack part aren't part of a
    production release.

Exercise
========

- Look up the release schedule for the current and past two OpenStack
  release cycles
- Identify common characteristics of these cycles and discuss them with
  your group

  - Milestones
  - Deadlines
  - etc.

- Describe a release cycle based on the information you found
- Determine how many OpenStack releases are officially supported
  by the community
- Post the information on the IRC channel


Common cycle with development milestones
========================================

- Project teams create their deliverables, including testing and
  documentation, on a coordinated schedule
- Every cycle includes

  - Planning and design activities
  - Implementation work

    - New features
    - Bug fixes
    - Testing
    - Documentation

  - Release preparation
  - Release

Planning - Design
=================

- Design activity is a continuous effort
- Planning for a release cycle starts at the end of the previous cycle

   - Face to face planning discussions happen at the Project Teams Gathering
     (PTG) which is coordinated with the start of a development new cycle

- Each project team sets priorities/dates for the release

  - Spec/blueprint freeze
  - Prioritization of items (e.g. testing, documentation, etc.)

- Generic intention behind planning

  - Take a step back
  - Focus on what we want to do for the next one

Planning - Discuss
==================

- Prepare your idea for proposal to the community.

  - Discuss with your project team

    - PTG is a good time to propose and discuss features/fixes

  - Work on feedback and comments

- Capture your idea in a spec/blueprint

.. note::

  - Whether a change requires just a blueprint or spec and blueprint
    depends on the complexity of the change.
  - Start with a blueprint and look to the project team's core members
    for guidance on whether a spec is needed.

Planning - Target
=================

- Submit the blueprints and/or specs
- Identify a target milestone

  - When in the cycle you intend to complete it
  - Project team helps you to identify the target milestone and register it
    in the tracking tool

- The priority of the work item is set by the project team members or lead
- Feature proposal freeze

  - The deadline for proposing new ideas for a release cycle
  - The exact date is determined by each project team

Exercise
========

- Find feature proposal deadlines in the current release schedule
- Compare the deadlines between two different project teams and discuss the
  differences with your group

Implementation
==============

- When your blueprint/spec is accepted

  - Push code to Gerrit for review
  - Upload your code as early as possible in the release cycle
  - Code can be uploaded before a blueprint/spec is accepted

- Deadlines for the code to get merged

  - Depends on the priority of your work item
  - Set by each project team

Implementation - Milestone
==========================

- Three development milestones during a release cycle
- Make useful reference points in time to organize the development cycle
- Milestones are tagged in the repository using b1, b2 and b3
- Overall feature freeze is the third milestone

Exercise
========

- In addition to milestones, there are freeze dates for different activities
  in the release

    - Work with your group to find and discuss the different freeze activities

.. note::

  - Spec freeze
    - Point at which specs must be proposed and reviewed for the release.
  - Feature freeze
    - Code for new features is no longer accepted.
  - String freeze
    - Externally visible strings can no longer be changed. Helps translation
    activities complete on time.
  - Requirements freeze
    - No longer change requirements to allow downstream packagers time to
    pull-in and build dependencies.

Release Candidates
==================

- After the last milestone
- Code stabilization period
- Main activities

  - Test the code and file bugs
  - Prioritize bugs / bug triage

    - Get critical and high priority bugs fixed first
    - Fix as many bugs as possible

  - Finalize documentation

.. note::

  - Code change during the RC phase is a balancing act
    - Need to balance integrating fixes and code churn
    - Critical fixes have the highest priority while more minor bug fixes may
    be safer to hold for the subsequent release.
  - Who is able to approve patches during the RC phase is limited.

Release candidate process
=========================

- Release Candidate 1 (RC1) is cut when all the release-critical bugs are fixed
- stable/release branch
- master branch is open for development
- Used as-is as the final release
- Additional Release Candidates created for critical bugs found during
  RC testing
  - (RC2, RC3, ...) with bugs targeted to it
  - Repeated as many times as necessary

Release day
===========

- Last published release candidate from all Project Teams
- Published collectively as the OpenStack release

Exercise
========

- Find the release day for the current release
- Find where the currently released code is posted


