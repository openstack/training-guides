===============
Getting started
===============

.. figure:: ../figures/os_background.png
   :class: fill
   :width: 100%

Overview
========

- Associate Training will take one of the followings:
    - 1 month self paced
    - 2 week periods with a 2 hour user group meeting
    - 16 hours instructor led

Prerequisites
=============

- Working knowledge of Linux CLI, basic Linux SysAdmin skills (directory
  structure, vi, ssh, installing software)
- Basic networking knowledge (Ethernet, VLAN, IP addressing)
- Laptop with VirtualBox installed (highly recommended)

Introduction
============

OpenStack is a cloud operating system that controls large pools of compute,
storage, and networking resources throughout a data center, all managed
through a dashboard that gives administrators control while empowering users
to provision resources through a web interface.

.. note::

    - Cloud computing provides users with access to a shared collection of
      computing resources: networks for transfer, servers for storage, and
      applications or services for completing tasks.

Official Programs
=================

- The technology consists of a series of interrelated projects
- Six-month, time-based release cycle with frequent development milestones
- During the planning phase of each release, the community gathers for the
  OpenStack Design Summit to facilitate developer working sessions and
  assemble plans.

Release Cycle
=============

- Coordinated 6-month release cycle with frequent development milestones

  - Current development release: https://wiki.openstack.org/wiki/Release_Cycle

- The Release Cycle

  - Made of four major stages: Planning, Implementation, Pre-release, Release

.. image:: ../figures/image05.png

*Community Heartbeat*

.. note::

    - OpenStack is a true and innovative open standard. For more user stories,
      see http://www.openstack.org/user-stories.

Governance
==========

- OpenStack is governed by a non-profit foundation and its board of directors,
  a technical committee and a user committee.

- The foundation's stated mission is by providing shared resources to help
  achieve the OpenStack Mission by Protecting, Empowering, and Promoting
  OpenStack software and the community around it, including users, developers
  and the entire ecosystem.

Conceptual Architecture
=======================

- The OpenStack project as a whole is designed to deliver a massively scalable
  cloud operating system. To achieve this, each of the constituent services are
  designed to work together to provide a complete Infrastructure-as-a-Service
  (IaaS).

- This integration is facilitated through public application programming
  interfaces (APIs) that each service offers (and in turn can consume).

Conceptual Architecture (cont)
==============================

.. image:: ../figures/image13.jpg

*Conceptual Diagram*

.. note::

    - The conceptual diagram is a stylized and simplified view of the
      architecture. It assumes that the implementer uses all services in the
      most common configuration. It also shows only the operator side of the
      cloud; it does not show how consumers might use the cloud. For example,
      many users directly and heavily access object storage.

Conceptual Architecture (cont)
==============================

- Dashboard ("horizon") provides a web front end to the other
  OpenStack services.
- Compute service ("nova") stores and retrieves virtual disks ("images") and
  associated metadata in the Image service ("glance").
- Networking service ("neutron") provides virtual networking for Compute.
- Block Storage service ("cinder") provides storage volumes for Compute.
- Object Storage service ("swift") provides object storage store,
  which can also store the virtual disk files by the Image service.
- All the services authenticate with Identity service ("keystone").

Logical Architecture
====================

.. image:: ../figures/openstack-arch-havana-logical-v1.jpg

*Logical diagram*

.. note::

    - The diagram is consistent with the conceptual architecture as
      previously described.

Logical Architecture (cont)
===========================

- End users can interact through a common web interface (horizon) or directly
  to each service through their API

- All services authenticate through a common source
  (facilitated through keystone).

- Individual services interact with each other through their public APIs
  (except where privileged administrator commands are necessary)

Dashboard (horizon)
===================

- Provides an end user and administrator interface to OpenStack services.
- A modular Django web application

.. image:: ../figures/image10.jpg
  :width: 75%

.. note::

    - Horizon is usually deployed via mod_wsgi in Apache. The code itself is
      separated into a reusable python module with most of the logic
      (interactions with various OpenStack APIs) and presentation
      (to make it easily customizable for different sites).

Compute service (nova)
======================

- The most complicated and distributed component of OpenStack.
- A large number of processes cooperate to turn end user API requests into
  running virtual machines.
- Processes and functions

   - nova-api: accepts and responds to end user compute API calls
   - nova-compute: primarily a worker daemon that creates and
     terminates virtual machine instances via hypervisor's APIs


.. note::

    - nova-api accepts and responds to end user compute API calls. It supports
      OpenStack Compute API, Amazon's EC2 API and a special Admin API (for
      privileged users to perform administrative actions).
      It also initiates most of the orchestration activities
      (such as running an instance) as well as enforces some policy
      (mostly quota checks).

    - The nova-compute process is primarily a worker daemon that creates and
      terminates virtual machine instances via hypervisor's APIs (XenAPI for
      XenServer/XCP, libvirt for KVM or QEMU, VMwareAPI for VMware, etc.).
      The process by which it does so is fairly complex but the basics are
      simple: accept actions from the queue and then perform a series of system
      commands (like launching a KVM instance) to carry them out while updating
      state in the database.

Object Storage service (swift)
==============================

- The architecture is very distributed to prevent any single point of
  failure as well as to scale horizontally.
- Components

  - Proxy server (swift-proxy-server): accepts incoming requests
    via the OpenStack Object API or just raw HTTP.
  - Object servers: manage actual objects (i.e. files) on the storage nodes

.. note::

    - Proxy server (swift-proxy-server) accepts incoming requests via the
      OpenStack Object API or just raw HTTP. It accepts files to upload,
      modifications to metadata or container creation. In addition, it will
      also serve files or container listing to web browsers. The proxy server
      may utilize an optional cache (usually deployed with memcache) to
      improve performance.

Image service (glance)
======================

- The architecture has stayed relatively stable since the Cactus release.
- The biggest architectural change: addition of authentication (Diablo)
- Components

  - glance-api: accepts Image API calls for image discovery, image retrieval
    and image storage.
  - glance-registry: stores, processes and retrieves metadata about images
    (size, type, etc.).

Identity service (keystone)
===========================

- Provides a single point of integration for OpenStack policy, catalog,
  token and authentication.
- Handles API requests as well as providing configurable catalog,
  policy, token and identity services.
- Each keystone function has a pluggable backend which allows different ways to
  use the particular service. Most support standard backends like LDAP or SQL,
  as well as Key Value Stores (KVS).
- Most people will use this as a point of customization for their current
  authentication services.

Networking service (neutron)
============================

- Provides "network connectivity as a service" between interface devices
  managed by other OpenStack services (most likely nova).
- Works by allowing users to create their own networks and then attach
  interfaces to them.
- Neutron plug-ins and agents

  - Perform the actual actions

    - Plugging and unplugging ports, creating networks or subnets and IP
      addressing.

  - Depending on the vendor and technologies used in the particular cloud.

.. note::

    - Neutron ships with plug-ins and agents for:
      Cisco virtual and physical switches, NEC OpenFlow products, Open vSwitch,
      Linux bridging, and VMware NSX.

Block Storage service (cinder)
==============================

- Separates out the persistent block storage functionality
- Previously part of OpenStack Compute (in the form of nova-volume)
- The OpenStack Block Storage API allows for manipulation of volumes,
  volume types (similar to compute flavors) and volume snapshots.

.. note::

    - cinder-volume acts upon the requests by reading or writing to the cinder
      database to maintain state, interacting with other processes (like
      cinder-scheduler) through a message queue and directly upon block storage
      providing hardware or software. It can interact with a variety of storage
      providers through a driver architecture. Currently, there are drivers for
      IBM, SolidFire, NetApp, Nexenta, Zadara, linux iSCSI and other storage
      providers.
