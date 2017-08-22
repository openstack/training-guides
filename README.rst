========================
Team and repository tags
========================

.. image:: https://governance.openstack.org/tc/badges/training-guides.svg
    :target: https://governance.openstack.org/tc/reference/tags/index.html

.. Change things from this point on

OpenStack Training Guides
+++++++++++++++++++++++++

This repository contains open source training material that can be
used to learn about using and different ways of contributing to OpenStack
(Upstream training).

For more details, see the `OpenStack Training Guides wiki page
<https://wiki.openstack.org/wiki/Training-guides>`_.

It includes:

 * Upstream training
 * Training guides (draft)

Both guides include a set of slides used in the training events.

Building
========

Various manuals are in subdirectories of the ``doc/`` directory.

Guides
------

All guides are in the RST format. You can use ``tox`` to prepare
virtual environment and build all guides::

    $ tox

You can find the root of the generated HTML documentation at::

    doc/upstream-training/build/slides/index.html
    doc/training-guides/build/slides/index.html


Testing of changes and building of the manual
=============================================

Install the Python tox package and run ``tox`` from the top-level
directory to use the same tests that are done as part of our Jenkins
gating jobs.

If you like to run individual tests, run:

 * ``tox -e checkbuild`` - to actually build all guides
 * ``tox -e upstream-slides`` - build the Upstream training
 * ``tox -e training-slides`` - build the Training guides

Contributing
============

Our community welcomes all people interested in open source cloud
computing, and encourages you to join the `OpenStack Foundation
<https://www.openstack.org/join>`_.

The best way to get involved with the community is to talk with others
online or at a meet up and offer contributions through our processes,
the `OpenStack wiki <https://wiki.openstack.org>`_, blogs, or on IRC at
``#openstack`` on ``irc.freenode.net``.

We welcome all types of contributions, from blueprint designs to
documentation to testing to deployment scripts.

If you would like to contribute to the documents, please see the
`OpenStack Documentation Contributor Guide
<http://docs.openstack.org/contributor-guide/>`_.

Bugs
====

Bugs should be filed on Launchpad, not GitHub:

   https://bugs.launchpad.net/openstack-training-guides


Published guides
================

Guides are published at:

 * http://docs.openstack.org/upstream-training/
 * http://docs.openstack.org/draft/training-guides/