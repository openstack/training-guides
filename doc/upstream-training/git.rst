###################
Setup and Learn GIT
###################

Setup For Mac OS & Linux
========================

We'll first install git.

For Mac OS:

#. Go to the Git `download page <https://git-scm.com/downloads>`_ and click
   **Mac OS X**.
#. The downloaded file should be a dmg in your downloads folder. Open that dmg
   file and follow the instructions on screen.

For Linux distributions like Debian, Ubuntu, or Mint open a terminal and type::

  sudo apt-get install git

For Linux distributions like Redhat, Fedora 21 or earlier, or Centos open
a terminal and type::

  sudo yum install git

For Fedora 22 or later open a terminal and type::

  sudo dnf install git

For openSUSE 12.2 and later open a terminal and type::

  sudo zypper in git

Configure Git
-------------

Once you have Git installed you need to configure it. Open your terminal
application and issue the following commands putting in your first/last name
and email address. This is how your contributions will be identified::

  git config --global user.name "Firstname Lastname"
  git config --global user.email "your_email@youremail.com"

Installing git-review
---------------------

git-review adds a subcommand to git that handles working with Gerrit, the code
review system used by OpenStack.

For Mac OS::

  pip install git-review

If you don't have pip installed already, follow the `installation documentation
<https://pip.pypa.io/en/stable/installing/#installing-with-get-pip-py>`_ for
pip.

For Linux distributions like Debian, Ubuntu, or Mint open a terminal and type::

  sudo apt-get install git-review

For Linux distributions like Redhat, Fedora 21 or earlier, or Centos open
a terminal and type::

  sudo yum install git-review

For Fedora 22 or later open a terminal and type::

  sudo dnf install git-review

For openSUSE 12.2 and later open a terminal and type::

  sudo zypper in python-git-review


Learning Git
============

You can use `Git Immersion <http://gitimmersion.com/lab_02.html>`_ to work
through tutorials for learning git.
