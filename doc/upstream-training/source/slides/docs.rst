=======================
OpenStack Documentation
=======================

.. image:: ./_assets/os_background.png
   :class: fill
   :width: 100%

Mission
=======

- Provide documentation for core OpenStack projects to promote OpenStack.
- Develop and maintain tools and processes to ensure quality, accurate
  documentation.
- Treat documentation like OpenStack code.

Sites
=====

- http://docs.openstack.org
- http://developer.openstack.org

Documentation team structure
============================

- Specialty teams

  - API, Security Guide, Training Guides, Training Labs

- `Docs cores <https://review.openstack.org/#/admin/groups/30,members>`_
  and separate core teams for `docs-specs <https://review.openstack.org/#/admin/groups/384,members>`_
  , `security-doc <https://review.openstack.org/#/admin/groups/347,members>`_
  , `training-guides <https://review.openstack.org/#/admin/groups/360,members>`_
  , and `training-labs <https://review.openstack.org/#/admin/groups/1118,members>`_

- `Documentation cross-project liaisons <https://wiki.openstack.org/wiki/CrossProjectLiaisons#Documentation>`_
  for questions, reviews, doc bug triaging, and patching docs

Repositories
============

- `Official deliverables with repositories <https://governance.openstack.org/tc/reference/projects/documentation.html#deliverables>`_
- Project repos can have installation tutorial and developer documentation

  - Example: `Heat repository <https://git.openstack.org/cgit/openstack/heat/tree/>`_

    - `Installation Tutorial (Ocata) <https://docs.openstack.org/project-install-guide/orchestration/ocata/>`_
      is published from install-guide directory in stable/ocata branch
    - `Developer documentation <https://docs.openstack.org/developer/heat/>`_
      is published from doc directory in master branch

Bug reports
===========

- https://bugs.launchpad.net/openstack-manuals
- https://bugs.launchpad.net/openstack-api-site
- https://bugs.launchpad.net/openstack-training-guides

Contributor guide
=================

- http://docs.openstack.org/contributor-guide/index.html

This guide provides detailed instructions on the contribution workflow and
conventions to be considered by all documentation contributors.

Building documentation
======================

- http://docs.openstack.org/contributor-guide/docs-builds.html

Draft documentation, testing, and EOL
=====================================

- https://docs.openstack.org/draft/draft-index.html
- Some documents (e.g., install-guides) require testing with releases
- EOL documents are not maintained in documentation repositories

  - See EOL status at: https://releases.openstack.org
