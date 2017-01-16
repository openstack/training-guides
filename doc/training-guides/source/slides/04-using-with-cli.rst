======================================
Using OpenStack Command-Line Interface
======================================

.. figure:: figures/os_background.png
   :class: fill
   :width: 100%

How can I use an OpenStack cloud?
=================================

- Using the OpenStack Dashboard

  - Horizon, a web-based graphical interface

- Using Command-Line Clients (CLI)

  - Let users run simple commands to create and manage resources
    in a cloud and automate tasks by using scripts
  - OpenStack Client brings commands in a single shell with a
    uniform command structure

.. note::

    - The official OpenStack programs had its own command-line client.
      These clients are now deprecated in favor of OpenStack Client.
    - For more details on OpenStack Client, see `OpenStack Command-Line
      Interface Reference <http://docs.openstack.org/cli-reference>`_

Install OpenStack command-line clients
======================================

- Most Linux distributions include packaged versions of the Command-Line
  Clients that you can install directly.

    - On Red Hat Enterprise Linux, CentOS, or Fedora, use ``yum``:

      .. code-block:: console

         # yum install python-openstackclient

    * For Ubuntu or Debian, use ``apt``:

      .. code-block:: console

         # apt install python-openstackclient


Install OpenStack command-line clients (cont.)
==============================================

- You can install command-line clients from Python Package Index (on macOS, Linux,
  Microsoft Windows).

    .. code-block:: console

       # pip install python-openstackclient

- Individual clients are deprecated in favor of a common client. Instead
  of installing and learning all these clients, we recommend installing
  and using the OpenStack client.

.. note::

    - For more details on OpenStack Client, see `OpenStack Command-Line
      Interface Reference <http://docs.openstack.org/cli-reference>`_


Discover the version number for a client
========================================

- Run the following command to discover the version number for a client:

    .. code-block:: console

        $ openstack --version
        openstack 3.2.0

Set environment variables using the OpenStack RC file from the dashboard
========================================================================

#. Log in to the dashboard and select your project.

#. On the :guilabel:`Project` tab, open the :guilabel:`Compute` tab and
   click :guilabel:`Access & Security`.

#. On the :guilabel:`API Access` tab, click :guilabel:`Download OpenStack
   RC File` and save the file.

#. Source the downloaded file (ie. ``demo-openrc.sh``):

   .. code-block:: console

      $ . demo-openrc.sh

#. When you are prompted for an OpenStack password, enter the password for
   the user who downloaded the ``demo-openrc.sh`` file.

Create and source the OpenStack RC file from scratch
====================================================

#. In a text editor, create a file named ``PROJECT-openrc.sh`` and add
   the following authentication information:

   .. code-block:: shell

      export OS_USERNAME=username
      export OS_PASSWORD=password
      export OS_TENANT_NAME=projectName
      export OS_AUTH_URL=https://identityHost:portNumber/v2.0

#. Source the ``PROJECT-openrc.sh`` file (ie. ``admin-openrc.sh``) and test if
   you can access your tenant:

   .. code-block:: console

      $ . admin-openrc.sh
      $ openstack server list

.. note::

   You are not prompted for the password with this method. The password
   lives in clear text format in the ``PROJECT-openrc.sh`` file.
   Restrict the permissions on this file to avoid security problems.
   You can also remove the ``OS_PASSWORD`` variable from the file, and
   use the ``--password`` parameter with OpenStack client commands instead.

.. note::

   You must set the ``OS_CACERT`` environment variable when using the
   https protocol in the ``OS_AUTH_URL`` environment setting because
   the verification process for the TLS (HTTPS) server certificate uses
   the one indicated in the environment. This certificate will be used
   when verifying the TLS (HTTPS) server certificate.

OpenStack CLI usage examples
============================

- Examples of what we can do using OpenStack CLI:
    - List servers, images, flavors, and keypairs in tenant
    - Start a server
    - Terminate a server
    - Upload images
    - Create stacks
    - Upload objects
    - Create users, tenants
    - Many more operations

OpenStack CLI simple example
============================

- List servers in your tenant:

.. code-block:: console

    $ openstack server list
    +--------------------------------------+------+--------+------------------------+
    | ID                                   | Name | Status | Networks               |
    +--------------------------------------+------+--------+------------------------+
    | cd5f0a91-7e23-4b0e-b553-28f41730d275 | test | ACTIVE | private=192.168.50.101 |
    +--------------------------------------+------+--------+------------------------+

OpenStack CLI simple example (cont.)
====================================

- List images in your tenant:

.. code-block:: console

    $ openstack image list
    +--------------------------------------+---------------------------------+
    | ID                                   | Name                            |
    +--------------------------------------+---------------------------------+
    | 69de3c34-d45f-4b19-9c13-039657c415b7 | Ubuntu                          |
    | 71b41187-7430-4892-832b-310eeb2de056 | cirros-0.3.4-x86_64-uec         |
    | fa26cee3-0481-48e0-9e0c-2ed3b310eee3 | cirros-0.3.4-x86_64-uec-ramdisk |
    | c184cacc-bebb-4e1f-9954-5de2d1999419 | cirros-0.3.4-x86_64-uec-kernel  |
    +--------------------------------------+---------------------------------+

OpenStack CLI simple example (cont.)
====================================

- List flavors in your tenant:

.. code-block:: console

    $ openstack flavor list
    +-----+-----------+-------+------+-----------+------+-------+-------------+-----------+-------------+
    | ID  | Name      |   RAM | Disk | Ephemeral | Swap | VCPUs | RXTX Factor | Is Public | Extra Specs |
    +-----+-----------+-------+------+-----------+------+-------+-------------+-----------+-------------+
    | 1   | m1.tiny   |   512 |    1 |         0 |      |     1 |         1.0 | True      |             |
    | 2   | m1.small  |  2048 |   20 |         0 |      |     1 |         1.0 | True      |             |
    | 3   | m1.medium |  4096 |   40 |         0 |      |     2 |         1.0 | True      |             |
    | 4   | m1.large  |  8192 |   80 |         0 |      |     4 |         1.0 | True      |             |
    | 42  | m1.nano   |    64 |    0 |         0 |      |     1 |         1.0 | True      |             |
    | 451 | m1.heat   |   512 |    0 |         0 |      |     1 |         1.0 | True      |             |
    | 5   | m1.xlarge | 16384 |  160 |         0 |      |     8 |         1.0 | True      |             |
    | 84  | m1.micro  |   128 |    0 |         0 |      |     1 |         1.0 | True      |             |
    +-----+-----------+-------+------+-----------+------+-------+-------------+-----------+-------------+

OpenStack CLI simple example (cont.)
====================================

- List key pairs in your tenant:

.. code-block:: console

    $ openstack keypair list
    +--------+-------------------------------------------------+
    | Name   | Fingerprint                                     |
    +--------+-------------------------------------------------+
    | my-key | e2:f4:3e:f6:af:d5:3f:e6:c5:ee:1d:dd:86:25:0d:a5 |
    +--------+-------------------------------------------------+

OpenStack CLI simple example (cont.)
====================================

- Now you know all the required parameters (image name, flavor types,
  keypair name) to start a server:

.. code-block:: console

    $ openstack server create --image cirros-0.3.4-x86_64-uec
    \ --flavor m1.nano --key-name my-key  test-cli
    +--------------------------------------+----------------------------------------------------------------+
    | Field                                | Value                                                          |
    +--------------------------------------+----------------------------------------------------------------+
    | OS-DCF:diskConfig                    | MANUAL                                                         |
    | OS-EXT-AZ:availability_zone          | nova                                                           |
    | OS-EXT-STS:power_state               | 0                                                              |
    | OS-EXT-STS:task_state                | scheduling                                                     |
    | OS-EXT-STS:vm_state                  | building                                                       |
    | OS-SRV-USG:launched_at               | None                                                           |
    | OS-SRV-USG:terminated_at             | None                                                           |
    | accessIPv4                           |                                                                |
    | accessIPv6                           |                                                                |
    | addresses                            |                                                                |
    | adminPass                            | ZqzS5UstJLfU                                                   |
    | config_drive                         |                                                                |
    | created                              | 2015-10-19T11:01:27Z                                           |
    | flavor                               | m1.nano (42)                                                   |
    | hostId                               |                                                                |
    | id                                   | 09f83585-52e8-47cf-b18b-6384ce75b37f                           |
    | image                                | cirros-0.3.4-x86_64-uec (71b41187-7430-4892-832b-310eeb2de056) |
    | key_name                             | my-key                                                         |
    | name                                 | test-cli                                                       |
    | os-extended-volumes:volumes_attached | []                                                             |
    | progress                             | 0                                                              |
    | properties                           |                                                                |
    | security_groups                      | [{u'name': u'default'}]                                        |
    | status                               | BUILD                                                          |
    | tenant_id                            | b70a65506eba4712a07900fc3dd67cac                               |
    | updated                              | 2015-10-19T11:01:27Z                                           |
    | user_id                              | 6f602091b45f46e1801af3f1ca7e1054                               |
    +--------------------------------------+----------------------------------------------------------------+

OpenStack command-line client help
==================================

- For help on a specific :command:`openstack` command, enter:

.. code-block:: console

   $ openstack help COMMAND


OpenStack command-line client help (cont)
=========================================

- Example of using help for image upload:

.. code-block:: console

   $ openstack help image
    Command "image" matches:
        image add project
        image create
        image delete
        image list
        image remove project
        image save
        image set
        image show
        image unset


OpenStack command-line client help (cont)
=========================================

- Example of using help for image upload:

.. code-block:: console

    $ openstack help image create
    usage: openstack image create [-h]
                              [-f {html,json,json,shell,table,value,yaml,yaml}]
                              [-c COLUMN] [--max-width <integer>] [--noindent]
                              [--prefix PREFIX] [--id <id>]
                              [--container-format <container-format>]
                              [--disk-format <disk-format>]
                              [--min-disk <disk-gb>] [--min-ram <ram-mb>]
                              [--file <file>] [--volume <volume>] [--force]
                              [--protected | --unprotected]
                              [--public | --private] [--property <key=value>]
                              [--tag <tag>] [--project <project>]
                              [--project-domain <project-domain>]
                              <image-name>
    $ openstack image create ubuntu --container-format bare --disk-format qcow2
     --file xenial-server-cloudimg-amd64-disk1.img --public

