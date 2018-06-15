..
 This work is licensed under a Creative Commons Attribution 3.0 Unported
 License.

 http://creativecommons.org/licenses/by/3.0/legalcode

==========================================
Title of your blueprint
==========================================
Developer training guide how to participate classroom
https://blueprints.launchpad.net/openstack-training-guides/+spec/developer-training-guide-how-to-participate-classroom

Problem description
===================
Developer training is broken up into two major parts, in depth on openstack APIs
 and in depth on the CI pipeline tools. This part of the training is focused on
 the classroom work to teach the CI pipeline local and remote tools.

Proposed change
===============
This content is moved from
https://docs.google.com/document/d/17949LwkTd2a8fkQwHxtifZqxp309BdHxKD9sSYG4OD8/edit#

days 2-6
classroom 9:00 to 11:00, 11:15 to 12:30
lab 13:30 to 14:45, 15:00 to 17:00
quiz 16:40 to 17:00

Understanding the local tools in-depth:
pycharm editor
http://www.jetbrains.com/pycharm/quickstart/
Gerrit plugin???:
http://plugins.jetbrains.com/plugin/7272
git
Generic github information:
http://git-scm.com/book
Download:
http://git-scm.com
Some Git commands most relevant for openstack:
http://docs.openstack.org/training-guides/content/operator-getting-started-lab.html#operator-fix-doc-bug
Pycharm Git integration:
https://www.jetbrains.com/pycharm/webhelp/registering-github-account-in-pycharm.html
http://www.jetbrains.com/pycharm/webhelp/using-git-integration.html
source tree
http://www.sourcetreeapp.com
maven
General info:
http://maven.apache.org
Install Maven:
http://docs.openstack.org/training-guides/content/operator-getting-started-lab.html#operator-fix-doc-bug
git-review
http://www.mediawiki.org/wiki/Gerrit/git-review
https://pypi.org/project/git-review/
http://docs.openstack.org/infra/manual/developers.html#installing-git-review

Understanding the submission process in-depth:
Review submission syntax
Gerrit etiquette
https://wiki.openstack.org/wiki/GitCommitMessages
Resubmission
further reading - Documentation > Python Developer
http://docs.openstack.org/developer/openstack-projects.html
Links to source locations:
https://wiki.openstack.org/wiki/Documentation/Builds
CI Pipeline Workflow Overview
Gerrit Workflow
http://docs.openstack.org/infra/manual/developers.html#development-workflow

Understanding the remote tools in-depth:
sources
OpenStack CI pipeline documentation http://docs.openstack.org/infra/system-config/
Use Jay Pipes blog (and Pipes himself) as source http://www.joinfu.com/
github (same links as above)
gerrit
https://gerrit-documentation.storage.googleapis.com/Documentation/2.8.1/index.html
http://www.mediawiki.org/wiki/Gerrit/Tutorial
http://docs.openstack.org/infra/manual/developers.html#development-workflow
jenkins
http://jenkins-ci.org
https://wiki.jenkins-ci.org/display/JENKINS/Meet+Jenkins
Jenkin Dashboard:
https://jenkins.openstack.org

gearman
https://wiki.jenkins-ci.org/display/JENKINS/Gearman+Plugin
jeepy
Nodepool
Logstash
zuul
http://docs.openstack.org/infra/zuul
Understanding the CI Pipeline in-depth
Common jenkins tests
Reviewing and understanding zuul
Understanding jenkins output
Understanding jenkins system manual (devstack) and automated (tempest)
    integration tests


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
Write up the chapters with the information presented above.

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


