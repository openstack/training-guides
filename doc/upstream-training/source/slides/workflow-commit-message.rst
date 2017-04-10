===============
Commit Messages
===============

.. image:: ./_assets/os_background.png
   :class: fill
   :width: 100%

Commit Messages
===============

- The first thing a reviewer sees and it is as important as the code
- Brief explanation with context about the patch
- Provide a description of the history of changes in a
  repository
- Cannot be modified once merged
- Format:

  - Summary Line
  - Body
  - External References

- Guidelines: https://wiki.openstack.org/wiki/GitCommitMessages

Summary Line
=============

- Succinctly describes patch content
- Limited to 50 characters
- Should not end with a period

Exercise
========

Write a summary line for each of the following scenarios:

- Someone left a print statement that was used for testing during
  development that is being added to the logs.
- There are unused arguments being passed into a method that is
  used in several different files.
- A new capability was added to the project that should be
  implemented in all vendor drivers.

Share your favorite to our IRC channel.

Body
====

- Lines limited to 72 characters
- Explanation of issue being solved and why it should be fixed
- Explain how the problem is solved
- Other possible content

  - Does it improve code structure?
  - Does it fix limitations of the current code?
  - References to other relevant patches?

Exercise
========

Write a commit message body to expand on each of the following summary
lines. Feel free to make up details to make the context more realistic.
Share your favorite in IRC.

- Cleanup deprecated methods
- Minimize database queries
- Added unit tests to cover untested methods

Do not assume ...
=================

- The reviewer understands what the original problem was
- The reviewer has access to external web services/site
- The code is self-evident/self-documenting

External References
===================

- Required:

  - Change-Id
  - Task Tracking Info:

    - Bug (Partial-Bug, Related-Bug, Closes-Bug)
    - Blueprint (Partial-Implements, Implements)

- Additional External References:

  - DocImpact
  - APIImpact
  - SecurityImpact
  - UpgradeImpact
  - Depends-On

.. note::
   Explain the tags and when you use them. Documentation, API,
   Security or Upgrade Impacts are for patches with changes that
   alter the existing state. Depends-On is for cross repository
   dependencies. Change-Id's are filled in automatically with git
   review -s.

Exercise
========

Write a commit message for the bug you created during our earlier
exercise. Include a summary line, body, and the required exernal references
along with any optional external references you think it may benefit from.


Share the commit message with one or two people at your table. Give them
feedback on their commit messages.
