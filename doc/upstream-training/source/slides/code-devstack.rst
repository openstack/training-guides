================
Demo environment
================

.. image:: ./_assets/os_background.png
   :class: fill
   :width: 100%

DevStack
========

- A bunch of scripts to build a full OpenStack environment
- Used as

  - Demo environment
  - Part of the OpenStack project's functional testing

- Single and multi node setup
- Installs services from source

  - from git master by default
  - from stable branches by configuration, e.g. stable/newton

- Documentation: http://docs.openstack.org/developer/devstack/

DevStack Clone and Setup
========================
- Clone DevStack to your vm

.. code-block:: console

  git clone https://github.com/openstack-dev/devstack

- Make any local configurations changes (set passwords, IP addresses, etc.)

.. code-block:: console

  cd ./devstack
  cp ./samples/local.conf .
  vi ./local.conf

- Run DevStack

.. code-block:: console

  ./stack.sh

.. note::

  - DevStack should already be installed in the VM image you downloaded.
    These instructions are provided for future reference in the case that
    students need to start from scratch.

http://localhost/
=================

- After DevStack is run Horizon is accessible via localhost

.. image:: ./_assets/devstack-http-localhost.png
  :width: 100%

Using Linux 'screen'
====================

- Access the terminals the installed services are running in
- Use command 'screen -ls' to see the running screen sessions
- Use command 'screen -R <session name>' or 'screen -C stack-screenrc' to
  attach to or start a new session
- For further commands see the
  `User's Manual <https://www.gnu.org/software/screen/manual/screen.html>`_

.. image:: ./_assets/devstack-screen.png
  :width: 90%
  :align: center

Exercise
========

- Ensure you have the DevStack repository cloned to the VM where you
  would like to use it
- Using the 'screen' command determine if there is a screen session running
  in your VM.  If there is, attach to it.  If not, start a new session.
- Once attached to a screen session switch between the running services to
  get to your favorite service and try stopping and restarting the service.
- Disconnect from your screen session and ensure it is still running in the
  background.

.. note::

  - Commands needed:

    - List sessions: screen -ls
    - Connect: screen -R <session name>
    - Start a new session:  screen -C devstack/stack-screenrc
    - Move between services: <ctrl>-a n , <ctrl>-a p
    - Kill and restart a service: <ctrl>-c , <up arrow> to retrieve command
    - Disconnect: <ctrl>-a d


