Associate training guide
========================

Compute node quiz questions
---------------------------

.. begin-compute-nova-scheduler

1. **Which component determines which host a VM should launch on?**

    #. nova-network
    #. queue
    #. nova-compute
    #. nova-console
    #. nova-scheduler
    #. nova-api

.. end-compute-nova-scheduler

.. begin-compute-queue

2. **All compute nodes (also known as hosts in terms of OpenStack) periodically publish their status, resources available and hardware capabilities: (choose all that apply)**

    #. through the queue
    #. with SQL calls to the database
    #. with direct interprocess communication

.. end-compute-queue

.. begin-compute-default-scheduler

3. **By default, the compute node's scheduler is configured as:**

    #. the RAM scheduler
    #. the base scheduler
    #. the chance scheduler
    #. the filter scheduler
    #. the weight scheduler

.. end-compute-default-scheduler

.. begin-compute-filter-scheduler

4. **If the compute node is using the filter scheduler, it works by:**

    #. filtering hosts by using predefined properties
    #. weighting hosts by applying predefined weights
    #. sorting hosts by using weights to determine host preference list first, then applying filters
    #. filtering hosts first, then using weights to determine host preference
    #. filtering hosts first, then choosing a random host from the filtered list

.. end-compute-filter-scheduler

.. begin-compute-scheduler-returns

5. **Scheduler always returns a host on which nova can start the requested VM.**

    #. True
    #. False

.. end-compute-scheduler-returns

.. begin-compute-classes-block-storage

6. **OpenStack provides which classes of block storage? (choose all that apply).**

    #. RAM storage
    #. object storage
    #. persistent storage
    #. file storage
    #. SSD storage
    #. ephemeral storage
    #. disk storage

.. end-compute-classes-block-storage

.. begin-compute-persistent-volumes

7. **Persistent volumes can be used by more than one instance at the same time:**

    #. True
    #. False

.. end-compute-persistent-volumes

.. begin-compute-provisioning-steps

8. **Specify in which order these steps must be completed to provision VMs:**

| **a.** nova-scheduler picks up the request from the queue.
| **b.** nova-compute generates data for the hypervisor driver and executes the request on the hypervisor (via libvirt or API).
| **c.** nova-scheduler interacts with nova DB to find an appropriate host via filtering and weighting, returns the updated instance entry with the appropriate host ID and sends the rpc.cast request to nova-compute for launching an instance on the appropriate host.
| **d.** nova-conductor interacts with nova DB and returns the instance information. nova-compute picks up the instance information from the queue.
| **e.** nova-api receives the request and sends a request to the Identity Service for validation of the auth-token and access permission. The Identity Service validates the token.
| **f.** nova-compute picks up the request for launching an instance on the appropriate host from the queue.
| **g.** neutron-server validates the auth-token with Identity Service. nova-compute retrieves the network info.
| **h.** nova-compute performs the REST-call by passing the auth-token to Network API to allocate and configure the network so that the instance gets the IP address.
| **i.** The dashboard or CLI converts the new instance request to a REST API request and sends it to nova-api.
| **j.** nova-compute performs the REST call by passing the auth-token to glance-api. Then, nova-compute uses the Image ID to retrieve the Image URI from the Image Service, and loads the image from the image storage.
| **k.** nova-compute sends the rpc.call request to nova-conductor to fetch the instance information such as host ID and flavor (RAM, CPU, disk).
| **l.** cinder-api validates the auth-token with Identity Service. nova-compute retrieves the block storage info.
| **m.** The dashboard or CLI gets the user credentials and authenticates with the Identity Service via REST API. The Identity Service authenticates the user and sends back an auth-token.
| **n.** glance-api validates the auth-token with Identity Service. nova-compute gets the image metadata.
| **o.** nova-compute performs the REST call by passing the auth-token to Volume API to attach volumes to the instance.
| **p.** nova-api checks for conflicts with nova DB and creates the initial database entry for a new instance.
| **q.** nova-api sends the rpc.call request to nova-scheduler expecting to get an updated instance entry with the host ID specified.
| **r.** nova-conductor picks up the request from the queue.

.. end-compute-provisioning-steps

----

Associate training guide
========================

Compute node quiz answers
-------------------------

.. begin-compute-answer-nova-scheduler

1. 5 (nova-scheduler)

.. end-compute-answer-nova-scheduler

.. begin-compute-answer-queue

2. 1 (through the queue) - This increases scalability.

.. end-compute-answer-queue

.. begin-compute-answer-default-scheduler

3. 4 (the filter scheduler)

.. end-compute-answer-default-scheduler

.. begin-compute-answer-filter-scheduler

4. 4 filtering hosts first, then using weights to determine host preference

.. end-compute-answer-filter-scheduler

.. begin-compute-answer-scheduler-returns

5. 2 (False) - Scheduler can also return an error (no suitable host for the requested VM).

.. end-compute-answer-scheduler-returns

.. begin-compute-answer-classes-block-storage

6. 3 (persistent storage), f (ephemeral storage) - The question is about OpenStack's block storage classes.

.. end-compute-answer-classes-block-storage

.. begin-compute-answer-persistent-volumes

7. 2 (False)

.. end-compute-answer-persistent-volumes

.. begin-compute-answer-provisioning-steps

8. a (6), b (18), c (7), d (11), e (3), f (8), g (15), h (14), i (2), j (12), k (9), l (17), m (1), n (13), o (16), p (4), q (5), r (10)

.. end-compute-answer-provisioning-steps