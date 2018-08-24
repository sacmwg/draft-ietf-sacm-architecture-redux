---
title: Security Automation and Continuous Monitoring (SACM) Architecture
abbrev: SACM Architecture
docname: draft-ietf-sacm-arch-00
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
  RFC8412:
  mandl-sacm-tool-capability-language:
  mandm-sacm-assessment-model:
  mandm-sacm-collection-model:
  mandm-sacm-evaluation-model:
  mandm-sacm-endpoint-attribute-data-model-registry:
  I-D.ietf-sacm-ecp: ecp
  I-D.ietf-mile-xmpp-grid: xmppgrid

informative:
  I-D.ietf-sacm-terminology: sacmt
  RFC8322: rolie
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
  CISCONTROLS:
    target: https://www.cisecurity.org/controls
    title: CIS Controls v7.0
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
  HACK99:
    target: https://www.github.com/sacmwg/vulnerability-scenario/ietf-hackathon
    title: IETF 99 Hackathon - Vulnerability Scenario EPCP
  HACK100:
    target: https://www.github.com/sacmwg/vulnerability-scenario/ietf-hackathon
    title: IETF 100 Hackathon - Vulnerability Scenario EPCP+XMPP
  HACK101:
    target: https://www.github.com/CISecurity/Integration
    title: IETF 101 Hackathon - Configuration Assessment XMPP
  HACK102:
    target: https://www.github.com/CISecurity/YANG
    title: IETF 102 Hackathon - YANG Collection on Traditional Endpoints

--- abstract

This memo defines a Security Automation and Continuous Monitoring (SACM) architecture. This work is built upon {{-xmppgrid}}, and is predicated upon information gleaned from SACM Use Cases and Requirements ({{RFC7632}} and {{RFC8248}} respectively), and terminology as found in {{-sacmt}}.

WORKING GROUP: The source for this draft is maintained in GitHub.  Suggested changes should be submitted as pull requests at https://github.com/adammontville/ietf-mandm-sacm-architecture/.  Instructions are on that page as well.

--- middle

# Introduction
The purpose of this draft is to define an architectural solution for a SACM Domain. This draft also defines an implementation of the architecutre, built upon {{-xmppgrid}} and {{-ecp}}. These approaches complement each other to more completely meet the spirit of {{RFC7632}} and requirements found in {{RFC8248}}.

This solution gains the most advantage by supporting a variety of collection mechanisms. In this sense, the solution ideally intends to enable a cooperative ecosystem of tools from disparate sources with minimal operator configuration. The solution described in this document seeks to accommodate these recognitions by first defining a generic abstract architecture, then making that solution somewhat more concrete.

Keep in mind that, at this point, the draft is tracking ongoing work being performed primarily around and during IETF hackathons. The list of hackathon efforts follows:

* {{HACK99}}: A partial implementation of a vulnerability assessment scenario involving an {{-ecp}} implementation, a {{-rolie}} implementation, and a proprietary evaluator to pull the pieces together.
* {{HACK100}}: Work to combine the vulnerability assessment scenario from {{HACK99}} with an XMPP-based YANG push model.
* {{HACK101}}: A fully automated configuration assessment implementation using XMPP as a communication mechanism.
* {{HACK102}}: An exploration of how we might model assessment, collection, and evaluation abstractly, and then rely on YANG expressions for the attributes of traditional endpoints.

## Open Questions
[NOTE: This section will eventually be removed.]

The following is a list of open questions we still have about the path forward with this exploration:

* Should workflows be documented in this draft or separate drafts?
* Should interfaces be documented in workflow drafts or separate drafts (or even this draft)?

## Requirements notation

The key words "MUST", "MUST NOT", "REQUIRED", "SHALL", "SHALL NOT",
"SHOULD", "SHOULD NOT", "RECOMMENDED", "NOT RECOMMENDED", "MAY", and
"OPTIONAL" in this document are to be interpreted as described in RFC
2119, BCP 14 {{RFC2119}}.

# Terms and Definitions
This draft defers to {{-sacmt}} for terms and definitions.

# Architectural Overview
The generic approach proposed herein recognizes the need to obtain information from existing state collection mechanisms, and makes every attempt to respect {{RFC7632}} and {{RFC8248}}. At the foundation of any architecture are entities, or components, that need to communicate. They communicate by sharing information, where, in a given flow one or more components are consumers of information and one or more components are providers of information.

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

Additionally, component-specific interfaces (i.e. such as A, B, C, and D in {{fig-notional}}) are expected to be specified logically then bound to one or more specific implementations. This SHOULD be done for each capability related to the given SACM Component.

## SACM Roles
This document suggests a variety of players in a cooperative ecosystem - we call these players SACM Components. SACM Components may be composed of other SACM Components, and each SACM Component plays one, or more, of several roles relevant to the ecosystem. Generally each role is either a consumer of information or a provider of information. The "Components, Capabilities, Interfaces, and Workflows" section provides more details about SACM Components that play these types of roles.

## Exploring An XMPP-based Solution
{{fig-detailed}} depicts a more detailed view of the architecture - one that fosters the development of a pluggable ecosystem of cooperative tools. Existing collection mechanisms can be brought into this architecture by specifying the interface of the collector and creating the XMPP-Grid Connector binding for that interface.

Additionally, while not directly depicted in {{fig-detailed}}, this architecture does allow point-to-point interfaces. In fact, {{-xmppgrid}} provides brokering capabilities to facilitate such point-to-point data transfers). Additionally, each of the SACM Components depicted in {{fig-detailed}} may be a provider, a consumer, or both, depending on the workflow in context.

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
|  +----v-----+  +----v-----+  +----v----+   +----v----+  |
|  |EPCP/SWIMA|  |Datastream|  |YANG Push|   |  IPFIX  |  |
|  +----------+  +----------+  +---------+   +---------+  |
|                      Collectors                         |
\~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~/
~~~~~~~~~~
{: #fig-detailed title="Detailed Architecture"}

At this point, {{-xmppgrid}} specifies fewer features than SACM requires, and there are other XMPP extensions (XEPs) we need to consider to meet the needs of {{RFC7632}} and {{RFC8248}}. In {{fig-detailed}} we therefore use "XMPP-Grid+" to indicate something more than {{-xmppgrid}} alone, even though we are not yet fully confident in the exact set of XMPP-related extensions we will require. The authors propose work to extend (or modify) {{-xmppgrid}} to include additional XEPs - possibly the following:

* Entity Capabilities (XEP-0115): May be used to express the specific capabilities that a particular client embodies.
* Form Discovery and Publishing (XEP-0346): May be used for datastream examples requiring some expression of a request followed by an expected response.
* Ad Hoc Commands (XEP-0050): May be usable for simple orchestration (i.e. "do assessment").
* File Repository and Sharing (XEP-0214): Appears to be needed for handling large amounts of data (if not fragmenting).
* Publishing Stream Initiation Requests (XEP-0137): Provides ability to stream information between two XMPP entities.
* PubSub Collection Nodes (XEP-0248): Nested topics for specialization to the leaf node level.
* Security Labels In Pub/Sub (XEP-0314): Enables tagging data with classification categories.
* PubSub Since (XEP-0312): Persists published items, which may be useful in intermittent connection scenarios
* PubSub Chaining (XEP-0253): Federation of publishing nodes enabling a publish node of one server to be a subscriber to a publishing node of another server
* Easy User Onboarding (XEP-401): Simplified client registration

# Components, Capabilities, Interfaces, and Workflows
The SACM Architecture consists of a variety of SACM Components, and named components are intended to embody one or more specific capabilities. Interacting with these capabilities will require at least two levels of interface specification. The first is a logical interface specification, and the second is at least one binding to a specific transfer mechanism. An example transfer mechanism is XMPP-Grid+.

The following subsections describe some of the components, capabilities, and interfaces we may expect to see participating in a SACM Domain.

## Components
The following is a list of suggested SACM Component classes and specializations.

* Repository
  * Vulnerability Information Repository
  * Asset Inventory Repository
    * Software Inventory Repository
    * Device Inventory Repository
  * Configuration Policy Repository
  * Configuration State Repository
* Collector
  * Vulnerability State Collector
  * Asset Inventory Collector
    * Software Inventory Collector
    * Device Inventory Collector
  * Configuration State Collector
* Evaluator
  * Vulnerability State Evaluator
  * Asset Inventory Evaluator
    * Software Inventory Evaluator
    * Device Inventory Evaluator
  * Configuration State Evaluator
* Orchestrator
  * Vulnerability Management Orchestrator
  * Asset Management Orchestrator
    * Software Inventory Evaluator
    * Device Inventory Evaluator
  * Configuration Management Orchestrator


## Capabilities
Repositories will have a need for fairly standard CRUD operations and query by attribute operations. Collector interfaces may enable ad hoc assessment (on-demand processing), state item watch actions (i.e. watch a particular item for particular change), persisting other behaviors (i.e. setting some mandatory reporting period). Evaluators may have their own set of interfaces, and an Assessor would represent both Collector and Evaluation interfaces, and may have additional concerns added to an Assessor Interface.

Not to be overlooked, whatever solution at which we arrive, per {{RFC8248}}, MUST support capability negotiation. While not explicitly treated here, each interface will understand specific serializations, and other component needs to express those serializations to other components.

A capability language is fully explored in mandl-sacm-tool-capability-language (to be submitted).

## Interfaces
Interfaces should be derived directly from identified workflows, several of which are described in this document.  

## Workflows
The workflows described in this document should be considered as candidate workflows - informational for the purpose of discovering the necessary components and specifying their interfaces.

### IT Asset Management
Information Technology asset management is easier said than done. The {{CISCONTROLS}} have two controls dealing with IT asset management. Control 1, Inventory and Control of Hardware Assets, states, "Actively manage (inventory, track, and correct) all hardware devices on the network so that only authorized devices are given access, and unauthorized and unmanaged devices are found and prevented from gaining access." Control 2, Inventory and Control of Software Assets, states, "Actively manage (inventory, track, and correct) all software on the network so that only authorized software is installed and can execute, and that unauthorized and unmanaged software is found and prevented from installation or execution."

In spirit, this covers all of the processing entities on your network (as opposed to things like network cables, dongles, adapters, etc.), whether physical or virtual.

An IT asset management capability needs to be able to:

- Identify and catalog new assets by executing Target Endpoint Discovery Tasks
- Provide information about its managed assets, including uniquely identifying information (for that enterprise)
- Handle software and/or hardware (including virtual assets)
- Represent cloud hybrid environments

### Vulnerability Management
Vulnerability management is a relatively established process. According to the {{CISCONTROLS}}, continuous vulnerability management the act of continuously acquiring, assessing, and taking subsequent action on new information in order to identify and remediate vulnerabilities, therefore minimizing the window of opportunity for attackers.

#### Vulnerability Assessment Workflow Assumptions
A number of assumptions must be stated to clarify the scope of a vulnerability assessment workflow:

* The enterprise has received vulnerability description information, and that the information has already been processed into vulnerability detection data that the enterprise's security software tools can understand and use.
* The enterprise has a suitable IT Asset Management capability
* The enterprise has a means of extracting relevant information about enterprise endpoints in a form that is compatible with the vulnerability description data (appropriate Collectors for their technologies)
* All information described in this scenario is available in the vulnerability description data and serves as the basis of assessments.
* The enterprise can provide all relevant information about any endpoint needed to perform the described assessment (the appropriate Repositories are available)
* The enterprise has a mechanism for long-term storage of vulnerability description information, vulnerability detection data, and vulnerability assessment results.
* The enterprise has a procedure for reassessment of endpoints at some point after initial assessment


#### Vulnerability Assessment Workflow
When new vulnerability description information is received by the enterprise, affected endpoints are identified and assessed. The vulnerability is said to apply to an endpoint if the endpoint satisfies the conditions expressed in the vulnerability detection data.

A vulnerability assessment (i.e. vulnerability detection) is performed in two steps:

* Endpoint information collected by the endpoint management capabilities is examined by the vulnerability management capabilities through Evaluation Tasks.
* If the data possessed by the endpoint management capabilities is insufficient, a Collection Task is triggered and the necessary data is collected from the target endpoint.

Vulnerability detection relies on the examination of different endpoint information depending on the nature of a specific vulnerability. Common endpoint information used to detect a vulnerability includes:

* A specific software version is installed on the endpoint
* File system attributes
* Specific state attributes

In many cases, the endpoint information needed to determine an endpoint's vulnerability status will have been previously collected by the endpoint management capabilities and available in a Repository. However, in other cases, the necessary endpoint information will not be readily available in a Repository and a Collection Task will be triggered to collect it from the target endpoint. Of course, some implementations of endpoint management capabilities may prefer to enable operators to perform this collection under certain circumstances, even when sufficient information can be provided by the endpoint management capabilities (e.g. there may be freshness requirements for information).

The collection of additional endpoint information for the purpose of vulnerability assessment does not necessarily need to be a pull by the vulnerability assessment capabilities. Over time, some new pieces of information that are needed during common types of assessments might be identified. Endpoint management capabilities can be reconfigured to have this information delivered automatically. This avoids the need to trigger additional Collection Tasks to gather this information during assessments, streamlining the assessment process. Likewise, it might be observed that certain information delivered by endpoint management capabilities is rarely used. In this case, it might be useful to re-configure the endpoint management capabilities to no longer collect this information to reduce network and processing overhead. Instead, a new Collection Task can be triggered to gather this data on the rare occasions when it is needed.

### Configuration Management
Configuration management involves configuration assessment, which requires state assessment (TODO: Tie to SACM use cases). The {{CISCONTROLS}} specify two high-level controls conerning configuration managment (Control 5 for non-network devices and Control 11 for network devices). As an aside, these controls are listed separately because many enterprises have different organizations for managing network infrastructure and workload endpoints. Merging the two controls results in a requirement to: "Establish, implement, and actively manage (track, report on, correct) the security configuration of (endpoints) using a rigorous configuration management and change control process in order to prevent attackers from exploiting vulnerable services and settings."

Typically, an enterprise will use configuration guidance from a reputable source, and from time to time they may tailor the guidance from that source prior to adopting it as part of their enterprise standard. The enterprise standard is then provided to the appropriate configuration assessment tools and they assess endpoints and/or appropriate endpoint information. A preferred flow follows:

- Reputable source publishes new or updated configuration guidance
- Enterprise configuration assessment capability retrieves configuration guidance from reputable source
- Optional: Configuration guidance is tailored for enterprise-specific needs
- Configuration assessment tool queries asset inventory repository to retrieve a list of affected endpoints
- Configuration assessment tool queries configuration state repository to evaluate compliance
- If information is stale or unavailable, configuration assessment tool triggers an ad hoc assessment

The SACM architecture needs to support varying deployment models to accommodate the current state of the industry, but should strongly encourage event-driven approaches to monitoring configuration.


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
* Architecture: This architecture (possibly assuming some components) should meet the requirement
* XMPP: The set of XMPP Core specifications and the collection of applicable extensions, deployment, and operational considerations.
* XMPP-Core: The requirement is satisfied by a core XMPP feature
* XEP-nnnn: The requirement is satisfied by a numbered XMPP extension (see {{XMPPEXT}})
* Operational: The requirement is an operational concern or can be addressed by an operational deployment
* Implementation: The requirement is an implementation concern

If there is no entry in the Supported By column, then there is a gap that must be filled.

| ID       | Name                                        | Supported By |
|----------|---------------------------------------------|:------------:|
| G-001    | Solution Extensibility                      | XMPP-Core    |
| G-002    | Interoperability                            | XMPP         |
| G-003    | Scalability                                 | XMPP         |
| G-004    | Versatility                                 | XMPP-Core    |
| G-005    | Information Extensibility                   | XMPP-Core    |
| G-006    | Data Protection                             | Operational  |
| G-007    | Data Partitioning                           | Operational  |
| G-008    | Versioning and Backward Compatibility       | XEP-0115/0030|
| G-009    | Information Discovery                       | XEP-0030     |
| G-010    | Target Endpoint Discovery                   | XMPP-Core    |
| G-011    | Push and Pull Access                        | XEP-0060/0312|
| G-012    | SACM Component Interface                    | N/A          |
| G-013    | Endpoint Location and Network Topology      |              |
| G-014    | Target Endpoint Identity                    | XMPP-Core    |
| G-015    | Data Access Control                         |              |
| ARCH-001 | Component Functions                         | XMPP         |
| ARCH-002 | Scalability                                 | XMPP-Core    |
| ARCH-003 | Flexibility                                 | XMPP-Core    |
| ARCH-004 | Separation of Data and Management Functions |              |
| ARCH-005 | Topology Flexibility                        | XMPP-Core    |
| ARCH-006 | Capability Negotiation                      | XEP-0115/0030|
| ARCH-007 | Role-Based Authorization                    | XMPP-Core    |
| ARCH-008 | Context-Based Authorization                 |              |
| ARCH-009 | Time Synchronization                        | Operational  |
| IM-001   | Extensible Attribute Vocabulary             | N/A          |
| IM-002   | Posture Data Publication                    | N/A          |
| IM-003   | Data Model Negotiation                      | N/A          |
| IM-004   | Data Model Identification                   | N/A          |
| IM-005   | Data Lifetime Management                    | N/A          |
| IM-006   | Singularity and Modularity                  | N/A          |
| DM-001   | Element Association                         | N/A          |
| DM-002   | Data Model Structure                        | N/A          |
| DM-003   | Search Flexibility                          | N/A          |
| DM-004   | Full vs. Partial Updates                    | N/A          |
| DM-005   | Loose Coupling                              | N/A          |
| DM-006   | Data Cardinality                            | N/A          |
| DM-007   | Data Model Negotiation                      | N/A          |
| DM-008   | Data Origin                                 | N/A          |
| DM-009   | Origination Time                            | N/A          |
| DM-010   | Data Generation                             | N/A          |
| DM-011   | Data Source                                 | N/A          |
| DM-012   | Data Updates                                | N/A          |
| DM-013   | Multiple Collectors                         | N/A          |
| DM-014   | Attribute Extensibility                     | N/A          |
| DM-015   | Solicited vs. Unsolicited Updates           | N/A          |
| DM-016   | Transfer Agnostic                           | N/A          |
| OP-001   | Time Synchronization                        |              |
| OP-002   | Collection Abstraction                      |              |
| OP-003   | Collection Composition                      |              |
| OP-004   | Attribute-Based Query                       |              |
| OP-005   | Information-Based Query with Filtering      |              |
| OP-006   | Operation Scalability                       |              |
| OP-007   | Data Abstraction                            |              |
| OP-008   | Provider Restriction                        |              |
| T-001    | Multiple Transfer Protocol Support          | Architecture |
| T-002    | Data Integrity                              | Operational  |
| T-003    | Data Confidentiality                        | Operational  |
| T-004    | Transfer Protection                         |              |
| T-005    | Transfer Reliability                        |              |
| T-006    | Transfer-Layer Requirements                 |              |
| T-007    | Transfer Protocol Adoption                  | Architecture |

# Example Components

## Policy Services
Consider a policy server conforming to {{-rolie}}. {{-rolie}} describes a RESTful way based on the ATOM Publishing Protocol ({{RFC5023}}) to find specific data collections. While this represents a specific binding (i.e. RESTful API based on {{RFC5023}}), there is a more abstract way to look at ROLIE.

ROLIE provides notional workspaces and collections, and provides the concept of information categories and links. Strictly speaking, these are logical concepts independent of the RESTful binding ROLIE specifies. In other words, ROLIE binds a logical interface (i.e. GET workspace, GET collection, SET entry, and so on) to a specific mechanism (namely an ATOM Publication Protocol extension).

It is not inconceivable to believe there could be a different interface mechanism, or a connector, providing these same operations using XMPP-Grid as the transfer mechanism.

Even if a {{-rolie}} server were external to an organization, there would be a need for a policy source inside the organization as well, and it may be preferred for such a policy source to be connected directly to the ecosystem's communication infrastructure.

## Software Inventory
The SACM working group has accepted work on the Endpoint Posture Collection Profile {{-ecp}}, which describes a collection architecture and may be viewed as a collector coupled with a collection-specific repository.

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
{: #fig-ecp title="EPCP Collection Architecture"}

In {{fig-ecp}}, any of the communications between the Posture Manager and EPCP components to its left could be performed directly or indirectly using a given message transfer mechanism. For example, the pub/sub interface between the Orchestrator and the Posture Manager could be using a proprietary method or using {{-xmppgrid}} or some other pub/sub mechanism. Similarly, the store connection from the Posture Manager to the Repository could be performed internally to a given implementation, via a RESTful API invocation over HTTPS, or even over a pub/sub mechanism.

Our assertion is that the Evaluator, Repository, Orchestrator, and Posture Manager all have the potential to represent SACM Components with specific capability interfaces that can be logically specified, then bound to one or more specific transfer mechanisms (i.e. RESTful API, {{-rolie}}, {{-xmppgrid}}, and so on).

## Datastream Collection
{{NIST800126}}, also known as SCAP 1.3, provides the technical specifications for a "datastream collection".  The specification describes the "datastream collection" as being "composed of SCAP data streams and SCAP source components".  A "datastream" provides an encapsulation of the SCAP source components required to, for example, perform configuration assessment on a given endpoint.  These source components include XCCDF checklists, OVAL Definitions, and CPE Dictionary information.  A single "datastream collection" may encapsulate multiple "datastreams", and reference any number of SCAP components.  Datastream collections were intended to provide an envelope enabling transfer of SCAP data more easily.

The {{NIST800126}} specification also defines the "SCAP result data stream" as being conformant to the Asset Reporting Format specification, defined in {{NISTIR7694}}.  The Asset Reporting Format provides an encapsulation of the SCAP source components, Asset Information, and SCAP result components, such as system characteristics and state evaluation results.

What {{NIST800126}}did not do is specify the interface for finding or acquiring source datastream information, nor an interface for publishing result information.  Discovering the actual resources for this information could be done via ROLIE, as described in the Policy Services section above, but other repositories of SCAP data exist as well.

## Network Configuration Collection
{{draft-birkholz-sacm-yang-content}} illustrates a SACM Component incorporating a YANG Push client function and an XMPP-grid publisher function. {{draft-birkholz-sacm-yang-content}} further states "the output of the YANG Push client function is encapsulated in a SACM Content Element envelope, which is again encapsulated in a SACM statement envelope" which are published, essentially, via an XMPP-Grid Connector for SACM Components also part of the XMPP-Grid.

This is a specific example of an existing collection mechanism being adapted to the XMPP-Grid message transfer system.
