====================
Get to know the code
====================

.. image:: ./_assets/os_background.png
   :class: fill
   :width: 100%

DevStack exercise
=================

- Start DevStack in a VM on your laptop or in public cloud
- Validate the services are running
- Choose a service and issue an API call or use its client to verify
  functionality

LOG message exercise
====================

- Add a few extra LOG.debug() lines to one of the methods of the API call you
  chose in the previous exercise
- Restart the corresponding service in your DevStack environment and find the
  new message in the logs
- Find out what parameters were passed to that method by using the LOG messages

Testing
=======

- Test suits

  - Unit
  - Functional
  - Integration

- Testing framework

  - Tox

Testing exercise
================

- Run only one test class and not the whole suite
- Run one test case
- Group exercise

  - Ask a mentor to break the *tested* code of one test case
  - Find out what the modification is by running the test and analyzing the
    test output

Test coverage exercise
======================

- Find an open review which is less complex and download the patch
- Remove the code changes and run the tests
- Check whether the tests failed or not
- Explain what it means if they didn't
- Comment on the open review
