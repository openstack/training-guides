
Training Labs
=============

About
-----

Training Labs will provide scripts to automate the creation of the Training
Environment.

**Note:** Training Labs are specifically meant for OpenStack Training and are
specifically tuned as per Training Manuals repo.


Pre-requisite
-------------

* Download and install [VirtualBox](https://www.virtualbox.org/wiki/Downloads).


How to run the scripts
----------------------

1. Clone the training-guides repo which contains scripts in the labs section that will install multi-node OpenStack automatically.

        $ git clone git://git.openstack.org/openstack/training-guides

2. Go to the labs folder

        $ cd training-guides/labs

3. Run the script:

        $ ./osbash -b cluster

This will do the complete installation for all the nodes - Controller, Compute and Network.

For more help you can check

        $ ./osbash --help


This will take some time to run the first time.


What the script installs
------------------------

Running this will automatically spin up 3 virtual machines in VirtualBox:

* Controller node
* Network node
* Compute node

Now you have a multi-node deployment of OpenStack running with the below services installed.

OpenStack services installed on Controller node:

* Keystone
* Horizon
* Glance
* Nova

    * nova-api
    * nova-scheduler
    * nova-consoleauth
    * nova-cert
    * nova-novncproxy
    * python-novaclient

* Neutron

    * neutron-server

* Cinder

Openstack services installed on Network node:

* Neutron

    * neutron-plugin-openvswitch-agent
    * neutron-l3-agent
    * neutron-dhcp-agent
    * neutron-metadata-agent

Openstack Services installed on Compute node:

* Nova

    * nova-compute

* Neutron

    * neutron-plugin-openvswitch-agent


How to access the services
--------------------------

There are two ways to access the services:

* OpenStack Dashboard (horizon)

You can access the dashboard at: http://192.168.100.51/horizon

Admin Login:

*Username:* `admin`

*Password:* `admin_pass`

*Demo User Login:*

*Username:* `demo`

*Password:* `demo_pass`

* SSH

You can ssh to each of the nodes by:

        # Controller node
        $ ssh osbash@10.10.10.51

        # Network node
        $ ssh osbash@10.10.10.52

        # Compute node
        $ ssh osbash@10.10.10.53

Credentials for all nodes:

*Username:* `osbash`

*Password:* `osbash`

After you have ssh access, you need to source the OpenStack credentials in order to access the services.

Two credential files are present on each of the nodes:
        demo-openstackrc.sh
        admin-openstackrc.sh

Source the following credential files

For Admin user privileges:

        $ source admin-openstackrc.sh

For Demo user privileges:

        $ source demo-openstackrc.sh

Now you can access the OpenStack services via CLI.


BluePrints
----------

* Training Manuals : https://blueprints.launchpad.net/openstack-manuals/+spec/training-manuals
* Training Labs : https://blueprints.launchpad.net/openstack-training-guides/+spec/openstack-training-labs

Mailing Lists, IRC
------------------

* To contribute please hop on to IRC on the channel `#openstack-doc` on IRC freenode
  or write an e-mail to the OpenStack Manuals mailing list
  `openstack-docs@lists.openstack.org`.

**NOTE:** You might consider registering on the OpenStack Manuals mailing list if
          you want to post your e-mail instantly. It may take some time for
          unregistered users, as it requires admin's approval.

Sub-team leads
--------------

Feel free to ping Roger or Pranav on the IRC channel `#openstack-doc` regarding
any queries about the Labs section.

* Roger Luethi
** Email: `rl@patchworkscience.org`
** IRC: `rluethi`

* Pranav Salunke
** Email: `dguitarbite@gmail.com`
** IRC: `dguitarbite`

Meetings
--------

To follow the weekly meetings for OpenStack Training, please refer
to the following link.

For IRC meetings, refer to the wiki page on training manuals.
https://wiki.openstack.org/wiki/Meetings/training-manual

Wiki
----

Follow various links on OpenStack Training Manuals here:
https://wiki.openstack.org/wiki/Training-guides
