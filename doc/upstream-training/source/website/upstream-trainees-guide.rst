============================================
OpenStack Upstream Institute Trainees' Guide
============================================

.. _prepare-environment:

How to prepare
==============

* Make sure you have a wifi enabled laptop with you.
* Download the prepared virtual machine image and some environment
  for running the image (We suggest VirtualBox):

  * Image: http://bit.ly/vm-2020-virtual-v1

* Prepare an environment by yourself from scratch:

  * Create a virtual machine on your laptop with Ubuntu 16.04 installed and
    6+ GB of RAM.
  * Alternatively, you can use your virtual machine on a public cloud.
  * Check that you can ssh from your laptop to the virtual machine
  * Check that :command:`apt install` works on the virtual machine
  * Read and complete the
    `Setup IRC <https://docs.openstack.org/contributors/common/irc.html>`_
    guide.

* Go to the `Account Setup
  <https://docs.openstack.org/contributors/common/accounts.html>`_
  page and complete the steps documented there to setup your OpenStack
  Foundation Account and accounts for accessing OpenStack's bug and task
  tracking systems.
* Prepare git in the virtual machine that was created above:

  * Complete the ``Configure Git`` steps documented on the
    `Setup and Learn GIT
    <https://docs.openstack.org/contributors/common/git.html>`_
    page.  If you are not familiar with Git you may want to also read the
    content under the ``Learning Git`` section.
  * Go to the `Setting Up Your Gerrit Account
    <https://docs.openstack.org/contributors/common/setup-gerrit.html>`_
    page and follow the steps for ``Sign Up``,
    ``Individual Contributor License Agreement``,
    and optionally, the ``Setup SSH Keys``.

.. note::
   Aside from the sections above, we will cover everything else that is in
   `the Contributor Guide <https://docs.openstack.org/contributors/>`_ during
   the classes.

.. note::
   If you are attempting the steps above before the Upstream Institute class
   and need assistance you can find mentors in the #openstack-upstream-institute
   channel on irc.oftc.net.
