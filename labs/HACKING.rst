Contributing to training-labs scripts
=====================================

General
-------

Contributing code to training-labs scripts follows the usual OpenStack process
as described in `How To Contribute`__ in the OpenStack wiki.
Our `main blueprint`__ contains the usual links for blueprints, bugs, etc.

__ contribute_
.. _contribute: http://wiki.openstack.org/HowToContribute

__ lp_
.. _lp: https://blueprints.launchpad.net/openstack-training-guides/+spec/openstack-training-labs

Getting started
---------------

The main script is osbash.sh. It will call libraries and other scripts to build
the training-labs setup. The setup can be customized in labs/config where all
scripts keep their configuration files.

Prerequisites
-------------

The labs scripts are designed to have minimal dependencies: bash and
`VirtualBox <https://www.virtualbox.org/>`_. To support OS X, we keep the
host-side scripts compatible with bash 3.2 (don't use features not present in
that somewhat dated version).

For testing the generated Windows batch scripts, any supported version of
Windows (Vista and later) will do. After having created the batch files using
osbash.sh, just copy the whole labs directory to Windows. If you don't have
access to that operating system, comparing the output in labs/wbatch will tell
you how your changes affect behavior on that platform.

Coding style
------------

We follow the conventions of other OpenStack projects. Since labs scripts are
currently all written in bash, the examples to follow are this project and
`devstack <http://devstack.org/>`_.

DevStack bash style guidelines can be found at the bottom of:
https://github.com/openstack-dev/devstack/blob/master/HACKING.rst

Testing
-------

The labs scripts don't have automated tests yet. Patch submitters should be
aware of their responsibility for ensuring that their code works and can be
tested by reviewers.

Useful tools for checking scripts:

- `bashate <https://github.com/openstack-dev/bashate>`_ (must pass)
- `shellcheck <https://github.com/koalaman/shellcheck.git>`_ (optional)

Submitting patches
------------------

These documents will help you submit patches to OpenStack projects (including
this one):

- https://wiki.openstack.org/wiki/GerritWorkflow
- https://wiki.openstack.org/wiki/GitCommitMessages

If you change the behavior of the scripts as documented in the training-guides,
add a DocImpact flag to alert the documentation team. For instance, add a line
like this to your commit message:

DocImpact new option added to osbash.sh

- https://wiki.openstack.org/wiki/Documentation/DocImpact

Reviewing
---------

Learn how to review (or what to expect when having your patches reviewed) here:
- https://wiki.openstack.org/wiki/GerritWorkflow

Anything not covered here
-------------------------

Check README.md and get in touch with other scripts developers.

