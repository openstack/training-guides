=======================
OpenStack Documentation
=======================

.. image:: ./_assets/os_background.png
   :class: fill
   :width: 100%

.. note::
   Tags: [operator] [user] [new_dev] [dev]

Mission
=======

- Provide documentation for core OpenStack projects to promote OpenStack.
- Develop and maintain tools and processes to ensure quality, accurate
  documentation.
- Treat documentation like OpenStack code.

Sites
=====

- https://docs.openstack.org
- https://developer.openstack.org

Documentation team structure
============================

- Specialty teams

  - API, Contributor Guide, Security Guide, Training Guides, Training Labs

- `Docs cores <https://review.openstack.org/#/admin/groups/30,members>`_
  and separate core teams for `docs-specs <https://review.openstack.org/#/admin/groups/384,members>`_
  , `contributor-guide <https://review.openstack.org/#/admin/groups/1841,members>`_
  , `security-doc <https://review.openstack.org/#/admin/groups/347,members>`_
  , `training-guides <https://review.openstack.org/#/admin/groups/360,members>`_
  , and `training-labs <https://review.openstack.org/#/admin/groups/1118,members>`_

- `Documentation cross-project liaisons <https://wiki.openstack.org/wiki/CrossProjectLiaisons#Documentation>`_
  for questions, reviews, doc bug triaging, and patching docs

Repositories
============

- `Official deliverables with repositories <https://governance.openstack.org/tc/reference/projects/documentation.html#deliverables>`_
- Project repos have installation tutorials and developer documentation

  - Example: `Heat repository <https://git.openstack.org/cgit/openstack/heat/tree/>`_

    - `Developer documentation <https://docs.openstack.org/heat/>`_
      is published from doc directory in master branch
    - `Installation Tutorial (Ocata) <https://docs.openstack.org/project-install-guide/orchestration/ocata/>`_
      is published from install-guide directory in stable/ocata branch

Bug reports
===========

- https://bugs.launchpad.net/openstack-manuals
- https://bugs.launchpad.net/openstack-api-site
- https://bugs.launchpad.net/openstack-training-guides
- https://storyboard.openstack.org/#!/project/913

Contributor guide
=================

- https://docs.openstack.org/contributor-guide/index.html

This guide provides detailed instructions on the contribution workflow and
conventions to be considered by all documentation contributors.

Building documentation
======================

- https://docs.openstack.org/contributor-guide/docs-builds.html

EOL documents
=============

- EOL documents are not maintained in the documentation repositories,
  the content is frozen, but published documents are accessible by
  `retention policy <http://specs.openstack.org/openstack/docs-specs/specs/queens/retention-policy.html>`_

  - See EOL status at: https://releases.openstack.org
