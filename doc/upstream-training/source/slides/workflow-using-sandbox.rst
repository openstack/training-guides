==========================
Using Sandbox for Practice
==========================

.. image:: ./_assets/os_background.png
   :class: fill
   :width: 100%

.. note::
   Tags: [new_dev]

Sandbox repository
==================

- OpenStack has a sandbox repository for learning and testing purposes
- Great repository to begin your OpenStack learning

  - https://git.openstack.org/cgit/openstack-dev/sandbox

.. image:: ./_assets/sandbox-git-repo-website.png
  :width: 95%
  :align: center

Sandbox Launchpad
=================

- To manage and track the reported bugs and issues related with
  openstack-dev/sandbox repository

  - https://launchpad.net/openstack-dev-sandbox

.. image:: ./_assets/sandbox-lp-website.png
  :width: 95%
  :align: center

Learning example with two Sandboxes
===================================

- The following slides demonstrate using the Sandbox repository
  and Launchpad to:

  - Report a bug on Launchpad
  - Read the bug description and assign yourself to fix the bug
  - Upload a patch and invite a peer as a reviewer
  - Review the patch and give feedback with comments
  - Upload a revised patch with comment
  - Review the revised patch and merge the patch

 .. note::
  - Try to emphasize the synergy of using repository integration
    with bug management to students!

Sandbox Launchpad Bug list
==========================

- https://bugs.launchpad.net/openstack-dev-sandbox

.. image:: ./_assets/sandbox-list-bugs.png
  :width: 80%
  :align: center

Report a bug - Summary
======================

- We have seen in `Overview of the contribution process
  <workflow-training-contribution-process.html#5>`_
- https://bugs.launchpad.net/openstack-dev-sandbox/+filebug

.. image:: ./_assets/sandbox-report-a-bug-summary.png
  :width: 80%
  :align: center

Report a bug - Details
======================

- (A real bug report needs a more detailed description.)

.. note::

  - Detailed description should include the OpenStack release that
    was running, log snippets showing the error, steps to recreate the error
    and any vendor hardware possibly involved.
  - Details need to be sufficient for a developer to narrow down where
    the failure occurred and/or recreate the failure.

.. image:: ./_assets/sandbox-report-a-bug-details.png
  :width: 80%
  :align: center

Bug Report Submission
=====================

- Successful bug report submission

.. image:: ./_assets/sandbox-report-a-bug-submission.png
  :width: 80%
  :align: center

Bug Assigning
=============

- To notify others that someone is working on the bug

.. image:: ./_assets/sandbox-lp-assign.png
  :width: 80%
  :align: center

.. note::

  - Should not take the bug if you are not planning to work on the bug.

Bug Assigned
============

- (Other people will assume the person is working on the bug.)

.. image:: ./_assets/sandbox-lp-assignee-changed.png
  :width: 80%
  :align: center

Local branch creation
=====================

- We have seen in
  `Setup & First patch <workflow-setup-and-first-patch.html#6>`__

.. code-block:: console

  $ git checkout -b [BRANCH_NAME]

.. image:: ./_assets/sandbox-git-checkout-branch.png
  :width: 80%
  :align: center

Working to get a commit
=======================

- (As an example, a new file has been created using cat command.)

.. image:: ./_assets/sandbox-git-new-file.png
  :width: 80%
  :align: center

Checking work status
====================

- Current branch name information
- File status in the working repository

.. code-block:: console

  $ git status

.. image:: ./_assets/sandbox-git-status.png
  :width: 80%
  :align: center

Add the file and commit
=======================

.. code-block:: console

  $ git add [FILE_PATH]
  $ git commit -a

- Writing 'Related-Bug: #[Bug number in Lanuchpad]' on message content

  - We have seen in `Commit Messages <workflow-commit-message.html#8>`__

.. image:: ./_assets/sandbox-git-commit-message.png
  :width: 80%
  :align: center

Commit log message
==================

- (Checking the log message before uploading is a best practice.)

.. code-block:: console

  $ git log

.. image:: ./_assets/sandbox-git-log.png
  :width: 80%
  :align: center

Uploading to Gerrit
===================

.. code-block:: console

  $ git review master

(Note: In some environments need to use 'git-review master')

.. image:: ./_assets/sandbox-git-review.png
  :align: center

Sandbox Status
==============

- Gerrit (openstack-dev/sandbox repository)

.. image:: ./_assets/sandbox-gerrit-submission.png
  :width: 90%
  :align: center

- Launchpad (openstack-dev-sandbox)

.. image:: ./_assets/sandbox-lp-message-added.png
  :width: 80%
  :align: center

Invite peer as Reviewer
=======================

- We have seen in `Gerrit <workflow-gerrit.html#5>`__

- (Find reviewer by Gerrit username or e-mail address.)

.. image:: ./_assets/sandbox-gerrit-add-reviewer.png
  :width: 80%
  :align: center

Added as Reviewer
=================

- (Review invitation letter has been sent by e-mail.)

.. image:: ./_assets/sandbox-gerrit-add-reviewer-added.png
  :width: 80%
  :align: center

Reading review invitation
=========================

- Review invitation letter

.. image:: ./_assets/sandbox-review-invitation.png
  :width: 80%
  :align: center

Reviewing with comment
======================

- Commenting

.. image:: ./_assets/sandbox-reviewer-commenting.png
  :width: 80%
  :align: center

- Draft comment was saved

.. image:: ./_assets/sandbox-reviewer-comment.png
  :width: 80%
  :align: center

Publish comment
===============

- (Draft comments are not visible to others.)

.. image:: ./_assets/sandbox-reviewer-publish-comment.png
  :width: 80%
  :align: center

Review Score & Results
======================

- Score will reflect reviewer's opinion.

.. image:: ./_assets/sandbox-reviewer-scoring.png
  :width: 80%
  :align: center

- Results will be accumulated in History.

.. image:: ./_assets/sandbox-reviewer-comment-results.png
  :width: 80%
  :align: center

Check peer's Review
===================

- Review score with written comments

.. image:: ./_assets/sandbox-committer-checking.png
  :width: 80%
  :align: center

- Do not be frustrated!
  We can revise the current patchset to address comments.

Revising file(s)
================

- Start work from latest patchset

.. image:: ./_assets/sandbox-committer-revise.png
  :width: 80%
  :align: center

Amending the commit
===================

- We have seen in
  `Setup & First Patch <workflow-setup-and-first-patch.html#8>`__

- (Please also change your commit message if needed.)

.. code-block:: console

  $ git commit -a --amend

.. image:: ./_assets/sandbox-committer-amending.png
  :width: 80%
  :align: center

Uploading a new patchset
========================

- Executing "git review" command will submit the amended commit.

.. image:: ./_assets/sandbox-committer-git-review-again.png
  :width: 80%
  :align: center

- New patchset was recorded in Gerrit.

.. image:: ./_assets/sandbox-gerrit-another-patchset.png
  :width: 80%
  :align: center

Seeing new comment
==================

- Since the written comment is in the previous patchset, select patchset 1,
  and choose the file which has comment(s).

.. image:: ./_assets/sandbox-gerrit-patchsets.png
  :width: 50%
  :align: center

.. image:: ./_assets/sandbox-gerrit-click-file.png
  :width: 80%
  :align: center

Comment reply
=============

- Answering reviewer's comment(s) is a best practice.
- Click 'Reply' and write your message, or just 'Done' for "Done" message.

.. image:: ./_assets/sandbox-gerrit-checking-comment.png
  :width: 80%
  :align: center

.. image:: ./_assets/sandbox-gerrit-checking-comment-answer.png
  :width: 80%
  :align: center

.. image:: ./_assets/sandbox-gerrit-still-draft-comment.png
  :width: 80%
  :align: center

Publish comment reply
=====================

- Draft comment publishment

.. image:: ./_assets/sandbox-gerrit-publish-comment.png
  :width: 80%
  :align: center

- (Ensure that your comment is being shown in History.)

.. image:: ./_assets/sandbox-gerrit-comment-publish-result.png
  :width: 80%
  :align: center

Review again
============

- Code-Review -1/0/+1 is for all OpenStack reviewers

.. image:: ./_assets/sandbox-bug-reporter-review.png
  :width: 50%
  :align: center

- Code-Review -2/+2 is for core reviewers (Sandbox repository is open)
- The Gerrit review will be merged by +1 in Workflow

.. image:: ./_assets/sandbox-core-reviewer-score.png
  :width: 50%
  :align: center

Merged!
=======

- Score status

.. image:: ./_assets/sandbox-scores.png
  :width: 60%
  :align: center

- History status

.. image:: ./_assets/sandbox-gerrit-merged.png
  :width: 80%
  :align: center

Home Work
=========

- You can practice the skills documented in the previous slides.
- Create a few different changes and submit new patchsets
  to those few changes in the Sandbox repository for one bug in Launchpad.
- Cleaning up activities are needed

  - Includes the deletion of uploaded files on Sandbox repository
    and change of bug status in Launchpad to "Invalid", "Won't Fix",
    or "Fix Released"
  - During upstream training, do not worry about this! Upstream training
    leaders will clean up after the training is finished.
  - However, please keep in mind that it is on your own responsibility.

 .. note::
  - Please do not let students create 10 or more changes.
    (This is not the intention of Sandboxes!)
  - https://docs.openstack.org/infra/manual/sandbox.html
