=========================================
OpenStack Training Guides Specifications
=========================================

This git repository is used to hold approved design specifications for additions
to the Training Guides project.  Reviews of the specs are done in gerrit, using a similar
workflow to how we review and merge changes to the code itself.

The layout of this repository is::

  specs/<release>/

You can find an example spec in `/specs/template.rst`.

Specifications are proposed for a given release by adding them to the
`specs/<release>` directory and posting it for review.  The implementation
status of a blueprint for a given release can be found by looking at the
blueprint in launchpad.  Not all approved blueprints will get fully implemented.

Specifications have to be re-proposed for every release.  The review may be
quick, but even if something was previously approved, it should be re-reviewed
to make sure it still makes sense as written.

Approved specs will be created on Launchpad blueprints::

  http://blueprints.launchpad.net/openstack-training-guides

For more information about working with gerrit, see::

  http://docs.openstack.org/infra/manual/developers.html#development-workflow
