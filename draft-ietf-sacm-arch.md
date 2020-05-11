---
title: Security Automation and Continuous Monitoring (SACM) Architecture
abbrev: SACM Architecture
docname: draft-ietf-sacm-arch-06
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
  email: adam.montville.sdo@gmail.com
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
  RFC8600: xmppgrid

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
  HACK103:
    target: https://www.ietf.org/how/meetings/103/
    title: IETF 103 Hackathon - N/A
  HACK104:
    target: https://github.com/CISecurity/SACM-Architecture
    title: IETF 104 Hackathon - A simple XMPP client
  HACK105:
    target: https://github.com/CISecurity/SACM-Architecture
    title: IETF 105 Hackathon - A more robust XMPP client including collection extensions

--- abstract

This document defines an architecture enabling a cooperative Security Automation and Continuous Monitoring (SACM) ecosystem.  This work is predicated upon information gleaned from SACM Use Cases and Requirements ({{RFC7632}} and {{RFC8248}} respectively), and terminology as found in {{-sacmt}}.

WORKING GROUP: The source for this draft is maintained in GitHub.  Suggested changes should be submitted as pull requests at https://github.com/sacmwg/ietf-mandm-sacm-arch/.  Instructions are on that page as well.

--- middle

# Introduction
The purpose of this draft is to define an architectural approach for a SACM Domain, based on the spirit of use cases found in {{RFC7632}} and requirements found in {{RFC8248}}. This approach gains the most advantage by supporting a variety of collection systems, and intends to enable a cooperative ecosystem of tools from disparate sources with minimal operator configuration.

## Requirements notation
The key words "MUST", "MUST NOT", "REQUIRED", "SHALL", "SHALL NOT",
"SHOULD", "SHOULD NOT", "RECOMMENDED", "NOT RECOMMENDED", "MAY", and
"OPTIONAL" in this document are to be interpreted as described in RFC
2119, BCP 14 {{RFC2119}}.

# Terms and Definitions
This draft defers to {{-sacmt}} for terms and definitions.

# Architectural Overview
The generic approach proposed herein recognizes the need to obtain information from existing and future state collection systems, and makes every attempt to respect {{RFC7632}} and {{RFC8248}}. At the foundation of any architecture are entities, or components, that need to communicate. They communicate by sharing information, where, in a given flow, one or more components are consumers of information and one or more components are providers of information.

~~~~~~~~~~
       +----------------+
       | SACM Component |
       |   (Provider)   |
       +-------+--------+
               |
               |
+--------------v----------------+
|      Integration Service      |
+--------------+----------------+
               |
               |
       +-------v--------+
       | SACM Component |
       |   (Consumer)   |
       +----------------+
~~~~~~~~~~
{: #fig-basic title="Basic Architectural Structure"}

A provider can be described as an abstraction that refers to an entity capable of sending SACM-relevant information to one or many consumers.  Consumers can be described as an abstraction that refers to an entity capable of receiving SACM-relevant information from one or many providers.  Different roles within a cooperative ecosystem may act as both providers and consumers of SACM-relevant information.

## SACM Role-based Architecture
Within the cooperative SACM ecosystem, a number of roles act in coordination to provide relevant policy/guidance, perform data collection, storage, evaluation, and support downstream analytics and reporting.

~~~~~~~~~~
   +-----------------+     +--------------------+
   | Orchestrator(s) |     | Repositories/CMDBs |
   +---------^-------+     +----------^---------+
             |                        |             +--------------------+
             |                        |             |  Downstream Uses   |
             |                        |             | +----------------+ |
 +-----------v------------------------v------+      | |   Analytics    | |
 |             Integration Service           <------> +----------------+ |
 +-----------^--------------------------^----+      | +----------------+ |
             |                          |           | |   Reporting    | |
             |                          |           | +----------------+ |
 +-----------v-------------------+      |           +--------------------+
 |  Collection Sub-Architecture  |      |
 +-------------------------------+      |
                        +---------------v---------------+
                        |  Evaluation Sub-Architecture  |
                        +-------------------------------+

~~~~~~~~~~
{: #fig-notional title="Notional Role-based Architecture"}

As shown in {{fig-notional}}, the SACM role-based architecture consists of some basic SACM Components communicating using an integration service. The integration service is expected to maximally align with the requirements described in {{RFC8248}}, which means that the integration service will support brokered (i.e. point-to-point) and proxied data exchange.

## Architectural Roles/Components
This document suggests a variety of players in a cooperative ecosystem; known as SACM Components. SACM Components may be composed of other SACM Components, and each SACM Component plays one, or more, of several roles relevant to the ecosystem. Roles may act as providers of information, consumers of information, or both provider and consumer.  {{fig-notional}} depicts a number of SACM components which are architecturally significant and therefore warrant discussion and clarification.

### Orchestrator(s)
Orchestration components exists to aid in the automation of configuration, coordination, and management for the ecosystem of SACM components.  The Orchestrator performs control-plane operations, administration of an implementing organization's components (including endpoints, posture collection services, and downstream activities), scheduling of automated tasks, and any ad-hoc activities such as the initiation of collection or evaluation activities.  The Orchestrator is the key administrative interface into the SACM architecture.

### Repositories/CMDBs
{{fig-notional}} only includes a single reference to "Repositories/CMDBs", but in practice, a number of separate data repositories may exist, including posture attribute repositories, policy repositories, local vulnerability definition data repositories, and state assessment results repositories.  These data repositories may exist separately or together in a single representation, and the design of these repositories may be as distinct as their intended purpose, such as the use of relational database management systems or graph/map implementations focused on the relationships between data elements.  Each implementation of a SACM repository should focus on the relationships between data elements and implement the SACM information and data model(s).

### Integration Service
If each SACM component represents a set of capabilities, the Integration Service represents the "fabric" by which all those services are woven together.  The Integration Service acts as a message broker, combining a set of common message categories and infrastructure to allow SACM components to communicate using a shared set of interfaces.  The Integration Service's brokering capabilities enable the exchange of various information payloads, orchestration of component capabilities, message routing and reliable delivery.  The Integration Service minimizes the dependencies from one system to another through the loose coupling of applications through messaging.  SACM components will "attach" to the Integration Service either through native support for the integration implementation, or through the use of "adapters" which provide a proxied attachment.

The Integration Service should provide mechanisms for both synchronous and asynchronous "request/response"-style messaging, and a publish/subscribe mechanism to implement event-based messaging.  It is the responsibility of the Integration Service to coordinate and manage the sending and receiving of messages.  The Integration Service should allow components the ability to directly connect and produce or consume messages, or connect via message translators which can act as a proxy, transforming messages from a component format to one implementing a SACM data model.

The Integration Service MUST provide routing capabilities for payloads between producers and consumers.  The Integration Service MAY provide further capabilities within the payload delivery pipeline.  Examples of these capabilities include, but are not limited to, intermediate processing, message transformation, type conversion, validation, or other enterprise integration patterns.

## Downstream Uses
As depicted by {{fig-notional}}, a number of downstream uses exist in the cooperative ecosystem.  Each notional SACM component represents distinct sub-architectures which will exchange information via the integration services, using interactions described in this draft.

### Reporting
The Reporting component represents capabilities outside of the SACM architecture scope dealing with the query and retrieval of collected posture attribute information, evaluation results, etc. in various display formats that are useful to a wide range of stakeholders.

### Analytics
The Analytics component represents capabilities outside of the SACM architecture scope dealing with the discovery, interpretation, and communication of any meaningful patterns of data in order to inform effective decision making within the organization.

## Sub-Architectures
{{fig-notional}} shows two components representing sub-architectural roles involved in a cooperative ecosystem of SACM components: Collection and Evaluation.

### Collection Sub-Architecture
The Collection sub-architecture is, in a SACM context, the mechanism by which posture attributes are collected from applicable endpoints and persisted to a repository, such as a configuration management database (CMDB).  Orchestration components will choreograph endpoint data collection via defined interactions, using the Integration Service as a message broker.  Instructions to perform endpoint data collection are directed to a Posture Collection Service capable of performing collection activities utilizing any number of methods, such as SNMP, NETCONF/RESTCONF, SSH, WinRM, packet capture, or host-based.

~~~~~~~~~~
  +----------------------------------------------------------+
  |                    Orchestrator(s)                       |
  +-----------+----------------------------------------------+
              |               +------------------------------+
              |               | Posture Attribute Repository |
              |               +--------------^---------------+
           Perform                           |
          Collection                         |
              |                       Collected Data
              |                              ^
              |                              |
  +-----------v------------------------------+---------------+
  |                    Integration Service                   |
  +----+------------------^-----------+------------------^---+
       |                  |           |                  |
       v                  |           v                  |
    Perform           Collected    Perform           Collected
   Collection           Data      Collection           Data
       |                  ^           |                  ^
       |                  |           |                  |
  +----v-----------------------+ +----|------------------|------+
  | Posture Collection Service | |    |     Endpoint     |      |
  +---^------------------------+ | +--v------------------+----+ |
      |                   |      | |Posture Collection Service| |
      |                   v      | +--------------------------+ |
    Events             Queries   +------------------------------+
      ^                   |          (PCS resides on Endpoint)
      |                   |
  +---+-------------------v----+
  |          Endpoint          |
  +----------------------------+
(PCS does not reside on Endpoint)

~~~~~~~~~~
{: #fig-collection title="Decomposed Collection Sub-Architecture"}

#### Posture Collection Service
The Posture Collection Service (PCS) is the SACM component responsible for the collection of posture attributes from an endpoint or set of endpoints.  A single PCS may be responsible for management of posture attribute collection from many endpoints.  The PCS will interact with the Integration Service to receive collection instructions and to provide collected posture data for persistence to the Posture Attribute Repository.  Collection instructions may be supplied in a variety of forms, including subscription to a publish/subscribe topic to which the Integration Service has published instructions, or via request/response-style messaging (either synchronous or asynchronous).

Four classifications of posture collections MAY be supported.

##### Ad-Hoc
Ad-Hoc collection is defined as a single colletion of posture attributes, collected at a particular time.  An example of ad-hoc collection is the single collection of a specific registry key.

##### Continuous/Scheduled
Continuous/Scheduled collection is defined as the ongoing, periodic collection of posture attributes.  An example of scheduled collection is the collection of a specific registry key value every day at a given time.

##### Observational
This classification of collection is triggered by the observation, external to an endpoint, of information asserting posture attribute values for that endpoint.  An example of observational collection is examination of netflow data for particular packet captures and/or specific information within those captures.

##### Event-based
Event-based collection may be triggered either internally or externally to the endpoint.  Internal event-based collection is triggered when a posture attribute of interest is added, removed, or modified on an endpoint.  This modification indicates a change in the current state of the endpoint, potentially affecting its adherence to some defined policy.  Modification of the endpoint's minimum password length is an example of an attribute change which could trigger collection.

External event-based collection can be described as a collector being subscribed to an external source of information, receiving events from that external source on a periodic or continuous basis.  An example of event-based collection is subscription to YANG Push notifications.

#### Endpoint
Building upon {{-sacmt}}, the SACM Collection Sub-Architecture augments the definition of an Endpoint as a component within an organization's management domain from which a Posture Collection Service will collect relevant posture attributes.

#### Posture Attribute Repository
The Posture Attribute Repository is a SACM component responsible for the persistent storage of posture attributes collected via interactions between the Posture Collection Service and Endpoints.

#### Posture Collection Workflow
Posture collection may be triggered from a number of components, but commonly begin either via event-based triggering on an endpoint or through manual orchestration, both illustrated in {{fig-collection}} above.  Once orchestration has provided the directive to perform collection, posture collection services consume the directives.  Posture collection is invoked for those endpoints overseen by the respective posture collection services.  Collected data is then provided to the Integration Service, with a directive to store that information in an appropriate repository.

### Evaluation Sub-Architecture
The Evaluation Sub-Architecture, in the SACM context, is the mechanism by which policy, expressed in the form of expected state, is compared with collected posture attributes to yield an evaluation result, that result being contextually dependent on the policy being evaluated.

~~~~~~~~~~
                     +------------------+
                     |    Collection    |    +-------------------------------+
                     | Sub-Architecture |    | Evaluation Results Repository |
+--------------+     +--------^---------+    +-----------------^-------------+
| Orchestrator |              |                                |
+------+-------+        (Potentially)                          |
       |                   Perform                 Store Evaluation Results
    Perform               Collection                           |
   Evaluation                 |                                |
       |                      |                                |
+------v----------------------v--------------------------------+-------------+
|                             Integration Service                            |
+--------^----------------------^-----------------------^--------------------+
         |                      |                       |
         |                      |                       |
         |               Retrieve Posture            Perform
  Retrieve Policy           Attributes              Evaluation
         |                      |                       |
         |                      |                       |
  +------v-----+          +-----v------+       +--------v-------------------+
  |   Policy   |          |  Posture   |       | Posture Evaluation Service |
  | Repository |          | Attribute  |       +----------------------------+
  +------------+          | Repository |
                          +------------+

~~~~~~~~~~
{: #fig-evaluation title="Decomposed Evaluation Sub-Architecture"}

#### Posture Evaluation Service
The Posture Evaluation Service (PES) represents the SACM component responsible for coordinating the policy to be evaluated and the collected posture attributes relevant to that policy, as well as the comparison engine responsible for correctly determining compliance with the expected state.

#### Policy Repository
The Policy Repository represents a persistent storage mechanism for the policy to be assessed against collected posture attributes to determine if an endpoint meets the desired expected state.  Examples of information contained in a Policy Repository would be Vulnerability Definition Data or configuration recommendations as part of a CIS Benchmark or DISA STIG.

#### Evaluation Results Repository
The Evaluation Results Repository persists the information representing the results of a particular posture assessment, indicating those posture attributes collected from various endpoints which either meet or do not meet the expected state defined by the assessed policy.  Consideration should be made for the context of individual results.  For example, meeting the expected state for a configuration attribute indicates a correct configuration of the endpoint, whereas meeting an expected state for a vulnerable software version indicates an incorrect configuration.

#### Posture Evaluation Workflow
Posture evaluation is orchestrated through the Integration Service to the appropriate Posture Evaluation Service (PES).  The PES will, using interactions defined by the applicable taxonomy, query both the Posture Attribute Repository and the Policy Repository to obtain relevant state data for comparison.  If necessary, the PES may be required to invoke further posture collection.  Once all relevant posture information has been collected, it is compared to expected state based on applicable policy.  Comparison results are then persisted to an evaluation results repository for further downstream use and analysis.

# Interactions
SACM Components are intended to interact with other SACM Components. These interactions can be thought of, at the architectural level, as the combination of interfaces with their supported operations.  Each interaction will convey a payload of information. The payload information is expected to contain sub-domain-specific characteristics and/or instructions.

## Interaction Categories
Two categories of interactions SHOULD be supported by the Integration Service; broadcast and directed.

### Broadcast
A broadcast interaction, commonly known as "publish/subscribe", allows for a wider distribution of a message payload.  When a payload is published to a topic on the Integration Service, all subscribers to that topic are alerted and may consume the message payload.  This category of interaction can also be described as a "unicast" interaction when a topic only has a single subscriber.  An example of a broadcast interaction could be to publish Linux OVAL objects to a posture collection topic.  Subscribing consumers receive the notification, and proceed to collect endpoint configuration posture based on the new content.

### Directed
The intent of a directed interaction is to enable point-to-point communications between a producer and consumer, through the standard interfaces provided by the Integration Service.  The provider component indicates which consumer is intended to receive the payload, and the Integration Service routes the payload directly to that consumer.  Two "styles" of directed interaction exist, differing only by the response from the payload consumer.

#### Synchronous
Synchronous, request/response style interaction requires that the requesting component block and wait for the receiving component to respond, or to time out when that response is delayed past a given time threshold.  A synchronous interaction example may be querying a CMDB for posture attribute information in order to perform an evaluation.

#### Asynchronous
An asynchronous interaction involves the payload producer directing the message to a consumer, but not blocking or waiting for an immediate response.  This style of interaction allows the producer to continue on to other activities without the need to wait for responses.  This style is particularly useful when the interaction payload invokes a potentially long-running task, such as data collection, report generation, or policy evaluation.  The receiving component may reply later via callbacks or further interactions, but it is not mandatory.

## Management Plane Functions
Mangement plane functions describe a component's interactions with the ecosystem itself, not necessarily relating to collection, evaluation, or downstream analytical processes.

### Orchestrator Onboarding
The Orchestrator component, being a specialized role in the architecture, onboards to the ecosystem in such a manner as to enable the onboarding and capabilities of the other component roles.  The Orchestrator must be enabled with the set of capabilities needed to manage the functions of the ecosystem.

With this in mind, the Orchestrator must first authenticate to the Integration Service.  Once authentication has succeeded, the Orchestrator must establish "service handlers" per the {{component-registration-taxonomy}}.  Once "service handlers" have been established, the Orchestrator is then equipped to handle component registration, onboarding, capability discovery, and topic subscription policy.

The following requirements exist for the Orchestrator to establish "service handlers" supporting the {{component-registration-taxonomy}}:
- The Orchestrator MUST enable the capability to receive onboarding requests via the `/orchestrator/registration` topic,
- The Orchestrator MUST have the capability to generate, manage, and persist unique identifiers for all registered components,
- The Orchestrator MUST have the capability to inventory and manage its "roster" (the list of registered components),
- The Orchestrator MUST support making directed requests to registered components over the component's administrative interface, as configured by the `/orchestrator/[component-unique-identifier]` topic.  Administrative interface functions are described by their taxonomy, below.

### Component Onboarding
Component onboarding describes how an individual component becomes part of the ecosystem; registering with the orchestrator, advertising capabilities, establishing its administrative interface, and subscribing to relevant topics.

The component onboarding workflow involves multiple steps:
- The component first authenticates to the Integration Service
- The component then initiates registration with the Orchestrator, per the {{component-registration-taxonomy}}

Once the component has onboarded and registered with the Orchestrator, its administrative interface will have been established via the `/orchestrator/[component-unique-identifier]` topic.  This administrative interface allows the component to advertise its capabilities to the Orchestrator and in return, allow the Orchestrator to direct capability-specific topic registration to the component.  This is performed using the {{capability-advertisement-handshake}} taxonomy.  Further described below, the "capability advertisement handshake" first assumes the onboarding component has the ability to describe its capabilities so they may be understood by the Orchestrator (TBD on capability advertisement methodology).

- The component sends a message with its operational capabilities over the administrative interface: `/orchestrator/[component-unique-identifier]`
- The Orchestrator receives the component's capabilities, persists them, and responds with the list of topics to which the component should subscribe, in order to receive notifications, instructions, or other directives intended to invoke the component's supported capabilities.
- The component subscribes to the topics provided by the Orchestrator


## Component Interactions
Component interactions describe functionality between components relating to collection, evaluation, or other downstream processes.

### Initiate Ad-Hoc Collection
The Orchestrator supplies a payload of collection instructions to a topic or set of topics to which Posture Collection Services are subscribed.  The receiving PCS components perform the required collection based on their capabilities.  The PCS then forms a payload of collected posture attributes (including endpoint identifying information) and publishes that payload to the topic(s) to which the Posture Attribute Repository is subscribed, for persistence.

### Coordinate Periodic Collection
Similar to ad-hoc collection, the Orchestrator supplies a payload of collection instructions containing additional information regarding collection periodicity, to the topic or topics to which Posture Collection Services are subscribed.

#### Schedule Periodic Collection
Collection instructions include information regarding the schedule for collection, for example, every day at Noon, or every hour at 32 minutes past the hour.

#### Cancel Periodic Collection
The Orchestrator supplies a payload of instructions to a topic or set of topics to which Posture Collection Services are subscribed.  The receiving PCS components cancel the identified periodic collection executing on that PCS.

### Coordinate Observational/Event-based Collection
In these scenarios, the "observer" acts as the Posture Collection Service.  Interactions with the observer could specify a time period of observation and potentially information intended to filter observed posture attributes to aid the PCS in determining those attributes that are applicable for collection and persistence to the Posture Attribute Repository.

#### Initiate Observational/Event-based Collection
The Orchestrator supplies a payload of instructions to a topic or set of topics to which Posture Collection Services (observers) are subscribed.  This payload could include specific instructions based on the observer's capabilities to determine specific posture attributes to observe and collect.

#### Cancel Observational/Event-based Collection
The Orchestrator supplies a payload of instructions to a topic or set of topics to which Posture Collection Services are subscribed.  The receiving PCS components cancel the identified observational/event-based collection executing on that PCS.

### Persist Collected Posture Attributes
[TBD] Normalization?

### Initiate Ad-Hoc Evaluation
[TBD]

### Coordinate Periodic Evaluation
[TBD]

#### Schedule
[TBD]

#### Cancel
[TBD]

### Coordinate Change-based Evaluation
[TBD] i.e. if a posture attribute in the repository is changed, trigger an evaluation of particular policy items

### Queries
[TBD] Queries should allow for a "freshness" time period, allowing the requesting entity to determine if/when posture attributes must be re-collected prior to performing evaluation.  This freshness time period can be "zeroed out" for the purpose of automatically triggering re-collection regardless of the most recent collection.

# Taxonomy

## Orchestrator Registration
{: #orchestrator-registration-taxonomy title="Orchestrator Registration"}
The Orchestrator Registration taxonomy describes how an Orchestrator onboards to the ecosystem, or how it returns from a non-operational state.

### Topic
N/A

### Interaction Type
Directed (Request/Response)

### Initiator
Orchestrator

### Request Payload
N/A

### Receiver
N/A

### Process Description
Once the Orchestrator has authenticated to the Integration Service, it must establish (or re-establish) any service handlers interacting with administrative interfaces and/or general operational interfaces.

For initial registration, the Orchestrator MUST enable capabilities to:

- Receive onboarding requests via the `/orchestrator/registration` topic,
- Generate, manage, and persist unique identifiers for all registered components,
- Inventory and manage its "roster" (the list of registered components), and
- Support making directed requests to registered components over the component's administrative interface, as configured by the `/orchestrator/[component-unique-identifier]` topic.

Administrative interfaces are to be re-established through the inventory of previously registered components, such as Posture Collection Services, Repositories, or Posture Evaluation Services.

### Response Payload
N/A

### Response Processing
N/A


## Component Registration
{: #component-registration-taxonomy title="Component Registration"}
Component onboarding describes how an individual component becomes part of the ecosystem; registering with the orchestrator, advertising capabilities, establishing its administrative interface, and subscribing to relevant topics.

### Topic
`/orchestrator/registration`

### Interaction Type
Directed (Request/Response)

### Initiator
Any component wishing to join the ecosystem, such as Posture Collection Services, Repositories (policy, collection content, posture attribute, etc), Posture Evaluation Services and more.

### Request Payload
[TBD] Information Elements, such as

- identifying-information
	- component-type (i.e Posture Collection Service, Posture Evaluation Service, Repository, etc.)
	- name
	- description

### Receiver
Orchestrator

### Process Description
When the Orchestrator receives the component's request for onboarding, it will:

- Generate a unique identifier, `[component-unique-identifier]`, for the onboarding component,
- Persist required information (TBD probably need more specifics), including the `[component-unique-identifier]` to its component inventory, enabling an up-to-date roster of components being orchestrated,
- Establish the administrative interface via the `/orchestrator/[component-unique-identifier]` topic.

### Response Payload
[TBD] Information Elements

- component-unique-identifier

### Response Processing
Successful receipt of the Orchestrator's response, including the `[component-unique-identifier]` indicates the component is onboarded to the ecosystem.  Using the response payload, the component can then establish its end of the administrative interface with the Orchestrator, using the `/orchestrator/[component-unique-identifier]` topic.  Given this administrative interface, the component can then initiate the {{capability-advertisement-handshake}}


## Orchestrator-to-Component Administrative Interface
{: #orchestrator-component-direct-taxonomy title="Orchestrator-to-Component Administrative Interface"}
A number of functions may take place which, instead of being published to a multi-subscriber topic, may require direct interaction between an Orchestrator and a registered component.  During component onboarding, this direct channel is established first by the Orchestrator and subsequently complemented by the onboarding component.

### Capability Advertisement Handshake
Capability advertisement, otherwise known as service discovery, is necessary to establish and maintain a cooperative ecosystem of tools.  Using this capability advertisement "handshake", the Orchestrator becomes knowledgeable of a component's operational capabilities, the endpoints/services with which the component interacts, and establishes a direct mode of contact for invoking those capabilities.

#### Topic
`/orchestrator/[component-unique-identifier]`

#### Interaction Type
Directed (Request/Response)

#### Initiator
Any ecosystem component (minus the Orchestrator)

#### Request Payload
[TBD] Information Elements

- component-type
- component-unique-identifier
- interaction-type (capability-advertisement):
	- list of capabilities
	- list of endpoints/services

#### Receiver
Orchestrator

#### Process Description
Upon receipt of the component's capability advertisement, it SHOULD:
- Persist the component's capabilities to the Orchestrator's inventory
- Coordinate, based on the supplied capabilities, a list of topics to which the component should subscribe

#### Response Payload
[TBD] Information Elements

- a list of topics to which the receiver should subscribe

#### Response Processing
Once the component has received the response to its capability advertisement, it should subscribe to the Orchestrator-provided topics.

### Directed Collection

### Directed Evaluation

### Heartbeat

## [Taxonomy Name]
DESCRIPTION OF TAXONOMY

### Topic
`/name/of/topic`

### Interaction Type
[Directed (Request/Response) -or- Publish/Subscribe]

### Initiator
[Component sending/publishing the payload]

### Request Payload
DESCRIPTION OF INFORMATION MODEL OF REQUEST PAYLOAD; i.e. what elements need to be in whatever format in the payload.

### Receiver
[Component receiving/subscribed-to the payload]

### Process Description
[What the receiver does with the payload]

### Response Payload
DESCRIPTION OF INFORMATION MODEL OF RESPONSE PAYLOAD; i.e. what elements need to be in whatever format in the payload.

### Response Processing
[What the initiator does with any response, if there is one]

# Privacy Considerations
[TBD]

# Security Considerations
[TBD]

# IANA Considerations
[TBD] Revamp this section after the configuration assessment workflow is fleshed out.

IANA tables can probably be used to make life a little easier. We would like a place to enumerate:

* Capability/operation semantics
* SACM Component implementation identifiers
* SACM Component versions
* Associations of SACM Components (and versions) to specific Capabilities
* Collection sub-architecture Identification


--- back


# Security Domain Workflows
This section describes three primary information security domains from which workflows may be derived: IT Asset Management, Vulnerability Management, and Configuration Management.

## IT Asset Management
Information Technology asset management is easier said than done. The {{CISCONTROLS}} have two controls dealing with IT asset management. Control 1, Inventory and Control of Hardware Assets, states, "Actively manage (inventory, track, and correct) all hardware devices on the network so that only authorized devices are given access, and unauthorized and unmanaged devices are found and prevented from gaining access." Control 2, Inventory and Control of Software Assets, states, "Actively manage (inventory, track, and correct) all software on the network so that only authorized software is installed and can execute, and that unauthorized and unmanaged software is found and prevented from installation or execution."

In spirit, this covers all of the processing entities on your network (as opposed to things like network cables, dongles, adapters, etc.), whether physical or virtual, on-premises or in the cloud.


### Components, Capabilities and Workflow(s)
TBD

#### Components
TBD

#### Capabilities
An IT asset management capability needs to be able to:

- Identify and catalog new assets by executing Target Endpoint Discovery Tasks
- Provide information about its managed assets, including uniquely identifying information (for that enterprise)
- Handle software and/or hardware (including virtual assets)
- Represent cloud hybrid environments

#### Workflow(s)
TBD

## Vulnerability Management
Vulnerability management is a relatively established process. To paraphrase the {{CISCONTROLS}}, continuous vulnerability management is the act of continuously acquiring, assessing, and taking subsequent action on new information in order to identify and remediate vulnerabilities, therefore minimizing the window of opportunity for attackers.

A vulnerability assessment (i.e. vulnerability detection) is performed in two steps:

* Endpoint information collected by the endpoint management capabilities is examined by the vulnerability management capabilities through Evaluation Tasks.
* If the data possessed by the endpoint management capabilities is insufficient, a Collection Task is triggered and the necessary data is collected from the target endpoint.

Vulnerability detection relies on the examination of different endpoint information depending on the nature of a specific vulnerability. Common endpoint information used to detect a vulnerability includes:

* A specific software version is installed on the endpoint
* File system attributes
* Specific state attributes

In some cases, the endpoint information needed to determine an endpoint's vulnerability status will have been previously collected by the endpoint management capabilities and available in a Repository. However, in other cases, the necessary endpoint information will not be readily available in a Repository and a Collection Task will be triggered to perform collection from the target endpoint. Of course, some implementations of endpoint management capabilities may prefer to enable operators to perform this collection even when sufficient information can be provided by the endpoint management capabilities (e.g. there may be freshness requirements for information).

### Components, Capabilities and Workflow(s)
TBD

#### Components
TBD

#### Capabilities
TBD

#### Workflow(s)
TBD

## Configuration Management
Configuration management involves configuration assessment, which requires state assessment. The {{CISCONTROLS}} specify two high-level controls concerning configuration management (Control 5 for non-network devices and Control 11 for network devices). As an aside, these controls are listed separately because many enterprises have different organizations for managing network infrastructure and workload endpoints. Merging the two controls results in the following paraphrasing: Establish, implement, and actively manage (track, report on, correct) the security configuration of systems using a rigorous configuration management and change control process in order to prevent attackers from exploiting vulnerable services and settings.

Typically, an enterprise will use configuration guidance from a reputable source, and from time to time they may tailor the guidance from that source prior to adopting it as part of their enterprise standard. The enterprise standard is then provided to the appropriate configuration assessment tools and they assess endpoints and/or appropriate endpoint information.

A preferred flow follows:

- Reputable source publishes new or updated configuration guidance
- Enterprise configuration assessment capability retrieves configuration guidance from reputable source
- Optional: Configuration guidance is tailored for enterprise-specific needs
- Configuration assessment tool queries asset inventory repository to retrieve a list of affected endpoints
- Configuration assessment tool queries configuration state repository to evaluate compliance
- If information is stale or unavailable, configuration assessment tool triggers an ad hoc assessment

The SACM architecture needs to support varying deployment models to accommodate the current state of the industry, but should strongly encourage event-driven approaches to monitoring configuration.

### Components, Capabilities and Workflow(s)
This section provides more detail about the components and capabilities required when considering the aforementioned configuration management workflow.

#### Components
The following is a minimal list of SACM Components required to implement the aforementioned configuration assessment workflow.

* Configuration Policy Feed: An external source of authoritative configuration recommendations.
* Configuration Policy Repository: An internal repository of enterprise standard configurations.
* Configuration Assessment Orchestrator: A component responsible for orchestrating assessments.
* Posture Attribute Collection Subsystem: A component responsible for collection of posture attributes from systems.
* Posture Attribute Repository: A component used for storing system posture attribute values.
* Configuration Assessment Evaluator: A component responsible for evaluating system posture attribute values against expected posture attribute values.
* Configuration Assessment Results Repository: A component used for storing evaluation results.

#### Capabilities
Per {{RFC8248}}, solutions MUST support capability negotiation. Components implementing specific interfaces and operations (i.e. interactions) will need a method of describing their capabilities to other components participating in the ecosystem; for example, "As a component in the ecosystem, I can assess the configuration of Windows, MacOS, and AWS using OVAL".

#### Configuration Assessment Workflow
This section describes the components and interactions in a basic configuration assessment workflow. For simplicity, error conditions are recognized as being necessary and are not depicted. When one component messages another component, the message is expected to be handled appropriately unless there is an error condition, or other notification, messaged in return.

~~~~~~~~~~
+-------------+  +----------------+  +------------------+  +------------+
| Policy Feed |  |  Orchestrator  |  |    Evaluation    |  | Evaluation |
+------+------+  +-------+--------+  | Sub-Architecture |  |   Results  |
       |                 |           +---^----------+---+  | Repository |
       |                 |               |          |      +------^-----+
       |                 |               |          |             |
     1.|               3.|             8.|        9.|          10.|
       |                 |               |          |             |
       |                 |               |          |             |
+------v-----------------v---------------+----------v-------------+-----+
|                           Integration Service                         |
+-----+----------------------------------+----------^---------+------^--+
      |                                  |          |         |      |
      |                                  |          |         |      |
    2.|                                4.|        5.|       6.|    7.|
      |                                  |          |         |      |
      |                                  |          |         |      |
+-----v------+                       +---v----------+---+  +--v------+--+
|   Policy   |                       |    Collection    |  |  Posture   |
| Repository |                       | Sub-Architecture |  | Attribute  |
+------------+                       +------------------+  | Repository |
                                                           +------------+
~~~~~~~~~~
{: #fig-configassess title="Configuration Assessment Component Interactions"}

{{fig-configassess}} depicts configuration assessment components and their interactions, which are further described below.

1. A policy feed provides a configuration assessment policy payload to the Integration Service.
2. The Policy Repository, a consumer of Policy Feed information, receives and persists the Policy Feed's payload.
3. Orchestration component(s), either manually invoked, scheduled, or event-based, publish a payload to begin the configuration assessment process.
4. If necessary, Collection Sub-Architecture components may be invoked to collect neeeded posture attribute information.
5. If necessary, the Collection Sub-Architecture will provide collected posture attributes to the Integration Service for persistence to the Posture Attribute Repository.
6. The Posture Attribute Repository will consume a payload querying for relevant posture attribute information.
7. The Posture Attribute Repository will provide the requested information to the Integration Service, allowing further orchestration payloads requesting the Evaluation Sub-Architecture perform evaluation tasks.
8. The Evaluation Sub-Architecture consumes the evaluation payload and performs component-specific state comparison operations to produce evaluation results.
9. A payload containing evaluation results are provided by the Evaluation Sub-Architecture to the Integration Service
10. Evaluation results are consumed by/persisted to the Evaluation Results Repository

In the above flow, the payload information is expected to convey the context required by the receiving component for the action being taken under different circumstances. For example, a directed message sent from an Orchestrator to a Collection sub-architecture might be telling that Collector to watch a specific posture attribute and report only specific detected changes to the Posture Attribute Repository, or it might be telling the Collector to gather that posture attribute immediately. Such details are expected to be handled as part of that payload, not as part of the architecture described herein.
