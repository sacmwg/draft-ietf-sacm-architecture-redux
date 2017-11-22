---
title: Security Automation and Continuous Monitoring (SACM) Architecture
abbrev: SACM Architecture
docname: draft-mandm-sacm-architecture-latest
stand_alone: true
ipr: trust200902
area: Security
wg: SACM Working Group
kw: Internet-Draft
cat: info
coding: us-ascii
pi:
  toc: yes
  sortrefs: yes
  symrefs: yes

author:
- ins: A. Montville
  name: Adam W. Montville
  org: Center for Internet Security
  abbrev: CIS
  email: adam.w.montville@gmail.com
  street: 31 Tech Valley Drive
  code: '12061'
  city: East Greenbush
  region: NY
  country: USA
- ins: B. Munyan
  name: Bill Munyan
  org: Center for Internet Security
  abbrev: CIS
  email: bill.munyan.ietf@gmail.com
  street: 31 Tech Valley Drive
  code: '12061'
  city: East Greenbush
  region: NY
  country: USA

normative:

informative:
  I-D.ietf-sacm-terminology:
  I-D.ietf-sacm-nea-swid-patnc:
  I-D.ietf-sacm-ecp:
  I-D.ietf-mile-xmpp-grid:
  I-D.ietf-mile-rolie:
  RFC7632:
  RFC8248:
  RFC5023:


--- abstract

This memo documents the notional Security Automation and Continuous Monitoring (SACM) architecture to be used by SACM participants when crafting SACM-related solutions. The SACM architecture is predicated upon information gleaned from SACM Use Cases and Requirements ({{RFC7632}} and {{RFC8248}} respectively) and terminology as found in {{I-D.ietf-sacm-terminology}}.

--- middle

# Introduction
The SACM working group has experienced some difficulty gaining consensus around a single architectural vision. Our hope is that this document begins to alleviate this. We have recognized viability in approaches typically thought to be at odds with each other - specifically {{I-D.ietf-sacm-ecp}} and {{I-D.ietf-mile-xmpp-grid}}. We believe that, in reality, these approaches complement each other to more completely meet the spirit of {{RFC8248}}.

The authors explicitly recognize that some state collection mechanisms exist today, some do not, and some that do may need to be improved over time. The architecture described in this document seeks to accommodate this recognition by first defining a fairly generic abstract architecture, then making that architecture somewhat more concrete.

## Requirements notation

The key words "MUST", "MUST NOT", "REQUIRED", "SHALL", "SHALL NOT",
"SHOULD", "SHOULD NOT", "RECOMMENDED", "NOT RECOMMENDED", "MAY", and
"OPTIONAL" in this document are to be interpreted as described in RFC
2119, BCP 14 {{RFC2119}}.

# Terms and Definitions
This draft defers to {{I-D.ietf-sacm-terminology}} for terms and definitions.

# The Basic Architecture
The architectural approach proposed herein recognizes existing state collection mechanisms and makes every attempt to respect {{RFC7632}} and {{RFC8248}}.

~~~~~~~~~~
+----------+      +------+   +------------+
|Repository|      |Policy|   |Orchestrator|
+----^-----+      +--^---+   +----^-------+       +----------------+
  A  |            B  |          C |               | Downstream Uses|
     |               |            |               | +-----------+  |
+----v---------------v------------v-------+       | |Evaluations|  |
|       Message Transfer System           <-------> +-----------+  |
+----------------^------------------------+     D | +---------+    |
                 |                                | |Analytics|    |
                 |                                | +---------+    |
         +-------v---------                       | +---------+    |
         | Transfer System |                      | |Reporting|    |
         |    Connector    |                      | +---------+    |
         +-------^---------+                      +----------------+
                 |
                 |
         +-------v-------+       NOTE: Some collection mechanisms
         |   Collection  |             may already exist, whereas
         |     System    |             others may not.
         +---------------+

~~~~~~~~~~
{: #fig-notional title="Notional Architecture"}

As shown in {{fig-notional}}, the notional SACM architecture consists of some basic SACM Components using a message transfer system to communicate. While not depicted, the message transfer system is expected to maximally align with the requirements described in {{RFC8248}}, which means that the message transfer system will support brokered (i.e. point-to-point) and proxied data exchange.

Additionally, component-specific interfaces (i.e. such as A, B, C, and D in the figure above) are expected to be specified logically then bound to one or more specific implementations. This should be done for each capability related to the given SACM Component.

~~~~~~~~~~
  +----------+      +------+   +------------+
  |Repository|      |Policy|   |Orchestrator|
  +----^-----+      +--^---+   +----^-------+       
       |               |            |               
       |               |            |               
  +----v---------------v------------v-----------------+     +-----------------+
  |                     XMPP-Grid                     <-----> Downstream Uses |
  +-----^-------------^-------------^-------------^---+     +-----------------+
        |             |             |             |
        |             |             |             |
   +----v----+   +----v----+   +----v----+   +----v----+  
   |XMPP-Grid|   |XMPP-Grid|   |XMPP-Grid|   |XMPP-Grid|  
/~~|Connector|~~~|Connector|~~~|Connector|~~~|Connector|~~\
|  +----^----+   +----^----+   +----^----+   +----^----+  |
|       |             |             |             |       |
|  +----v----+   +----v-----+  +----v----+   +----v----+  |
|  |ECP/SWIMA|   |Datastream|  |YANG Push|   |  IPFIX  |  |
|  +---------+   +----------+  +---------+   +---------+  |
|                      Collectors                         |
\~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~/
~~~~~~~~~~
{: #fig-detailed title="Detailed Architecture"}

In {{fig-detailed}}, we have a more detailed view of the architecture - one that fosters the development of a pluggable ecosystem of cooperative tools. Existing collection mechanisms (ECP/SWIMA included) can be brought into this architecture by specifying the interface of the collector and creating the XMPP-Grid Connector. Additionally, while not directly depicted in {{fig-detailed}}, this architecture does not preclude point-to-point interfaces. In fact, {{I-D.ietf-mile-xmpp-grid}} provides brokering capabilities to facilitate such point-to-point data transfers.

# A Word On SACM Components, Capabilities, and Interfaces
As previously mentioned, the SACM Architecture consists of a variety of SACM Components, and named components are intended to embody one or more specific capabilities. Interacting with these capabilities will require at least two levels of interface specification. The first is a logical interface specification, and the second is at least one binding to a specific transfer mechanism, where the preferred transfer mechanism would be XMPP-grid.

Consider a policy server conforming to {{I-D.ietf-mile-rolie}}. {{I-D.ietf-mile-rolie}} describes a RESTful way based on the ATOM Publishing Protocol ({{RFC5023}}) to find specific data collections. While this represents a specific binding (i.e. RESTful API based on {{RFC5023}}), there is a more abstract way to look at ROLIE. ROLIE provides notional workspaces and collections, and provides the concept of information categories and links. Strictly speaking, these are logical concepts independent of the RESTful binding ROLIE specifies. In other words, ROLIE binds a logical interface (i.e. GET workspace, GET collection, SET entry, and so on) to a specific mechanism (namely an ATOM Publication Protocol extension). It is not inconceivable to believe there could be a different interface mechanism, or a connector, providing these same operations using XMPP-Grid as the transfer mechanism.

# Enumerating SACM components
The list of SACM Components is theoretically endless, but we need to start somewhere. The following is a list of suggested SACM Components.

* Vulnerability Information Repository
* Software Inventory Collector
* Software Inventory Repository
* Configuration Policy Repository
* Configuration State Repository
* Vulnerability Management Orchestrator
* Configuration Management Orchestrator

# Privacy Considerations
TODO

# Security Considerations
TODO

# IANA Considerations
TODO

--- back

# Endpoint Compliance Profile as a Collector
The SACM working group has accepted work on the Endpoint Compliance Profile {{I-D.ietf-sacm-ecp}}, which describes a collection architecture and may be viewed as a collector coupled with a collection-specific repository.

~~~~~~~~~~
                                 Posture Manager              Endpoint
                Orchestrator    +---------------+        +---------------+
                +--------+      |               |        |               |
                |        |      | +-----------+ |        | +-----------+ |
                |        |<---->| | Posture   | |        | | Posture   | |
                |        | pub/ | | Validator | |        | | Collector | |
                |        | sub  | +-----------+ |        | +-----------+ |
                +--------+      |      |        |        |      |        |
                                |      |        |        |      |        |
Evaluator       Repository      |      |        |        |      |        |
+------+        +--------+      | +-----------+ |<-------| +-----------+ |
|      |        |        |      | | Posture   | | report | | Posture   | |
|      |        |        |      | | Collection| |        | | Collection| |
|      |<-----> |        |<-----| | Manager   | | query  | | Engine    | |
|      |request/|        | store| +-----------+ |------->| +-----------+ |
|      |respond |        |      |               |        |               |
|      |        |        |      |               |        |               |
+------+        +--------+      +---------------+        +---------------+

~~~~~~~~~~
{: #fig-ecp title="ECP Collection Architecture"}

In {{fig-ecp}}, any of the communications between the Posture Manager and ECP components to the its left could be performed directly or indirectly using a given message transfer mechanism. For example, the pub/sub interface between the Orchestrator and the Posture Manager could be using a proprietary method or using {{I-D.ietf-mile-xmpp-grid}} or some other pub/sub mechanism. Similar the store connection from the Posture Manager to the Repository could be performed internally to a given implementation, via a RESTful API invocation over HTTPS, or even over a pub/sub mechanism.

Our assertion is that the Evaluator, Respository, Orchestrator, and Posture Manager all have the potential to represent SACM Components with specific capability interfaces that can be logically specified, then bound to one or more specific mechanisms (i.e. RESTful API, {{I-D.ietf-mile-rolie}}, {{I-D.ietf-mile-xmpp-grid}}, and so on).

An equally plausible way to view the ECP collection architecture might be as depicted in {{fig-ecp-alternate}}.

~~~~~~~~~~
                 /~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~\           Endpoint
Orchestrator     |                   +---------------+ |    +---------------+
 +--------+      |                   |               | |    |               |
 |        |      |                   | +-----------+ | |    | +-----------+ |
 |        |<------------------------>| | Posture   | | |    | | Posture   | |
 |        |      |           RESTful | | Validator | | |    | | Collector | |
 |        |      |           API     | +-----------+ | |    | +-----------+ |
 +--------+      |                   |      |        | |    |      |        |
                 |                   |      |        | |    |      |        |
Evaluator        | Repository        |      |        | |    |      |        |
+------+         | +--------+        | +-----------+ |<---->| +-----------+ |
|      |         | |        |        | | Posture   | |PA/TNC| | Posture   | |
|      |         | |        |        | | Collection| | |    | | Collection| |
|      |<--------->|        |<-------| | Manager   | | |    | | Engine    | |
|      |RESTful  | |        |Direct  | +-----------+ | |    | +-----------+ |
|      |API      | |        |DB Conn |               | |    |               |
|      |         | |        |        |               | |    |               |
+------+         | +--------+        +---------------+ |    +---------------+
                 |                                     |
                 |            Posture Manager          |
                 \~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~/
~~~~~~~~~~
{: #fig-ecp-alternate title="Alternate ECP Collection Architecture"}

Here, the Posture Manager is the collection of Repository, Posture Validator, and Posture Collection Manager. An evaluator could connect via a RESTful API, as could an Orchestrator.

# Mapping to RFC8248
TBD
