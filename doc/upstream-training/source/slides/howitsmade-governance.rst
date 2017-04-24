====================
OpenStack Governance
====================

.. image:: ./_assets/os_background.png
   :class: fill
   :width: 100%

OpenStack Foundation
====================

- Nonprofit foundation created to "develop, support, protect, and promote"
  OpenStack

  - Individual members: all of us
  - Institutional members: Platinum and Gold sponsors
  - Further supporting companies and organizations

- Multi-layer group of leadership

  - Board of directors
  - Technical Committee
  - User Committee

Board of Directors
==================

- Strategic and financial oversight
- Representatives are elected from

  - Platinum member companies
  - Gold member companies
  - Individual Foundation members

Technical Committee ("TC")
==========================

- Provides

  - Oversight over the OpenStack projects
  - Technical leadership

- Enforces OpenStack ideals

  - Openness
  - Transparency
  - Commonality
  - Integration
  - Quality

- Handles cross-project related topics and issues

.. note::

  - https://www.openstack.org/foundation/tech-committee/

User Committee ("UC")
=====================

- Represents OpenStack users
- Gathers feedback and consolidates requirements
- Further details are in a later session

Exercise
========

- Find the current members of the Board of Directors, TC and UC

OpenStack Project Teams
=======================

- Teams of people who

  - Produce *deliverables* to achieve a clearly stated *objective*
  - Using the common tools (code repository, bug tracker, CI system, etc.)
  - Work towards OpenStack's mission

- Teams in OpenStack can be freely created as they are needed
- Official project teams fall under the TC's authority and are led by a
  Project Team Lead and Core Team Members
- The official list of projects:

  - http://governance.openstack.org/reference/projects/

.. note::

  - Source file is hosted in the `governance repository <http://git.openstack.org/cgit/openstack/governance/tree/reference/projects.yaml>`_

Active Technical Contributor (ATC)
==================================

- Subset of the Foundation Individual Members
- Committed a change over the last two 6-month release cycles

  - Code or documentation contribution to any of the official project
    repositories
  - Apply for ATC role

    - Bug triagers
    - Technical documentation writers

- TC seats are elected from and by the group of ATC's

Active Project Contributor (APC)
================================

- Actively contributing to one or more OpenStack projects

  - Also ATC
  - Attends project meetings
  - Participates in project related mail threads on the mailing lists

Project Team Leads (PTLs)
=========================

- Manage day-to-day operations
- Drive the program goals
- Resolve technical disputes
- Elected from and by the group of APC's

Core Team Members
=================

- Have authority to merge code into a project
- Assist the PTL in driving program goals
- May also be stable core members (able to merge to stable branches)
- Elected by PTL and other Core Team Members
- Unlike ATC, APC and PTLs, role is not defined in the TC charter

.. note::

  - Election process is more informal than PTLs.
  - PTL or Core Team Member nominates a person.
  - PTL e-mails nomination to mailing list.
  - Though not defined in the TC charter like other roles above, cores
    serve an important role in Project Teams.
  - Person is elected if no team members object to the nomination.

Exercise
========

- Determine who the PTL is for your favorite project
- Determine the Core Team list for your favorite project

