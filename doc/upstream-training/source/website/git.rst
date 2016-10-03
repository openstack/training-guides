###################
Setup and Learn GIT
###################

.. note::

  This section assumes you have completed :doc:`accounts` guide.

Git
===

What is it?
-----------

Git is a free and open source distributed version control system that the
OpenStack community uses to manage changes to source code.

Installation
------------

Mac OS
^^^^^^

#. Go to the Git `download page <https://git-scm.com/downloads>`_ and click
   **Mac OS X**.

#. The downloaded file should be a dmg in your downloads folder. Open that dmg
   file and follow the instructions on screen.

If you use the package manager `Homebrew <http://brew.sh>`_, open a terminal
and type::

    brew install git

Linux
^^^^^

For distributions like Debian, Ubuntu, or Mint open a terminal and type::

  sudo apt install git

For distributions like RedHat, Fedora 21 or earlier, or CentOS open a terminal
and type::

  sudo yum install git

For Fedora 22 or later open a terminal and type::

  sudo dnf install git

For SUSE distributions open a terminal and type::

  sudo zypper in git

Configure Git
-------------

Once you have Git installed you need to configure it. Open your terminal
application and issue the following commands putting in your first/last name
and email address. This is how your contributions will be identified::

  git config --global user.name "Firstname Lastname"
  git config --global user.email "your_email@youremail.com"

Git Review
==========

What is it?
-----------

Git review is tool maintained by the OpenStack community. It adds an additional
sub-command to git like so::

  git review

When you have changes in an OpenStack project repository, you can use this
sub-command to have the changes posted to
`Gerrit <https://review.openstack.org/>`__ so that they can be reviewed.

Installation
------------

Mac OS
^^^^^^

In a terminal type::

  pip install git-review

If you don't have pip installed already, follow the `installation documentation
<https://pip.pypa.io/en/stable/installing/#installing-with-get-pip-py>`_ for
pip.

.. note::

  Mac OS X El Capitan and macOS Sierra users might see an error
  message like "Operation not permitted" when installing with the command.
  In this case, there are two options to successfully install git-review.

  Option 1: install using pip with more options::

    pip install --install-option '--install-data=/usr/local' git-review

  Option 2: Use the package manager `Homebrew <http://brew.sh>`_,
  and type in a terminal::

    brew install git-review

Linux
^^^^^^

For distributions like Debian, Ubuntu, or Mint open a terminal and type::

  sudo apt install git-review

For distributions like RedHat, Fedora 21 or earlier, or CentOS open a terminal
and type::

  sudo yum install git-review

For Fedora 22 or later open a terminal and type::

  sudo dnf install git-review

For SUSE distributions open a terminal and type::

  sudo zypper in python-git-review

Configuration
-------------

Git review assumes the user you're running it as is the same as your Gerrit
username. If it's not, you can tell it by setting this git config setting::

  git config --global gitreview.username <username>

If you don't know what your Gerrit username is, you can check the `Gerrit
settings <https://review.openstack.org/#/settings/>`_.

Setup SSH Keys
==============

What are they?
--------------

In order to push things to `Gerrit <https://review.openstack.org>`_ we need to
have a way to identify ourselves. We will do this using ssh keys which allows
us to have our machine we're pushing a change from to perform
a `challenge-response authentication
<https://en.wikipedia.org/wiki/Challenge-response_authentication>`_ with the
Gerrit server.

SSH keys are always generated in pairs:

* **Private key** - Only known to you and it should be safely guarded.
* **Public key** - Can be shared freely with any SSH server you wish to connect
  to.

In summary, we will be generating these keys, and providing the Gerrit server
with your public key. With your system holding the private key, it will have no
problem replying to Gerrit during the challenge-response authentication.


Check For Existing Keys
-----------------------

Open your terminal program and type::

  ls -la ~/.ssh

Typically public key filenames will look like:

* id_dsa.pub
* id_ecdsa.pub
* id_ed25519.pub
* id_rsa.pub

If you don't see .pub extension file, you need to generate keys.


Generate SSH Keys
-----------------

Assuming you weren't able to find keys in your ~/.ssh directory, you can
generate a new ssh key using the provided email as a label by going into
your terminal program and typing::

  ssh-keygen -t rsa -b 4096 -C "your_email@example.com"

When you're prompted to "Enter a file in which to save the key" press Enter.
This accepts the default location::

  Enter a file in which to save the key (/Users/you/.ssh/id_rsa): [Press enter]

At the prompt, type a secure a passphrase, you may enter one or press Enter to
have no passphrase::

  Enter passphrase (empty for no passphrase): [Type a passphrase]
  Enter same passphrase again: [Type passphrase again]


Copy Public Key
---------------

Mac OS & Linux
^^^^^^^^^^^^^^

From your terminal type::

  cat ~/.ssh/id_rsa.pub

Highlight and copy the output.

Import Public Key Into Gerrit
-----------------------------

#. Go to `Gerrit's SSH Public Keys settings
   <https://review.openstack.org/#/settings/ssh-keys>`_.
#. Click the 'Add Key' button.
#. Paste the public key into the **Add SSH Public Key** text box and click Add.

Learning Git
============

You can use `Git Immersion <http://gitimmersion.com/lab_02.html>`_ to work
through tutorials for learning git.
