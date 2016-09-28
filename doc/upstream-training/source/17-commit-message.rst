===============
Commit messages
===============

.. image:: ./_assets/os_background.png
   :class: fill
   :width: 100%

Commit messages
===============

- quality of the OpenStack git history
- carrot by alerting people to the benefits
- anyone doing Gerrit code review can act as the stick
- review the commit message, not just the code
- Developers read mostly, write occasionally
- https://wiki.openstack.org/wiki/GitCommitMessages

Bad: two independent changes
=============================

.. image:: ./_assets/17-01-bad-two.png

Bad: new feature and refactor
==============================

.. image:: ./_assets/17-02-bad-new.png

Good: new API + new feature
============================

.. image:: ./_assets/17-03-good.png

Contents of a Commit Message (Summary Line)
===========================================

- Limited to 50 characters
- Succinctly describes patch content

Contents of a Commit Message (Body)
===================================

- Lines limited to 72 characters
- Explaination of issue being solved and why it should be fixed
- Explain how problem is solved
- Other possible content
    - Does it improve code structure?
    - Does it fix limitations of the current code?
    - References to other relevant patches?

Do not assume ...
=================

- The reviewer understands what the original problem was
- The reviewer has access to external web services/site
- The code is self-evident/self-documenting

Required external references
============================

- Change-id
- Bug (Partial-Bug, Related-Bug, Closes-Bug)
- Blueprint (Partial-Implements, Implements)

Optional external references
============================

- DocImpact
- APIImpact
- SecurityImpact
- UpgradeImpact
- Depends-On

GIT commit message structure
============================

.. image:: ./_assets/17-04-commit-message.png

Exercise
========

Review each other’s commit messages on the draft
