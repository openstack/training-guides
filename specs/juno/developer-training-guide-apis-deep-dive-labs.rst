..
 This work is licensed under a Creative Commons Attribution 3.0 Unported
 License.

 http://creativecommons.org/licenses/by/3.0/legalcode

==========================================
Title of your blueprint
==========================================
Developer training guide APIs deep dive labs
https://blueprints.launchpad.net/openstack-training-guides/+spec/developer-training-guide-apis-deep-dive-labs

Problem description
===================
Developer training is broken up into two major parts, in depth on openstack APIs
 and in depth on the CI pipeline tools. This part of the training is focused on
 the lab work to teach the openstack APIs in depth.


Proposed change
===============
Develop lab work around

Day 7
Git, Gerrit, Jenkins, Config Mgmt - Puppet  (pre-canned within Glance Image)
Common test frameworks (flake8, etc)

Day 8
Glance (Deploy instance image from - Puppet )
Nova (instance  deployed too)
Swift (Display Image in web app from, set meta-information about)
Keystone - User with authenticate into web app into Keystone API
Steal auth module from horizon

Day 9
Notes from Django Mentoring
Start with cloned mysite - follow django
Bare min framework
Extensible

Goal -  Advanced Topics for super star dev - documented here, but not in current course
Telemetry - Pull performance information and display it in webapp
Heat - Create set of templates for supporting services
Create orchestration template for DBaaS (Trove)
Trigger creation of extra services using Heat Template
Trove - Pull content from DBaaS, Need to push content in
Networking -
Neutron - Create security group between web app nodes and trove instances
Neutron + ODL - Create App Policy Contract (super duper bonus points)
Marconi (queueing) - Pass information between app instances using marconi message bus
Pass user input to be displayed on all pages through form input to display on local instance, as well as secondary instance
Savanna
Integrated EDP portal page into web page
Pull user information from Trove / MySQL, push through pre-canned mapreduce file, output in Swift
Docs - Create user documentation linked from web app using Docbooks pipeline


Alternatives
------------
None

Data model impact
-----------------
None

REST API impact
---------------
None

Security impact
---------------
None

Notifications impact
--------------------
None

Other end user impact
---------------------
None

Performance Impact
------------------
None

Other deployer impact
---------------------
None

Developer impact
----------------
None

Implementation
==============

Assignee(s)
-----------
sarob

Work Items
----------
Write up the prerequisites chapter with the information presented above.

Dependencies
============
None

Testing
=======
None

Documentation Impact
====================
None

References
==========
None


