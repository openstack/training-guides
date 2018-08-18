=================
Closing Exercises
=================

.. image:: ./_assets/os_background.png
   :class: fill
   :width: 100%

Exercise: Step 1
================

- Decide a country your group would like to visit with other groups
  for sightseeing.
- Design an 5-day travel itinerary with attractive places, foods, and
  activities.
- Create a draft .rst file with an outline for the itinerary.

Create a new commit with the .rst file in openstack-dev/sandbox repository
and submit the commit to Gerrit when you are finished.

Example Itinerary: Spain
========================

- Day 1

  - 13:45 Sagrada Familia

- Day 2

  - 7:45 Cava & Winery Tour
  - 19:45 Barcelona FC Game

- Day 3-4

  - 15:00 Overnight in Ibiza

- Day 5

  - 7:00 Day Trip to Madrid

Exercise: Step 2
================

- Open an *upstream training* IRC meeting and make consensus
  from various travel plans.

- Example of IRC meeting commands:

  - Do not change meeting name: *upstream training*.
    The meeting name is reserved for upstream training activities.

.. code-block:: console

  #startmeeting upstream training
  #topic Spain tour
  #startvote Day 2: Cava & Winery Tour vs. Barcelona downtown
  #endvote
  #endmeeting

Revise the original patch according to discussion results.

Exercise: Step 3 and more
=========================

- Add bugs against, or write reviews for, the itinerary patches from other
  groups.
- Create a blueprint based upon concrete activities, times and any other
  details your group thinks are appropriate.

  - Register the blueprint
    : `Blueprints for openstack-dev-sandbox <https://blueprints.launchpad.net/openstack-dev-sandbox>`_
  - Use "Implements: [blueprint name]" in commit messages
