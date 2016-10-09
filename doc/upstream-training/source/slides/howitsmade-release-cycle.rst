=======================
OpenStack Release Cycle
=======================

.. image:: ./_assets/os_background.png
   :class: fill
   :width: 100%

What makes a release
====================

- A way to coordinate the development of multiple projects
- Release process is managed by the Release Management team
- Release models

  - *Common cycle with development milestones*
  - Common cycle with intermediary release
  - Trailing the common cycle
  - Independent release model

.. note::

  - Release management description:
    http://docs.openstack.org/project-team-guide/release-management.html
  - The training concentrates on the common cycle with the development
    milestones as that is what most students will face with. The other types
    should be described with examples.

Exercise
========

- Look up the release schedule for the current and past two OpenStack
  release cycles
- Identify common caracteristics of these cycles

  - Milestones
  - Deadlines
  - etc.

- Describe a release cycle based on the information you found

Common cycle with development milestones
========================================

- A coordinated way for projects to periodically create their deliverables
  including testing and documentation
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
- It depends on each project how to organise the work at each cycle

  - Spec/blueprint freeze
  - Prioritising items

- Generic intention behind planning

  - Take a step back
  - Focus on what we want to do for the next one

Planning - Discuss
==================

- Prepare your idea for the public

  - Discuss with your peers
  - Work on feedback and comments

- Capture your idea in a spec/blueprint

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
  - The exact date depends on the projects

Exercise
========

- Find feature proposal deadlines in the current release schedule

Implementation
==============

- When your blueprint/spec is accepted

  - Push code to Gerrit for review
  - Upload your code as early as possible in the release cycle

- Deadlines for the code to get merged

  - Depends on the priority of your work item
  - Set by each project team

Implementation - Milestone
==========================

- Three development milestones during a release cycle
- Make useful reference points in time to organize the development cycle
- Milestones are tagged in the repository using b1, b2 and b3
- Overall feature freeze is the third milestone

Implementation - Freezes
========================

- Freeze dates depend on the type of activity
- Feature freeze

  - Code for new features will not be accepted
  - Bug fixing activities are still ongoing
  - More focus on testing

- String freeze

  - All externally visible strings must be frozen
  - This helps the I18n and Documentation projects

Release Candidates
==================

- After the last milestone
- Code stabilization period
- Main activities

  - Test the code and file bugs
  - Prioritize bugs / bug triage

    - Get critical and high priority bugs fixed on the first place
    - Fix as many bugs as possible

  - Finalize documentation

Release candidate 1
===================

- Cut when all the release-critical bugs are fixed
- stable/release branch
- master branch is open for development
- Used as-is as the final release

Other release candidates
========================

- Regressions and integration issues

  - New release-critical bugs

- (RC2, RC3, ...), with bugs targeted to it

  - Merged in the master branch first and then cherry-picked to stable
  - Repeated as many times as necessary

Release day
===========

- Last published release candidate
- Published collectively as the OpenStack release
