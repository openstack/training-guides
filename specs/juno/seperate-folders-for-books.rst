..
 This work is licensed under a Creative Commons Attribution 3.0 Unported
 License.

 http://creativecommons.org/licenses/by/3.0/legalcode

==========================
Separate folders for books
==========================

https://blueprints.launchpad.net/openstack-training-guides/+spec/separate-folders-for-books

Problem description
===================

The XML files for the training guides are all in the doc folder, which makes it
difficult to see the layout of the repository. To make it easier, each guide
will have its own folder and the XML files for each guide will reside in the
folder for that guide. The XML files will lie under the respective book. This
structure should make it easier to manage the guides. For example, the Associate
Guide, which currently resides in `../doc/training-guides/` will be moved to
`../doc/training-guides/associate-guide/`. The same changes apply for other
books.

Proposed change
===============

* Create guide-specific folders under `../doc/training-gudies/`.
* Move and refactor XML files specific to each book to its respective folder.
  layout.
* The output for guides is unchanged. A single PDF file is generated for all
  training guides.

Alternatives
------------
None

Data model impact
-----------------
None

REST API impact
---------------
None

Security impact
---------------
None

Notifications impact
--------------------
None

Other end user impact
---------------------
None

Performance Impact
------------------
None

Other deployer impact
---------------------
None

Developer impact
----------------
None

Implementation
==============

Assignee(s)
-----------
dguitarbite

Work Items
----------
* Migrate existing XML files to new folders.
* Refactor, rename the XML files if required.

Dependencies
============
training-manuals

Testing
=======
None

Documentation Impact
====================
None

References
==========
None
