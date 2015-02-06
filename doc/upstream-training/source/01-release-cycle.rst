=======================
OpenStack Release Cycle
=======================

 <teacher name>
 <date>

----

Planning : Design
=================

.. rst-class:: colleft

- Planning stage is at the start of a cycle
- take a step back
- focus on what we want to do for the next one

.. image:: ./_assets/01-01-release.png


----

Planning : Discuss
==================

.. rst-class:: colleft

- With our peers
- feedback and comments
- create the corresponding blueprint
- 4 weeks, Design Summit on the third week

.. image:: ./_assets/01-01-release.png

----

Planning : Target
=================

.. rst-class:: colleft

- file new blueprints and/or specs
- set a target milestone
- when in the cycle they intend to complete it
- PTLs triage the submitted blueprints and set priority

.. rst-class:: colright

.. image:: ./_assets/01-01-release.png

----

Implementation : Milestone
==========================

.. rst-class:: colleft

- pushed to our Gerrit review
- weeks before the milestone publication date
- milestone-proposed branch
- feature-frozen

.. rst-class:: colright

.. image:: ./_assets/01-01-release.png

----

Implementation : freezes
========================

.. rst-class:: colleft

* Feature proposal freeze

  * not even proposals for features will be accepted
  * focus on bug-fixing

* Feature freeze

  * new features will not be accepted, only fixes

* String freeze

  * all externally visible strings must be frozen
  * this helps the translation and documentation program

.. rst-class:: colright

.. image:: ./_assets/01-01-release.png

----

Release Candidates
==================

.. rst-class:: colleft

- After the last milestone
- file bugs about everything you find
- prioritize bugs / bug triage
- write documentation
- fix as many bugs as you can

.. rst-class:: colright

.. image:: ./_assets/01-01-release.png

----

Release candidate 1
===================

.. rst-class:: colleft

- Between the last milestone and the RC1
- stop adding features and concentrate on bug fixes
- Once all the release-critical bugs are fixed, we produce the first release
  candidate for that project (RC1)
- used as-is as the final release


.. rst-class:: colright

.. image:: ./_assets/01-01-release.png

----

Other release candidates
========================

.. rst-class:: colleft

- regressions and integration issues
- new release-critical bugs
- (RC2), with bugs targeted to it
- merged in the master branch first
- repeated as many times as necessary

.. rst-class:: colright

.. image:: ./_assets/01-01-release.png

----

Release day
===========

.. rst-class:: colleft

- last published release candidate
- published collectively as the OpenStack release

.. rst-class:: colright

.. image:: ./_assets/01-01-release.png

----

Exercise
========


Based on the Icehouse release schedule, find the URL of a document or a patch
that belongs to each of the steps.
