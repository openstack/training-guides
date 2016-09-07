=======================
OpenStack Release Cycle
=======================

.. image:: ./_assets/os_background.png
   :class: fill
   :width: 100%

What makes a release
====================

- A way to coordinate the development of multiple projects
- Until Kilo "integrated release" meant a date when all the projects
  are released at the end of the development cycles
- Integrated projects were also tested together at the gate
- For Liberty integrated projects are those managed by the Release
  Management Team
- Other projects may have different schedules

  - Each project team page shows its release policy on
    http://governance.openstack.org/reference/projects

Planning : Design
=================

.. rst-class:: colleft

- Planning stage is at the start of a cycle
- Take a step back
- Focus on what we want to do for the next one

.. rst-class:: colright

.. image:: ./_assets/01-01-release.png

Planning : Discuss
==================

.. rst-class:: colleft

- With our peers
- Feedback and comments
- Create the corresponding blueprint
- 4 weeks, Design Summit on the third week

.. rst-class:: colright

.. image:: ./_assets/01-01-release.png

Planning : Target
=================

.. rst-class:: colleft

- File new blueprints and/or specs
- Set a target milestone
- When in the cycle they intend to complete it
- PTLs triage the submitted blueprints and set priority

.. rst-class:: colright

.. image:: ./_assets/01-01-release.png

Implementation : Milestone
==========================

.. rst-class:: colleft

- Pushed to Gerrit for peer review
- Weeks before the milestone publication date
- Milestone-proposed branch
- Feature-frozen

.. rst-class:: colright

.. image:: ./_assets/01-01-release.png

Implementation : freezes
========================

.. rst-class:: colleft

- Feature proposal freeze

  - Not even proposals for features will be accepted
  - Focus on bug-fixing

- Feature freeze

  - New features will not be accepted, only fixes

- String freeze

  - All externally visible strings must be frozen
  - This helps the i18n and Documentation projects

.. rst-class:: colright

.. image:: ./_assets/01-01-release.png

Release Candidates
==================

.. rst-class:: colleft

- After the last milestone

  - File bugs about everything you find
  - Prioritize bugs / bug triage
  - Write documentation
  - Fix as many bugs as you can

.. rst-class:: colright

.. image:: ./_assets/01-01-release.png

Release candidate 1
===================

.. rst-class:: colleft

- Between the last milestone and the RC1

  - Stop adding features and concentrate on bug fixes
  - Once all the release-critical bugs are fixed, we produce the first release
    candidate for that project (RC1)
  - Used as-is as the final release


.. rst-class:: colright

.. image:: ./_assets/01-01-release.png

Other release candidates
========================

.. rst-class:: colleft

- Regressions and integration issues

  - New release-critical bugs

- (RC2), with bugs targeted to it

  - Merged in the master branch first
  - Repeated as many times as necessary

.. rst-class:: colright

.. image:: ./_assets/01-01-release.png

Release day
===========

.. rst-class:: colleft

- Last published release candidate
- Published collectively as the OpenStack release

.. rst-class:: colright

.. image:: ./_assets/01-01-release.png

Exercise
========

Based on the Kilo release schedule, find the URL of a document or a patch
that belongs to each of the steps.
