#############
Account Setup
#############

Setup OpenStack Foundation Account
==================================

What is the OpenStack Foundation Account?
-----------------------------------------
Allows you to:

* Make code contributions.
* Vote in elections.
* Run for elected positions in the OpenStack project.
* Submit presentations to OpenStack conferences.

Sign Up
-------
.. note::

  Make sure to use the same email address you'll want to use for code
  contributions since it's important later that these match up.

#. Go to the `OpenStack Foundation sign up page
   <https://www.openstack.org/join>`_.
#. Under individual members, click the **Foundation Member** button.
#. Read through the presented individual member terms of service and our
   `Community Code of Conduct
   <https://www.openstack.org/legal/community-code-of-conduct/>`_.
#. Complete the application.

.. image:: _assets/account-setup/2.png


Setup Launchpad
===============

What is Launchpad?
------------------
Launchpad is how the OpenStack community does tracking for things like bug
reports. This account is also how we will identify ourselves in OpenStack's
code review system.

Sign Up
-------
#. Go to the `Launchpad login or create account page
   <https://launchpad.net/+login>`_
#. Click the **I am a new Ubuntu One user**.
#. Fill in your email address, name, password, and accepting the terms of
   services.

.. image:: _assets/account-setup/1.png


Setup Gerrit Account
====================

What is Gerrit?
---------------
This is the review system the OpenStack community uses. Here are just some of
the things we use Gerrit for reviewing:

* `Code <http://git.openstack.org/cgit>`_
* `Specifications <http://specs.openstack.org>`_
* `Translations <http://git.openstack.org/cgit/openstack/i18n/tree/>`_
* `Use cases for features
  <http://specs.openstack.org/openstack/openstack-user-stories/>`_

Sign Up
-------
#. Visit `OpenStack's Gerrit page <https://review.openstack.org>`_ and click
   the **sign in** link.
#. You will be prompted to select a username. You can enter the same one you
   did for launchpad, or something else.

.. note::

   Choose and type your username carefully.
   Once it is set, you cannot change the username.

.. note::

  From here on out when you sign into Gerrit, you'll be prompted to enter your
  your Launchpad login info. This is because Gerrit uses it as an OpenID single
  sign on.


Individual Contributor License Agreement
========================================

What is it?
-----------
An agreement to clarify intellectual property license granted with
contributions from a person or entity. `Preview the full agreement
<https://review.openstack.org/static/cla.html>`_.

Signing it
----------

Individual Contributors
^^^^^^^^^^^^^^^^^^^^^^^

#. In Gerrit's `settings <https://review.openstack.org/#/settings/agreements>`_
   click the **New Contributor Agreement** link and sign the agreement.

.. image:: _assets/account-setup/3.png

Contributors From a Company or Organization
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
If you are contributing on behalf of a company or organization.

#. In Gerrit's `settings <https://review.openstack.org/#/settings/agreements>`_
   click the **New Contributor Agreement** link and sign the agreement.

   .. image:: _assets/account-setup/3.png

#. An employer with the appropriate signing rights of the company or
   organization needs to sign the `Corporate Contributor License Agreement
   <https://secure.echosign.com/public/hostedForm?formid=56JUVGT95E78X5>`_.
#. If the CCLA only needs to be extended follow `this
   <https://wiki.openstack.org/wiki/HowToUpdateCorporateCLA>`_ procedure.

.. note::

  Employers can update the list of authorized employees by filling out and
  signing an `Updated Schedule
  A Form
  <https://openstack.echosign.com/public/hostedForm?formid=56JUVP6K4Z6P4C>`_.

Contributors From the U.S. Government
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
#. Someone of authority needs to sign the `U.S. Government Contributor License
   Agreement <https://wiki.openstack.org/wiki/GovernmentCLA>`_. Contact the
   `OpenStack Foundation <mailto:communitymngr@openstack.org>`_ to initiate
   this process.

Contact Information
===================

What is it?
-----------

You need to register your contact information including your full name, email
address and offline contact information.

Your full name and email address will be public and the email address needs to
match the email address which you plan to use in your commits.

The other contact information including postal address and phone numbers will
be kept confidential and is only used as a fallback record in the unlikely
event the OpenStack Foundation needs to reach you directly over code
contribution related matters.

This contact information can be easily updated later if desired, but make sure
the primary email address always matches the one you set for your OpenStack
Foundation Membership. Otherwise, Gerrit will give you an error message and
refuse to accept your contact information.

Register Contact Information
----------------------------

#. Visit `Contact Information
   <https://review.openstack.org/#/settings/contact>`__
   in Gerrit's settings.
#. Fill your contact information and click 'Save Changes'.
#. Once your contact information is saved successfully,
   you will see the line **"Contact information last updated ...."**
   just above the forms of mailing address.

.. image:: _assets/account-setup/4.png

.. note::

   If you do not register your contact information,
   you cannot upload your any changes to Gerrit.
