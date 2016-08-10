===================================
Using OpenStack Dashboard (Horizon)
===================================

.. figure:: ../figures/os_background.png
   :class: fill
   :width: 100%

How can I use an OpenStack cloud?
=================================

- Using the OpenStack Dashboard

  - Horizon, a web-based graphical interface

- Using command-line clients

  - Let users run simple commands to create and manage resources
    in a cloud and automate tasks by using scripts
  - OpenStack Client brings commands in a single shell with a
    uniform command structure

.. note::

    - The official OpenStack programs had its own command-line client.
      These clients are now deprecated in favor of OpenStack Client.
    - For more details on OpenStack Client, see `OpenStack Command-Line
      Interface Reference <http://docs.openstack.org/cli-reference>`_

OpenStack Dashboard (Horizon)
=============================

- Enables cloud end users to provision their own resources
- Allows cloud administrators to monitor and control cloud resources
- Supported Web browsers

  - Web browsers with HTML5, cookies and JavaScript
  - To use the VNC console for the Dashboard (based on noVNC)

    - The browser must support HTML5 Canvas and HTML5 WebSockets

.. note::

    - For more details and a list of browsers that support noVNC, see
      https://github.com/kanaka/noVNC/blob/master/README.md, and
      https://github.com/kanaka/noVNC/wiki/Browser-support, respectively.

Log in to the Dashboard
=======================

- Open a Web browser
- Enter the host name or IP address with an URL format, like:

  - https://IP_ADDRESS_OR_HOSTNAME/

- On the Dashboard log in page

  - Enter user name and password
  - Click Sign In.

.. note::

    - You may input a sub URL depending on different environments
      such as Linux distributions and additional configurations.
    - For example, Ubuntu uses /horizon sub URL by default.

Dashboard - Overview
====================

- For admin users

  - Top-level row shows the username that you logged in with
  - Also access Settings or Sign Out of the Web interface

.. image:: ../figures/horizon-main-dashboard.png

Dashboard - Project tab
=======================

- Details for the projects, or projects, which you are a member of.

  - Overview
  - Instances
  - Volumes
  - Images & Snapshots
  - Access & Security

Dashboard - Project tab (cont)
==============================

- Overview

  - Shows basic reports on the project

Dashboard - Project tab (cont)
==============================

- Instances

  - Lists instances and volumes created by users of the project
  - From here, you can stop, pause, or reboot any instances or connect to
    them through VNC console.

Dashboard - Project tab (cont)
==============================

- Volumes

  - Lists volumes created by users of the project
  - From here, you can create or delete volumes.

Dashboard - Project tab (cont)
==============================

- Images & Snapshots

  - Lists images and snapshots that are available in the project
  - Images are used to create or rebuild instances on the cloud.
  - Snapshots are point-in-time copies of a storage volume or image.
  - From here, you can manage (create, remove, update, and delete) images
    and snapshots, and launch instances from images and snapshots.

Dashboard - Project tab (cont)
==============================

- Access & Security

  - Security Groups tab: list, create, and delete security groups and edit
    rules for security groups
  - Keypairs tab: list, create, import, and delete keypairs
  - Floating IPs tab: allocate an IP address to or release it from a project
  - API Access tab: list the API endpoints

Manage images
=============

- During setup of OpenStack cloud, the cloud operator sets user permissions
  to manage images.
- Image upload and management might be restricted to only cloud
  administrators or cloud operators.
- Though you can complete most tasks with the OpenStack Dashboard, you can
  manage images through only the glance and nova clients or the Image
  Service and Compute APIs.

Set up access and security
==========================

- Before you launch a virtual machine, you can add security group rules to
  enable users to ping and SSH to the instances.
- To do so, you either add rules to the default security group or add a
  security group with rules. See `Add a rule to the default security group <http://docs.openstack.org/user-guide/configure_access_and_security_for_instances.html#add-a-rule-to-the-default-security-group>`_.
- Keypairs are SSH credentials that are injected into images when they are
  launched. For this to work, the image must contain the cloud-init package.
  See `Add a key pair <http://docs.openstack.org/user-guide/configure_access_and_security_for_instances.html#add-a-key-pair>`_.

Add security group rules
========================

- To add rules to the default security group

  - Log in to the OpenStack Dashboard.
  - If you are a member of multiple projects, select a project from the
    drop-down list at the top of the Project tab.
  - Click the Access & Security category.

Add security group rules (cont)
===============================

  - The Dashboard shows the security groups that are available for this
    project.

.. image:: ../figures/horizon-secgroup-list.png

Add security group rules (cont)
===============================

  - Select the default security group and click Edit Rules
  - The Security Group Rules page appears:

.. image:: ../figures/horizon-secgroup-edit.png

Add keypairs
============

- Create at least one keypair for each project.
- If you have generated a keypair with an external tool, you can import it
  into OpenStack.
- The keypair can be used for multiple instances that belong to a project.
- To add a keypair: see `Add a key pair <http://docs.openstack.org/user-guide/configure_access_and_security_for_instances.html#add-a-key-pair>`_.
- To import a keypair: see `Import a key pair <http://docs.openstack.org/user-guide/configure_access_and_security_for_instances.html#import-a-key-pair>`_.
- The public key of the keypair is registered in the Nova database.
- The Dashboard lists the keypair in the Access & Security category.

Launch instances
================

- Instances are virtual machines that run inside the cloud.
- You can launch an instance directly from one of the available OpenStack
  images or from an image that you have copied to a persistent volume.
- The OpenStack Image Service provides a pool of images that are accessible
  to members of different projects.
- See `Launch and manage instances <http://docs.openstack.org/user-guide/dashboard_launch_instances.html>`_.

OpenStack Dashboard - Instances
===============================

- Using Instances, you can do:

  - Launch an instance from an image
  - Launch an instance from a volume
  - Create instance snapshots

.. image:: ../figures/horizon-instances.png

OpenStack Dashboard - Actions
=============================

- Control the state of an instance

.. image:: ../figures/horizon-actions.png

OpenStack Dashboard - Track Usage
=================================

- Use the Dashboard's Overview category to track usage of instances for each
  project.

.. image:: ../figures/horizon-main-dashboard.png

OpenStack Dashboard - Track Usage (cont)
========================================

- You can track costs per month by showing metrics like number of VCPUs,
  disks, RAM, and uptime of all your instances.
- To track usage

  - If you are a member of multiple projects, select a project from the
    drop-down list at the top of the Project tab.
  - Select a month and click Submitto query the instance usage for that month.
  - Click Download CSV Summaryto download a CVS summary.

Manage volumes
==============

- Volumes are block storage devices that you can attach to instances.
- They allow for persistent storage as they can be attached to a running
  instance, or detached and attached to another instance at any time.
- In contrast to the instance's root disk, the data of volumes is not
  destroyed when the instance is deleted.
- In Manage volumes, you can do:

  - Create or delete a volume
  - Attach and detach volumes to instances
