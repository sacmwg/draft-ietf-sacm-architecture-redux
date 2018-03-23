---
title: Security Automation and Continuous Monitoring (SACM) Architecture
abbrev: SACM Architecture
docname: draft-mandm-sacm-architecture-01
stand_alone: true
ipr: trust200902
area: Security
wg: SACM Working Group
kw: Internet-Draft
cat: std
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
  RFC2119:

informative:
  I-D.ietf-sacm-terminology: sacmt
  I-D.ietf-sacm-nea-swid-patnc: swidtnc
  I-D.ietf-sacm-ecp: ecp
  I-D.ietf-mile-xmpp-grid: xmppgrid
  I-D.ietf-mile-rolie: rolie
  draft-birkholz-sacm-yang-content:
    target: https://tools.ietf.org/html/draft-birkholz-sacm-yang-content-01
    title: YANG subscribed notifications via SACM Statements
    author:
    - ins: H. Birkholz
      name: Henk Birkholz
    - ins: N. Cam-Winget
      name: Nancy Cam-Winget
  RFC7632:
  RFC8248:
  RFC5023:
  NIST800126:
    target: https://csrc.nist.gov/publications/detail/sp/800-126/rev-3/final
    title: SP 800-126 Rev. 3 - The Technical Specification for the Security Content Automation Protocol (SCAP) - SCAP Version 1.3
    author:
    - ins: D. Waltermire
      name: David Waltermire
    - ins: S. Quinn
      name: Stephen Quinn
    - ins: H. Booth
      name: Harold Booth
    - ins: K. Scarfone
      name: Karen Scarfone
    - ins: D. Prisaca
      name: Dragos Prisaca
    date: February 2018
  NISTIR7694:
    target: https://csrc.nist.gov/publications/detail/nistir/7694/final
    title: NISTIR 7694 Specification for Asset Reporting Format 1.1
    author:
    - ins: A. Halbardier
      name: Adam Halbardier
    - ins: D. Waltermire
      name: David Waltermire
    - ins: M. Johnson
      name: Mark Johnson
  XMPPEXT:
    target: https://xmpp.org/extensions/
    title: XMPP Extensions



--- abstract

This memo documents the Security Automation and Continuous Monitoring (SACM) architecture and begins to explore a potential solution based on {{I-D.ietf-mile-xmpp-grid}}. The SACM architecture is predicated upon information gleaned from SACM Use Cases and Requirements ({{RFC7632}} and {{RFC8248}} respectively) and terminology as found in {{-sacmt}}.

--- middle

# Introduction
The SACM working group has experienced some difficulty gaining consensus around a single architectural vision. Our hope is that this document begins to alleviate this. We have recognized viability in approaches sometimes thought to be at odds with each other - specifically {{-ecp}} and {{I-D.ietf-mile-xmpp-grid}}. We believe that these approaches complement each other to more completely meet the spirit of {{RFC7632}} and {{RFC8248}}.

The authors recognize that some state collection mechanisms exist today, some do not, and of those that do, some may need to be improved. In other words, we can gain the most advantage by supporting a variety of collection mechanisms, including those that exist today. The authors further recognize that SACM ideally intends to enable a cooperative ecosystem of tools from disparate sources with minimal operator configuration. The architecture described in this document seeks to accommodate these recognitions by first defining a generic abstract architecture, then making that architecture somewhat more concrete.

## Requirements notation

The key words "MUST", "MUST NOT", "REQUIRED", "SHALL", "SHALL NOT",
"SHOULD", "SHOULD NOT", "RECOMMENDED", "NOT RECOMMENDED", "MAY", and
"OPTIONAL" in this document are to be interpreted as described in RFC
2119, BCP 14 {{RFC2119}}.

# Terms and Definitions
This draft defers to {{-sacmt}} for terms and definitions.

# The Basic Architecture
The architectural approach proposed herein recognizes existing state collection mechanisms and makes every attempt to respect {{RFC7632}} and {{RFC8248}}.

~~~~~~~~~~
+----------+      +------+   +------------+
|Repository|      |Policy|   |Orchestrator|
+----^-----+      +--^---+   +----^-------+       +----------------+
  A  |            B  |          C |               | Downstream Uses|
     |               |            |               | +-----------+  |
+----v---------------v------------v-------+       | |Evaluations|  |
|             Message Transfer            <-------> +-----------+  |
+----------------^------------------------+     D | +---------+    |
                 |                                | |Analytics|    |
                 |                                | +---------+    |
         +-------v---------                       | +---------+    |
         | Transfer System |                      | |Reporting|    |
         |    Connector    |                      | +---------+    |
         +-------^---------+                      +----------------+
                 |
                 |
         +-------v-------+       
         |   Collection  |        
         |     System    |          
         +---------------+

~~~~~~~~~~
{: #fig-notional title="Notional Architecture"}

As shown in {{fig-notional}}, the notional SACM architecture consists of some basic SACM Components using a message transfer system to communicate. While not depicted, the message transfer system is expected to maximally align with the requirements described in {{RFC8248}}, which means that the message transfer system will support brokered (i.e. point-to-point) and proxied data exchange.

Additionally, component-specific interfaces (i.e. such as A, B, C, and D in {{fig-notional}}) are expected to be specified logically then bound to one or more specific implementations. This should be done for each capability related to the given SACM Component.

## SACM Roles, Capabilities, and Functions
In this example architecture there are a variety of players in the cooperative ecosystem - we call these players SACM Components and recognize that they may be implemented in a composite manner. SACM Components may play one of several roles relevant to the ecosystem: Consumer, Provider. Each SACM Component, depending on its specialized role, will be endowed with one or more capabilities. These capabilities are realized by functions exposing specific interfaces.

## XMPP-based Solution
In {{fig-detailed}}, we have a more detailed view of the architecture - one that fosters the development of a pluggable ecosystem of cooperative tools. Existing collection mechanisms (ECP/SWIMA included) can be brought into this architecture by specifying the interface of the collector and creating the XMPP-Grid Connector. Additionally, while not directly depicted in {{fig-detailed}}, this architecture does not preclude point-to-point interfaces. In fact, {{-xmppgrid}} provides brokering capabilities to facilitate such point-to-point data transfers, though {{-xmppgrid}} does not provide everything SACM needs (an update to that draft or a new, extending draft is needed). Additionally, each of the SACM Components depicted in {{fig-detailed}} may be a Provider, a Consumer, or both, depending on the circumstance.

~~~~~~~~~~
  +----------+      +------+   +------------+
  |Repository|      |Policy|   |Orchestrator|
  +----^-----+      +--^---+   +----^-------+       
       |               |            |               
       |               |            |               
  +----v---------------v------------v-----------------+     +-----------------+
  |                     XMPP-Grid+                    <-----> Downstream Uses |
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

At this point, {{-xmppgrid}} does not provide enough of a start for SACM, and there are other XMPP extensions we need to consider to meet the needs of {{RFC7632}} and {{RFC8248}}. In {{fig-detailed}} we therefore use "XMPP-Grid+" to indicate something more than {{-xmppgrid}} alone. Specifically, the authors would propose work to extend (or modify) {{-xmppgrid}} to include additional XEPs, possibly the following:

* Entity Capabilities (XEP-0115): May be used to express the specific capabilities that a particular client embodies.
* Form Discovery and Publishing (XEP-0346): May be used for datastream examples requiring some expression of a request followed by an expected response.
* Ad Hoc Commands (XEP-0050): May be usable for simple orchestration (i.e. "do assessment").
* File Repository and Sharing (XEP-0214): Appears to be needed for handling large amounts of data (if not fragmenting).
* Publishing Stream Initiation Requests (XEP-0137): Provides ability to stream information between two XMPP entities.
* PubSub Collection Nodes (XEP-0248): Nested topics for specialization to the leaf node level.
* Security Labels In Pub/Sub (XEP-0314): Enables tagging data with classification categories.
* PubSub Chaining (XEP-0253): Federation of publishing nodes enabling a publish node of one server to be a subscriber to a publishing node of another server
* Easy User Onboarding (XEP-401): Simplified client registration

# SACM Components, Capabilities, and Interfaces
As previously mentioned, the SACM Architecture consists of a variety of SACM Components, and named components are intended to embody one or more specific capabilities. Interacting with these capabilities will require at least two levels of interface specification. The first is a logical interface specification, and the second is at least one binding to a specific transfer mechanism, where the preferred transfer mechanism would be XMPP-grid.

The scenarios described in this section are informational, but may be taken as guidance or a starting point for further specifications concerning each of these areas.

## Components
The list of SACM Components is theoretically endless, but we need to start somewhere. The following is a list of suggested SACM Component classes and specializations.

* Repository
  * Vulnerability Information Repository
  * Software Inventory Repository
  * Configuration Policy Repository
  * Configuration State Repository
* Collector
  * Software Inventory Collector
  * Vulnerability State Collector
  * Configuration State Collector
* Evaluator
  * Software Inventory Evaluator
  * Vulnerability State Evaluator
  * Configuration State Evaluator
* Orchestrator
  * Vulnerability Management Orchestrator
  * Configuration Management Orchestrator
  * Asset Management Orchestrator

### Policy Services
Consider a policy server conforming to {{-rolie}}. {{-rolie}} describes a RESTful way based on the ATOM Publishing Protocol ({{RFC5023}}) to find specific data collections. While this represents a specific binding (i.e. RESTful API based on {{RFC5023}}), there is a more abstract way to look at ROLIE.

ROLIE provides notional workspaces and collections, and provides the concept of information categories and links. Strictly speaking, these are logical concepts independent of the RESTful binding ROLIE specifies. In other words, ROLIE binds a logical interface (i.e. GET workspace, GET collection, SET entry, and so on) to a specific mechanism (namely an ATOM Publication Protocol extension).

It is not inconceivable to believe there could be a different interface mechanism, or a connector, providing these same operations using XMPP-Grid as the transfer mechanism.

### Software Inventory
The SACM working group has accepted work on the Endpoint Compliance Profile {{-ecp}}, which describes a collection architecture and may be viewed as a collector coupled with a collection-specific repository.

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

In {{fig-ecp}}, any of the communications between the Posture Manager and ECP components to its left could be performed directly or indirectly using a given message transfer mechanism. For example, the pub/sub interface between the Orchestrator and the Posture Manager could be using a proprietary method or using {{-xmppgrid}} or some other pub/sub mechanism. Similarly, the store connection from the Posture Manager to the Repository could be performed internally to a given implementation, via a RESTful API invocation over HTTPS, or even over a pub/sub mechanism.

Our assertion is that the Evaluator, Repository, Orchestrator, and Posture Manager all have the potential to represent SACM Components with specific capability interfaces that can be logically specified, then bound to one or more specific transfer mechanisms (i.e. RESTful API, {{-rolie}}, {{-xmppgrid}}, and so on).

### Datastream Collection
{{NIST800126}}, also known as SCAP 1.3, provides the technical specifications for a "datastream collection".  The specification describes the "datastream collection" as being "composed of SCAP data streams and SCAP source components".  A "datastream" provides an encapsulation of the SCAP source components required to, for example, perform configuration assessment on a given endpoint.  These source components include XCCDF checklists, OVAL Definitions, and CPE Dictionary information.  A single "datastream collection" may encapsulate multiple "datastreams", and reference any number of SCAP components.  Datastream collections were intended to provide an envelope enabling transfer of SCAP data more easily.

The {{NIST800126}} specification also defines the "SCAP result data stream" as being conformant to the Asset Reporting Format specification, defined in {{NISTIR7694}}.  The Asset Reporting Format provides an encapsulation of the SCAP source components, Asset Information, and SCAP result components, such as system characteristics and state evaluation results.

What {{NIST800126}}did not do is specify the interface for finding or acquiring source datastream information, nor an interface for publishing result information.  Discovering the actual resources for this information could be done via ROLIE, as described in the Policy Services section above, but other repositories of SCAP data exist as well.

### Network Configuration Collection
{{draft-birkholz-sacm-yang-content}} illustrates a SACM Component incorporating a YANG Push client function and an XMPP-grid publisher function. {{draft-birkholz-sacm-yang-content}} further states "the output of the YANG Push client function is encapsulated in a SACM Content Element envelope, which is again encapsulated in a SACM statement envelope" which are published, essentially, via an XMPP-Grid Connector for SACM Components also part of the XMPP-Grid.

This is a specific example of an existing collection mechanism being adapted to the XMPP-Grid message transfer system.

## Capabilities
Repositories will have a need for fairly standard CRUD operations and query by attribute operations. Collector interfaces may enable ad hoc assessment (on-demand processing), state item watch actions (i.e. watch a particular item for particular change), persisting other behaviors (i.e. setting some mandatory reporting period). Evaluators may have their own set of interfaces, and an Assessor would represent both Collector and Evaluation interfaces, and may have additional concerns added to an Assessor Interface.

## Interfaces
TBD

# Open Questions
TBD

# Privacy Considerations
TODO

# Security Considerations
TODO

# IANA Considerations
IANA tables can probably be used to make life a little easier. We would like a place to enumerate:

* Capability/operation semantics
* SACM Component implementation identifiers
* SACM Component versions
* Associations of SACM Components (and versions) to specific Capabilities


--- back


# Mapping to RFC8248
This section provides a mapping of XMPP and XMPP Extensions to the relevant requirements from {{RFC8248}}. In the table below, the ID and Name columns provide the ID and Name of the requirement directly out of {{RFC8248}}. The Supported By column may contain one of several values:

* N/A: The requirement is not applicable to this architectural exploration
* XMPP-Core: The requirement is satisfied by a core XMPP feature
* XEP-nnnn: The requirement is satisfied by a numbered XMPP extension (see {{XMPPEXT}})
* Operational: The requirement is an operational concern or can be addressed by an operational deployment
* Implementation: The requirement is an implementation concern

If there is no entry in the Supported By column, then there is a gap that must be filled.

| ID       | Name                                        | Supported By |
|----------|---------------------------------------------|:------------:|
| G-001    | Solution Extensibility                      |              |
| G-002    | Interoperability                            |              |
| G-003    | Scalability                                 |              |
| G-004    | Versatility                                 |              |
| G-005    | Information Extensibility                   |              |
| G-006    | Data Protection                             |              |
| G-007    | Data Partitioning                           |              |
| G-008    | Versioning and Backward Compatibility       |              |
| G-009    | Information Discovery                       |              |
| G-010    | Target Endpoint Discovery                   |              |
| G-011    | Push and Pull Access                        |              |
| G-012    | SACM Component Interface                    |              |
| G-013    | Endpoint Location and Network Topology      |              |
| G-014    | Target Endpoint Identity                    |              |
| G-015    | Data Access Control                         |              |
| ARCH-001 | Component Functions                         |              |
| ARCH-002 | Scalability                                 |              |
| ARCH-003 | Flexibility                                 |              |
| ARCH-004 | Separation of Data and Management Functions |              |
| ARCH-005 | Topology Flexibility                        |              |
| ARCH-006 | Capability Negotiation                      |              |
| ARCH-007 | Role-Based Authorization                    |              |
| ARCH-008 | Context-Based Authorization                 |              |
| ARCH-009 | Time Synchronization                        |              |
| IM-001   | Extensible Attribute Vocabulary             |              |
| IM-002   | Posture Data Publication                    |              |
| IM-003   | Data Model Negotiation                      |              |
| IM-004   | Data Model Identification                   |              |
| IM-005   | Data Lifetime Management                    |              |
| IM-006   | Singularity and Modularity                  |              |
| DM-001   | Element Association                         |              |
| DM-002   | Data Model Structure                        |              |
| DM-003   | Search Flexibility                          |              |
| DM-004   | Full vs. Partial Updates                    |              |
| DM-005   | Loose Coupling                              |              |
| DM-006   | Data Cardinality                            |              |
| DM-007   | Data Model Negotiation                      |              |
| DM-008   | Data Origin                                 |              |
| DM-009   | Origination Time                            |              |
| DM-010   | Data Generation                             |              |
| DM-011   | Data Source                                 |              |
| DM-012   | Data Updates                                |              |
| DM-013   | Multiple Collectors                         |              |
| DM-014   | Attribute Extensibility                     |              |
| DM-015   | Solicited vs. Unsolicited Updates           |              |
| DM-016   | Transfer Agnostic                           |              |
| OP-001   | Time Synchronization                        |              |
| OP-002   | Collection Abstraction                      |              |
| OP-003   | Collection Composition                      |              |
| OP-004   | Attribute-Based Query                       |              |
| OP-005   | Information-Based Query with Filtering      |              |
| OP-006   | Operation Scalability                       |              |
| OP-007   | Data Abstraction                            |              |
| OP-008   | Provider Restriction                        |              |
| T-001    | Multiple Transfer Protocol Support          |              |
| T-002    | Data Integrity                              |              |
| T-003    | Data Confidentiality                        |              |
| T-004    | Transfer Protection                         |              |
| T-005    | Transfer Reliability                        |              |
| T-006    | Transfer-Layer Requirements                 |              |
| T-007    | Transfer Protocol Adoption                  |              |
