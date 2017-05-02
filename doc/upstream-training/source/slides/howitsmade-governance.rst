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

.. note::

  - Each Platinum member can delegate one member
  - Gold members can delegate the same amount of members as Platinum members

    - by majority vote of all Gold Members

  - Individual members elect the same amount

  For more info see Article IV of `Bylaws of the OpenStack Foundation
  <https://www.openstack.org/legal/bylaws-of-the-openstack-foundation/>`_

Technical Committee ("TC")
==========================

- Provides

  - Oversight over the OpenStack projects
  - Technical leadership

- Enforces OpenStack ideals like: Openness, Transparency, Commonality,
  Integration and Quality
- Handles cross-project related topics and issues
- Composed of 13 OpenStack Foundation Individual members

  - directly elected by ATC's
  - The TC Chair is proposed by the TC members

.. note::

  - `OpenStack Technical Comittee page <https://governance.openstack.org/tc/>`_
  - `OpenStack Technical Comittee Charter <https://governance.openstack.org/tc/reference/charter.html>`_
  - `List of TC members <https://www.openstack.org/foundation/tech-committee/>`_

User Committee ("UC")
=====================

- Represents OpenStack users
- Gathers feedback and consolidates requirements
- Further details are in a later session

.. note::

  - `OpenStack User Committee page <https://governance.openstack.org/uc/index.html>`_
  - `Members of OpenStack User Comittee <https://www.openstack.org/foundation/user-committee/>`_

Exercise
========

- Find the current members of the Board of Directors, TC and UC
- Find the latest election results for Board of Directors, TC and UC.
  Also find where the OpenStack election procedures are documented.
- Post the information and web sites in the Upstream Collaboration Training
  Etherpad.

.. note::

  - The election of Board of Directors is announced via
    `Board election page <https://www.openstack.org/election/>`_,
    and the election result can be seen in
    `Foundation mailing list <http://lists.openstack.org/cgi-bin/mailman/listinfo/foundation>`_.
  - TC (+PTL) candidates and election results are available on
    `Governance - Election page <https://governance.openstack.org/election/>`_,
    and shared through `openstack-dev mailing list <http://lists.openstack.org/cgi-bin/mailman/listinfo/openstack-dev>`_.
  - UC election information is available though
    `User-committee mailing list <http://lists.openstack.org/cgi-bin/mailman/listinfo/user-committee>`_.

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
  - Individual members, like bug triagers or technical documentation writers
    can apply for ATC status with the agreement from existing ATC's or TC chair
    as extra-ATC status.

- An OpenStack wide status
- TC seats are elected from and by the group of ATC's

.. note::

  - ATC's should be proposed into `projects.yaml
    <http://git.openstack.org/cgit/openstack/governance/tree/reference/projects.yaml>`_
    under ``extra-atcs`` of the actual project, but not after the
    `Extra-ATC's deadline <https://releases.openstack.org/pike/schedule.html#p-extra-atcs>`_
    of the cycle expired.

Active Project Contributor (APC)
================================

- Actively contributing to an OpenStack project

  - Also ATC
  - Attends project meetings
  - Participates in project related mail threads on the mailing lists

- OpenStack project specific status

Project Team Leads (PTLs)
=========================

- Elected from and by the group of APC's
- Each PTL candidate needs to submit PTL candidacy
- PTL responsibilities

  - Manage day-to-day operations
  - Drive the program goals
  - Resolve technical disputes
  - `Other responsibilities <https://docs.openstack.org/project-team-guide/ptl.html>`_

.. note::

  - The responsibilities of a PTL also depend on the project
    (Each project handles things a little differently).

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

Active User Contributors (AUC)
==============================

- Users with the following activities are recognized with AUC status:

  - Organizers of Official OpenStack User Groups
  - Active members and contributors to functional teams and/or working groups
  - Moderators of any of the operators' official meet-up sessions
  - Contributors to the repository under the UC governance
  - Track chairs for OpenStack Summits
  - Contributors to Superuser
  - Active moderators on ask.openstack.org

.. note::

  - `OpenStack User Committee Charter <https://governance.openstack.org/uc/reference/charter.html>`_

Exercise
========

- Determine who the current PTL is of your favorite project.
- Post their name, the project and a project goal for the next release in
  the Upstream Collaboration Training Etherpad.
- Find two other cores in the project and post their names in
  the Upstream Collaboration Training Etherpad.
