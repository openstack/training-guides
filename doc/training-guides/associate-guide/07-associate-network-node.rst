============
Network node
============

.. figure:: ../figures/os_background.png
   :class: fill
   :width: 100%

Networking in OpenStack
=======================

- Project name ``neutron``
- Rich tenant-facing API to defining network connectivity and addressing in
  the cloud
- Supports each tenant having isolated:
    - multiple private networks
    - IP addressing scheme (can overlap with those used by
      other tenants)

Networking API resources
========================

- Network:
    - L2 segment like VLAN in a physical world
- Subnet:
    - IPv4 and IPv6 IP address block and config
- Port:
    - Connection point between a vNIC and a virtual network
    - Also describes associated network config (MAC, IP)

Plugins
=======

- Original Compute network implementation (``nova-network``):
    - isolation through Linux VLANs and iptables
- ``neutron`` introduces plug-in concept:
    - Pluggable back-end implementation of the OpenStack Networking APIs:
        - VLANs and iptables
        - L2-in-L3 tunneling
        - OpenFlow, etc.

Current Set of Plugins
======================

Complete list of supported plugins https://wiki.openstack.org/wiki/Neutron_Plugins_and_Drivers

.. rst-class:: colleft

- Big Switch
- Brocade
- Cisco
- CloudBase Hyper-V
- IBM SDN-VE
- Linux Bridge

.. rst-class:: colright

- Midonet
- ML2 (Modular Layer 2)
- NEC OpenFlow
- Open vSwitch
- PLUMgrid
- VMware NSX

.. note::

    Plugin list taken from: http://docs.openstack.org/admin-guide-cloud/content/section_plugin-arch.html

    - Big Switch, Floodlight REST Proxy: http://www.openflowhub.org/display/floodlightcontroller/Quantum+REST+Proxy+Plugin
    - Brocade Plugin
    - Cisco: Documented externally at: https://wiki.openstack.org/wiki/Cisco-neutron
    - Hyper-V Plugin
    - Linux Bridge: Documentation included in this guide and
        https://wiki.openstack.org/wiki/Neutron-Linux-Bridge-Plugin
    - Midonet Plugin
    - NEC OpenFlow: https://wiki.openstack.org/wiki/Neutron/NEC_OpenFlow_Plugin
    - Open vSwitch: Documentation included in this guide.
    - PLUMgrid: https://wiki.openstack.org/wiki/PLUMgrid-Neutron
    - VMware NSX: Documentation include in this guide, NSX Product Overview ,
      and NSX Product Support.

Components of OpenStack Networking
==================================

``neutron-server``

- Requires access to a database for persistent storage
- Can co-exist with controller or separately
- Requires additional agents

Networking Agents
=================

- **plugin agent** (neutron- * -agent): runs on each hypervisor
- **dhcp agent** (neutron-dhcp-agent): provides DHCP services
- **l3 agent** (neutron-l3-agent): provides L3/NAT forwarding (external
  network access)


- Agents communicate through RPC (e.g. RabbitMQ) and/or API
- Great flexibility how to deploy neutron services, plugins and agents

.. note::

    - plugin agent (neutron- * -agent):Runs on each hypervisor to perform local
      vswitch configuration. Agent to be run depends on which plug-in you are
      using, as some plug-ins do not require an agent
    - dhcp agent (neutron-dhcp-agent):Provides DHCP services to tenant
      networks,this agent is the same across all plug-ins
    - l3 agent (neutron-l3-agent):Provides L3/NAT forwarding to provide
      external network access for VMs on tenant networks. This agent is the
      same across all plug-ins

Network Types
=============

Typically at least **four** distinct **physical** data center **networks**:

- **Management network:** internal communication between OpenStack
  Components.
- **Data network:** VM data communication within the cloud deployment.
- **External network:** provide VMs with Internet access.
- **API network:** exposes all OpenStack APIs.

.. note::

    - **Management network:** Used for internal communication between OpenStack
      Components. The IP addresses on this network should be reachable
      only within the data center.
    - **Data network:** Used for VM data communication within the cloud
      deployment. The IP addressing requirements of this network depend
      on the OpenStack Networking plug-in in use.
    - **External network:** Used to provide VMs with Internet access, in some
      deployment scenarios. The IP addresses on this network should be
      reachable by anyone on the Internet.
    - **API network:** Exposes all OpenStack APIs, including the OpenStack
      Networking API, to tenants. The IP addresses on this network should
      be reachable by anyone on the Internet. This may be the same network
      as the external network, as it is possible to create a subnet for
      the external network that uses IP allocation ranges to use only less
      than the full range of IP addresses in an IP block.

OpenStack Networking - Connectivity
===================================

.. image:: ../figures/image33.png


OpenStack Networking Concepts
=============================

- Tenant networks, provider networks
- Tenant network types:
    - **Local**: within single host
    - **Flat**: no network segmentation, single broadcast domain
    - **VLAN**: VLAN for segmentation
    - **VXLAN, GRE**: Overlay networks, tunnels encapsulate network traffic

OpenStack Networking Concepts (cont)
====================================

- Namespaces:
    - Each network creates and unique namespace “netns”
    - netns hosts an interface and IP addresses for dnsmasq and the
      neutron-ns-metadata-proxy
- Metadata:
    - Not all networks or VMs need metadata access.
    - Create the subnet without specifying a gateway IP and with a static
      route from 0.0.0.0/0 to your gateway IP address
- OVS Bridge:
    - Isolate the traffic

OpenStack Networking Concepts (cont)
====================================

.. image:: ../figures/image49.png

Managing Networks - CLI
=======================

Networks:

- ``neutron ext-list -c alias -c name`` (list network extensions)
- ``neutron net-create net1``
- ``neutron net-create net2 --provider:network-type local``

Subnets:

- ``neutron subnet-create net1 192.168.2.0/24 --name subnet1``
  (name, CIDR, subnet name – optional)

Managing Networks - CLI
=======================

Routers:

- To provider net: ``neutron router-gateway-set ROUTER NETWORK``
- To subnet: ``neutron router-interface-add ROUTER SUBNET``

Ports:

- ``neutron port-create net1 --fixed-ip ip_address=192.168.2.40``
- ``neutron port-create net1`` (without fix ip)
- Query ports: ``neutron port-list --fixed-ips``

  - ``neutron port-list --fixed-ips ip_address=10.0.0.4``
