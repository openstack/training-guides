Introduction
============

* The subfolders contain the RST files related to the Training Guides.
* The RST files are built into HTML through landslide. Find the landslide
style guide here https://raw.githubusercontent.com/adamzap/landslide/master/examples/restructuredtext/slides.rst
* Create the output html by **./landslide.sh**
* Please refer the following link to get more information about this project
  https://launchpad.net/openstack-training-guides
* Please follow the following wiki to get more information about development
  process of Training Guides. This should provide enough information to start
  contributing to training guides
  https://wiki.openstack.org/wiki/Training-guides

* Training Guides is typically divided into four guides

    1. Associate Training Guide
    2. Operator Training Guide
    3. Developer Training Guide
    4. Architect Training Guide

* Please follow the following wiki to get more information about development
  process of Training Guides. This should provide enough information to start
  contributing to training guides
  https://wiki.openstack.org/wiki/Training-guides


Structure of this folder
========================

* To get better idea of the design of this folder follow this blueprint
  https://blueprints.launchpad.net/openstack-training-guides/+spec/separate-folders-for-books
* Typically book wise folders are created, read the following for more
  description:

    1. associate-guide: This folder contains RST files related to Associate
       Training Guide.
    2. operator-guide: This folder contains RST files related to Operator
       Training Guide.
    3. developer-guide: This folder contains RST files related to Developer
       Training Guide.
    4. architect-guide: This folder contains RST files related to Architect
       Training Guide.
    5. basic-install-guide: This folder contains Install Guides which is
       similar to basic/easy version of Install Guides present under
       openstack-manuals.
    6. common: This folder contains common files used by multiple training
       guides.
    7. figures: This folder contains images used by all the training guides.
