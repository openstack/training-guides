=============
launchpad.net
=============

.. rst-class:: colright

|  <teacher name>
|  <date>

launchpad.net
=============

.. image:: ./_assets/13-01-launchpad.png
  :width: 100%

Blueprint
=========

- a forum for listing and planning specifications for work to be done
- a blueprint is a description of a solution
- a title
- a description
- longer-form go on a wiki page
- Most of the projects now manage blueprints on a git repo called specs
- https://wiki.openstack.org/wiki/Blueprints#Nova
- https://wiki.openstack.org/wiki/Blueprints#Neutron

Bug status
==========

- New: The bug was just created
- Incomplete: The bug is waiting on input from the reporter
- Confirmed: The bug was reproduced or confirmed as a genuine bug
- Triaged: The bug comments contain a full analysis on how to properly fix the
  issue
- In Progress: Work on the fix is in progress, bug has an assignee
- Fix Committed: The branch containing the fix was merged into master
- Fix Released: The fix is included in the milestone-proposed branch, a past
  milestone or a past release

Bug status
==========

- Invalid: This is not a bug
- Opinion: This is a valid issue, but it is the way it should be
- Won't Fix: This is a valid issue, but we don't intend to fix that

Bug status
==========

- New
- Incomplete
- Confirmed
- Triaged
- In Progress
- Fix Committed
- Fix Released
- Invalid
- Opinion
- Won't Fix

Bug importance
==============

- Critical: Data corruption / complete failure affecting most users, no
  workaround
- High: Data corruption / complete failure affecting most users, with
  workaround
- Failure of a significant feature, no workaround
- Medium: Failure of a significant feature, with workaround
- Failure of a fringe feature, no workaround
- Low: Small issue with an easy workaround. Any other insignificant bug
- Wish list: Not really a bug, but a suggested improvement
- Undefined: Impact was not assessed yet

Bug importance
==============

- Critical
- High
- Failure
- Medium
- Failure
- Low
- Wishlist
- Undefined

Bug tags
========

- low-hanging-fruit: Bugs that are easy to fix, ideal for beginners to get
  familiar with the workflow and to have their first contact with the code in
  OpenStack development.
- documentation: Bug is about documentation or has an impact on documentation.
- i18n: Translations / i18n issues.
- security: Fix for the bug would make OpenStack more resilient to future
  security issues.
- ops: Fix for the bug would significantly ease OpenStack operation.

Bug tags
========

- SERIES-rc-potential: During the SERIES pre-release period, mark the bug as a
  potential release-critical blocker
- SERIES-backport-potential: Mark the bug as a potential backport target to a
  specific SERIES (grizzly, havana...)
- Per project tags: https://wiki.openstack.org/wiki/BugTags

Bug
===

- Assigned To: The person currently working to fix this bug. Must be set by
  In progress stage.
- Milestone: The milestone we need to fix the bug for, or the
  milestone/version it was fixed in.

Bug report
==========

- file it against the proper OpenStack project
- check for duplicates
- The release, or milestone, or commit ID
- Status: New

Confirming & prioritizing
=========================

- lacking information => Status: Incomplete
- reproduced the issue => Status: Confirmed
- core developer or a member of the project bug supervision team =>
  Importance: <Bug impact>

Debugging
=========

- determining how to fix the bug
- optional if straightforward
- ask a core developer or bug supervisor => Status: Triaged

Bug fixing
==========

- developer work on a fix
- Status: In progress
- Assignee: the developer working on the fix
- Gerrit will automatically set the status

After the change is accepted
============================

- reviewed, accepted, and has landed in master
- Status: Fix Committed
- milestone or release branch
- Milestone: Milestone the bug was fixed in
- Status: Fix Released

Exercise
========

Review other launchpad bugs and improve yours.
