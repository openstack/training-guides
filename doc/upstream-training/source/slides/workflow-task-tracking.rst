=============
Task Tracking
=============

.. image:: ./_assets/os_background.png
   :class: fill
   :width: 100%


Tracked Items
=============

- Bugs:
  - Issues with current code
  - Items that need to be changed or updated

- New Features:
  - Specs are formal write ups of implementations that affect the whole project
  - Specs live in a per project repository

.. note::
   We go into blueprints in the next few slides, so just mention them
   for now.

Launchpad
=========

- Task tracking tool most widely used in the community
- Being phased out over the next few releases
- Tasks are classified as blueprints or bugs

.. note::
   Launchpad uses blueprints and bugs as the trackable items
   work supplemented with specs.

Blueprints
==========

- A place for listing and planning specifications for work to be done
- A blueprint is a description of a solution
- Blueprints can have an associated spec

Bugs
====

- Filed against a specific Openstack project(s)
- Statuses: New, Incomplete, Confirmed, Triaged, In Progress, Fix Committed,
  Fix Released, Invalid, Opinion, Won't Fix
- Tags: low-hanging-fruit, documentation, security, other per project tags
  -  https://wiki.openstack.org/wiki/BugTags

- Assignee: the developer working on the fix
- Gerrit will automatically set the status
- Importance and Milestones can only be set by cores of the project

Exercise
========

Create and submit a bug or blueprint to our sandbox repository. Include at
least one tag when creating your bug. Once it has been created, assign it
to yourself.

https://bugs.launchpad.net/openstack-dev-sandbox/+filebug

StoryBoard
==========

- New, open-source task tracking tool
- API first implementation
- Several projects have already migrated
- More kanban style structure
- Better for cross project coordination

.. note::
   Storyboard uses worklists, boards, stories, and tasks as the items
   for organizing and tracking work.

Worklists & Boards
==================

- Worklists are user defined groupings of stories and tasks that aid in the
  organization of work
- Each item on a worklist is placed on a 'card' in the worklist
- A board is a collection of worklists
- A possible setup could be a board is a project and the worklists on the board
  could be different releases or bugs versus implementations

Stories & Tasks
===============

- A story is a work item such as a bug or a new feature
- Stories can have tags to make them more searchable/filterable
- Tasks are the steps required to complete the story
  - Tests
  - Patches
  - Documentation
- Tasks have statuses similar to Launchpad items

Exercise
========

Create a worklist, with a story that has at least two tasks in the sandbox
enivronment. After it's been created assign the tasks to yourself.

https://storyboard-dev.openstack.org/
