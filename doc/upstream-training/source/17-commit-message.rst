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

Structural split of changes
===========================

- Small means quicker & easier
- Easier to revert
- Easier to bisect
- Easier to browse

Things to avoid
===============

- Mixing whitespace changes with functional code changes.
- Mixing two unrelated functional changes.
- Sending large new features in a single giant commit.

Bad: two independent changes
=============================

.. image:: ./_assets/17-01-bad-two.png

Bad: new feature and refactor
==============================

.. image:: ./_assets/17-02-bad-new.png

Good: new API + new feature
============================

.. image:: ./_assets/17-03-good.png

Do not assume ...
=================

- the reviewer understands what the original problem was.
- the reviewer has access to external web services/site.
- the code is self-evident/self-documenting.

Information in commit messages (1/2)
====================================

- Describe why a change is being made
- Read the commit message to see if it hints at improved code structure.
- Ensure sufficient information to decide whether to review.

Information in commit messages (2/2)
====================================

- Describe any limitations of the current code.
- Do not include patch set-specific comments.
- The first commit line is the most important.

Required external references
============================

- Change-id
- Bug
- blueprint

Optional external references
============================

- DocImpact
- SecurityImpact
- UpgradeImpact

GIT commit message structure
============================

.. image:: ./_assets/17-04-commit-message.png

Exercise
========

Review each other’s commit messages on the draft
