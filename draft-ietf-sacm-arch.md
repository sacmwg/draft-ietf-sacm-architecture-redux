---
title: Security Automation and Continuous Monitoring (SACM) Architecture
abbrev: SACM Architecture
docname: draft-ietf-sacm-arch-10
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
  RFC6120: XMPP

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
    title: CIS Controls v7.1
  MQTT:
    target: https://mqtt.org/mqtt-specification/
    title: MQTT
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
The generic approach proposed herein recognizes the need to obtain information from existing and future state collection systems, and makes every attempt to respect {{RFC7632}} and {{RFC8248}}. At the foundation of any architecture are entities, or components, that need to communicate. They communicate by sharing information, where, in a given flow, one or more components are consumers of information and one or more components are providers of information.  Different roles within a cooperative ecosystem may act as both Producers and Consumers of SACM-relevant information.

~~~~~~~~~~
       +----------------+
       | SACM Component |
       |   (Producer)   |
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


## Producer
A Producer can be described as an abstraction that refers to an entity capable of sending SACM-relevant information to one or many Consumers.  In general, information (a "payload") is produced to a particular topic, subscribed to by one or more Consumers.  Producers need not be concerned about any specifics of the payload it is providing to a given topic.  A Producer may, for example, publish posture collection instructions to collector topics.

## Consumer
A Consumer can be described as an abstraction that refers to an entity capable of receiving SACM-relevant information from one or many Producers.  A Consumer acts as a subscriber to a given topic (or set of topics), enabling it to receive event notifications when a Producer provides a payload to that topic or topics.  Consumers receive payloads and act upon them according to their capabilities.  A Consumer may, for example, subscribe to a posture collection topic to receive and act upon, collection instructions.

## Integration Service
The Integration Service acts as the broker between Producers and Consumers; acting as the destination for Producers to publish payloads, and as the source for Consumers subscribing to those payloads.

SACM Components are intended to interact with other SACM Components. These interactions can be thought of, at the architectural level, as the combination of interfaces with their supported operations.  Each interaction will convey a classified payload of information. This classification of payload information allows Consumers to subscribe to only the classifications to which they are capable of handling.  The payload information should contain subdomain-specific characteristics and/or instructions.

## Payload/Message
The payload (sometimes referred to as a "message" or "message payload") is the unit of data involved in any given interaction between two SACM components.  The payload MAY be used to convey the semantic meaning of the operation to be performed.  Protocols such as {{RFC6120}} achieves this meaning through XML namespace identification within a `<message/>` or `<iq/>` stanza.  Topic-centric protocols such as {{MQTT}} convey the meaning of payloads through topic naming techniques.  Both methods require connected components to verify message payloads according to their respective capabilities.

With respect to the Integration Service, the payload is simply an array of bytes, so the data contained within it is not required to convey a specific format or meaning to the Integration Service.  The serialization of the payload combined with the payload categorization provides meaning within the SACM context.

## Payload Categorization
Within the SACM ecosystem, categorization of payloads and their transport provide the context through which various capabilities are achieved.  Two types of payload categorization can be described.

### Topic-centric
Topic-centric payload categorization allows for a broad spectrum of payloads by characterizing those payloads through the Integration Service topic.  In this categorization, the topic name becomes a label attached to the payload to which the Integration Service matches against known subscriptions.  The topic becomes the operational context for the payload.  Topic-centric categorization allows for any payload to be sent to any topic, but requires that SACM consumers parse the payloads to determine whether or not they have the capability to act on those payloads.

When interacting using a topic-centric payload categorization, topic naming conventions SHOULD provide an adequate amount of information to be deterministic regarding the purpose of the interaction.  For example, a topic named `/notification/collection/oval` would indicate that (a) the topic is a broadcast/notification (publish/subscribe) topic, (b) subscribers to this topic are performing a "collection" action, and (c) the payloads published to the topic are represented using the OVAL serialization format.

### Payload-centric
Payload-centric categorization encapsulates the intent of an interaction within the message payload itself, using an identifying token, tag, or namespace identifier.  This method allows for the limitation of message types, and therefore increases the extensibility of message payloads.

Payload-centric categorization allows for modularization and specification of extensions, and for plugin-based support of capabilities based the categorization.  {{XMPP}} is an example of utilization of payload-centric categorization, allowing only three distinct "stanzas" (`<message/>`, `<presence/>`, and `<iq/>`), using payloads defined by the various extension protocols maintained by the XMPP standards foundation.

## Capabilities
SACM components interact with each other based on their capacity to perform specific actions.  In advertising its capabilities, a SACM component indicates its competence to understand message payloads, perform any payload translation or normalization, and act upon that message.  For example, an Orchestration component receives a message to initiate posture attribute collection.  The Orchestrator may then normalize those instructions to a particular collection system's serialization.  The normalized instructions are then published to the Integration Service, notifying the appropriate subscribers.

Capabilities are described using Uniform Resource Names (URNs), which will be maintained and enhanced via IANA tables ({{iana-considerations}}).  Capability URNs SHOULD be associated with Integration Service topics to which publishers, subscribers, and service handlers, will interact.  Topic naming conventions are considered implementation details and are not considered for standardization.

## Interaction Categories
Two categories of interactions SHOULD be supported by the Integration Service: broadcast and directed.  Broadcast interactions are asynchronous by default, and directed interactions may be invoked either synchronously or asynchronously.

### Broadcast
A broadcast interaction, commonly referred to as publish/subscribe, allows for a wider distribution of a message payload.  When a payload is published to the Integration Service, all subscribers to that payload are alerted and may consume the message payload.  This category of interaction can also be described as a "unicast" interaction when only a single subscriber exists.  An example of a broadcast interaction could be to publish Linux OVAL objects to a posture collection topic.  Subscribing consumers receive the notification, and proceed to collect endpoint configuration posture based on the supplied message payload.

### Directed
The intent of a directed interaction is to enable point-to-point communications between a producer and consumer, through the standard interfaces provided by the Integration Service.  The provider component indicates which consumer is intended to receive the payload, and the Integration Service routes the payload directly to that consumer.  Two "styles" of directed interaction exist, differing only by the response from the payload consumer.  

#### Synchronous
Synchronous, request/response style interaction requires that the requesting component block and wait for the receiving component to respond, or to time out when that response is delayed past a given time threshold.  A synchronous interaction example may be querying a CMDB for posture attribute information in order to perform an evaluation.

#### Asynchronous
An asynchronous interaction involves the payload producer directing the message to a consumer, but not blocking or waiting for an immediate response.  This style of interaction allows the producer to continue on to other activities without the need to wait for responses.  This style is particularly useful when the interaction payload invokes a potentially long-running task, such as data collection, report generation, or policy evaluation.  The receiving component may reply later via callbacks or further interactions, but it is not mandatory.

# SACM Role-based Architecture
Within the cooperative SACM ecosystem, a number of roles act in coordination to provide relevant policy/guidance, perform data collection, storage, evaluation, and support downstream analytics and reporting.

~~~~~~~~~~
  +-------------------------------------------+
  |                 Manager                   |
  +-------------------^-----------------------+
                      |
  +-----------------+ |  +--------------------+
  | Orchestrator(s) | |  | Repositories/CMDBs |
  +---------+-------+ |  +----------+---------+
            |         |             |                +--------------------+
            |         |             |                |  Downstream Uses   |
            |         |             |                | +----------------+ |
  +---------v---------v-------------v---------+      | |   Analytics    | |
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

### Manager
The Manager acts as the control plane for the SACM ecosystem; a sort of high level component capable of coordinating the actions, notifications, and events between components.  The manager controls the administrative interfaces with the various components of the ecosystem, acting as the central point to which all other components will register and advertise their capabilities.  It is the responsibility of the manager to control a component’s access to the ecosystem, maintain an inventory of components attached to the ecosystem, and to initiate the various workflows involved in the collection and/or evaluation of posture attributes.

The manager should maintain the master set of capabilities that can be supported within the ecosystem.  These are the various collection, evaluation, and persistence capabilities with which components may register.  The manager MAY be responsible for assigning topics for each of the capabilities that are supported, as registering components subsequently subscribe to, or configure service handlers for, those topics.

The manager may act as the user interface to the ecosystem, providing user dashboards, inventories, component management, or operational controls within the boundary of responsibility.

### Orchestrator(s)
Orchestration components provide the manager with resources for delegating work across the SACM ecosystem.  Orchestrators are responsible for receiving messages from the manager, e.g. posture attribute collection instructions, and routing those messages to the appropriate “actions”.  For example, an orchestrator may support the capability of translating posture collection instructions using the Open Vulnerability and Assessment Language (OVAL) and providing those instructions to OVAL collectors.  An orchestrator may support the capability of initiating policy evaluation.  Where the Manager is configured to ask a particular set of questions, those questions are delegated to Orchestrators, who are then capable of asking those questions using specific dialects.

### Repositories/Configuration Management Databases (CMDBs)
{{fig-notional}} only includes a single reference to "Repositories/CMDBs", but in practice, a number of separate data repositories may exist, including posture attribute repositories, policy repositories, local vulnerability definition data repositories, and state assessment results repositories.  These data repositories may exist separately or together in a single representation, and the design of these repositories may be as distinct as their intended purpose, such as the use of relational database management systems (RDBMS) or graph/map implementations focused on the relationships between data elements.  Each implementation of a SACM repository should focus on the relationships between data elements and implement the SACM information and data model(s).

### Integration Service
If each SACM component represents a set of capabilities, then the Integration Service represents the "fabric" by which SACM components are woven together.  The Integration Service acts as a message broker, combining a set of common message categories and infrastructure to allow SACM components to communicate using a shared set of interfaces.  The Integration Service's brokering capabilities enable the exchange of various information payloads, orchestration of component capabilities, message routing and reliable delivery.  The Integration Service minimizes the dependencies from one system to another through the loose coupling of applications through messaging.  SACM components will "attach" to the Integration Service either through native support for the integration implementation, or through the use of "adapters" which provide a proxied attachment.

The Integration Service should provide mechanisms for both synchronous and asynchronous request/response-style messaging, and a publish/subscribe mechanism to implement an event-based architecture.  It is the responsibility of the Integration Service to coordinate and manage the sending and receiving of messages.  The Integration Service should allow components to directly connect and produce or consume messages, or connect via message translators which can act as a proxy, transforming messages from a component format to one implementing a SACM data model.

The Integration Service MUST provide routing capabilities for payloads between producers and consumers.  The Integration Service MAY provide further capabilities within the payload delivery pipeline.  Examples of these capabilities include, but are not limited to, intermediate processing, message transformation, type conversion, validation, or other enterprise integration patterns.

## Downstream Uses
As depicted by {{fig-notional}}, a number of downstream uses exist in the cooperative ecosystem.  Each notional SACM component represents distinct sub-architectures which will exchange information via the integration services, using interactions described in this draft.

### Reporting
The Reporting component represents capabilities outside of the SACM architecture scope dealing with the query and retrieval of collected posture attribute information, evaluation results, etc. in various display formats that are useful to a wide range of stakeholders.

### Analytics
The Analytics component represents capabilities outside of the SACM architecture scope dealing with the discovery, interpretation, and communication of any meaningful patterns of data in order to inform effective decision making within the organization.

## Sub-Architectures
{{fig-notional}} shows two components representing sub-architectural roles involved in a cooperative ecosystem of SACM components for the purpose of posture assessment: Collection and Evaluation.

### Collection Sub-Architecture
The Collection sub-architecture is, in a SACM context, the mechanism by which posture attributes are collected from applicable endpoints and persisted to a repository, such as a configuration management database (CMDB).  Control plane functions initiated by the Manager will coordinate the necessary orchestration components, who will choreograph endpoint data collection via defined interactions, using the Integration Service as a message broker.  Instructions to perform endpoint data collection are directed to a Posture Collection Service capable of performing collection activities utilizing any number of protocols, such as SNMP, NETCONF/RESTCONF, SCAP, SSH, WinRM, packet capture, or host-based.  Instructions are orchestrated with the appropriate Posture Collection Services using serializations supported according to the collector's capabilities.

~~~~~~~~~~
  +----------------------------------------------------------+
  |                       Manager                            |
  +-----------+----------------------------------------------+
              |
          Orchestrate
          Collection
              |
  +-----------v-------------+ +------------------------------+
  |      Orchestrator(s)    | | Posture Attribute Repository |
  +-----------+-------------+ +--------------^---------------+
              |                              |
           Perform                           |
          Collection                  Collected Data
              |                              ^
              |                              |
  +-----------v------------------------------+---------------+
  |                    Integration Service                   |
  +----+------------------^------------------------------^---+
       |                  |           |                  |
       v                  +           v                  |
    Perform           Collected    Perform           Collected
   Collection           Data      Collection           Data
       |                  ^           |                  ^
       |                  |           |                  |
  +----v-----------------------+ +------------------------------+
  | Posture Collection Service | |    |     Endpoint     |      |
  +---^------------------------+ | +--v------------------+----+ |
      |                   |      | |Posture Collection Service| |
      |                   |      | +--------------------------+ |
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
The Posture Collection Service (PCS) is a SACM component responsible for the collection of posture attributes from an endpoint or set of endpoints.  A single PCS MAY be responsible for management of posture attribute collection from many endpoints.  The PCS will interact with the Integration Service to receive collection instructions, and to provide collected posture attributes for persistence to one or more Posture Attribute Repositories.  Collection instructions may be supplied in a variety of forms, including subscription to a publish/subscribe topic to which the Integration Service has published instructions, or via request/response-style messaging (either synchronous or asynchronous).

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
|     Manager      |
+-------+----------+
        |
   Orchestrate        +------------------+
    Evaluation        |    Collection    |    +-------------------------------+
        |             | Sub+Architecture |    | Evaluation Results Repository |
 +------v----------+  +--------^---------+    +-----------------^-------------+
 | Orchestrator(s) |           |                                |
 +------+----------+     (Potentially)                          |
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


# Ecosystem Interactions
{: #ecosystem-interactions title="Ecosystem Interactions"}
Ecosystem interactions describe the various functions between SACM components, including manager requirements, the onboarding of components, capability advertisement, administrative actions, and status updates, among others.  The Manager component acts as the administrative "lead" for the SACM ecosystem, and must maintain records of registered components, manage capabilities, and more.

## Manager
The Manager, being a specialized role in the architecture, enables the onboarding and capability management of the various SACM component roles.  The Manager must support the set of capabilities needed to operate the SACM ecosystem.

With this in mind, the Manager must first authenticate to the Integration Service.  Once authentication has succeeded, the Manager MUST establish a service handler capable of performing SACM component registration/onboarding activities ({{component-registration-op}}).  The Manager MUST also establish a subscription to an ecosystem-wide status notification mechanism,  in order to receive published status updates from other SACM components.

The following requirements exist for the Manager to establish service handlers supporting the component registration taxonomy ({{component-registration-op}}):

- The Manager MUST enable the capability to receive onboarding requests,
- The Manager MUST have the capability to generate, manage, and persist unique identifiers for all registered components,
- The Manager MUST maintain the relationships between capabilities and payload categorizations (such as topic names or specific payload identifiers), 
- The Manager MUST have the capability to inventory and manage its "roster" (the list of registered components),
- The Manager MUST have the capability to manage its roster's advertised capabilities, including those endpoints to which those capabilities apply.
- In addition to supporting component registration, the Manager is responsible for many of the operational functions of the architecture, including initiating collection or evaluation, queries for repository data, or the assembly of information for downstream use.
- The Manager MUST support making directed requests to registered components over the component's administrative interface.  Administrative interface functions are described by their taxonomy, below.
- The Manager MUST support each of the interaction categories as described above.

## Component Registration
Component registration describes how an individual component becomes part of the SACM ecosystem; authenticating to the Integration Service, registering and establishing its administrative interface with, the Manager.

The component onboarding workflow involves multiple steps:

- The component first authenticates to the Integration Service.
- The component initiates registration with the Manager, per the component registration operation ({{component-registration-op}}).
- The component handles the response from the Manager to configure a service handler allowing the component to receive directed messages over the  administrative interface with the Manager.

## Administrative Interface
The administrative interface represents a direct communication channel between the Manager and any registered Component.  This interface allows the Manager to make directed requests to a component in order to perform specific actions.

### Capability Advertisement Handshake
Capability Advertisement is the mechanism by which components initially indicate their capabilities to the Manager. This handshake is completed using the administrative interface with the Manager.  It becomes the Manager's responsibility to persist component/capability relationships, and to provide the component the information necessary to receive and process message payloads specific to the supported capabilities.

### Health Check
The administrative "health check" is a mechanism by which the Manager queries for the "liveness" of its roster of components, and to possibly alert users or other systems when components are no longer present.  The Manager MAY enable a periodic message to each component to determine if that component is still listening to the Administrative Interface. The Health Check interaction MAY include a request for "Capability Refresh", to reinitiate the Capability Advertisement Handshake. This interaction is similar to the "Heartbeat" interaction, but is initiated by the Manager.

#### Capability Refresh
As part of the Health Check interaction, the Manager MAY periodically request an up-to-date list of the Component's capabilities.  When a Component receives a Health Check request including a capability refresh, the Component SHOULD respond with a Capability Advertisement payload for the Manager to process and update in it's roster.

### Heartbeat
The administrative “heartbeat” is a mechanism by which a Component indicates to the Manager that the Component remains connected to the ecosystem. The Heartbeat differs from the Health Check interaction in that the Component initiates the interaction, and that no response from the Manager is required.

### Capability-specific Requests
Any number of capability-specific requests can be enabled through the administrative interface that allow the Manager to direct actions to be performed by a specific component.  Utilizing the interface from a component to the Manager, this interface can be used to indicate a component has come back online, or to provide an updated capability advertisement, potentially resulting in updates to subscriptions or service handlers.

## Status Notifications
A generic status notifications mechanism SHOULD be configured to which (a) the Manager is subscribed, and (b) all onboarded components can publish.  Status notifications may be used by the Manager to update user interfaces, to provide notification of the start, finish, success or failure of ecosystem operations, or as events to trigger subsequent activities.

## Component Interactions
Component interactions describe functionality between components relating to collection, evaluation, or other downstream processes.  The following component interactions begin with the Manager providing a set of instructions to an Orchestrator or set of Orchestrators that have registered with the SACM ecosystem indicating the appropriate capabilities, such as collection or evaluation.  Subscribing Orchestrator(s) MAY translate, manipulate, filter, augment, or otherwise transform the Manager's instructions into content supported through the Orchestrator's capabilities.

### Initiate Ad-Hoc Collection
The Orchestrator supplies a payload of collection instructions to a Posture Collection Service either through direct or broadcast mechanisms.  The receiving PCS components perform the required collection based on their capabilities.  Each PCS then forms a payload of collected posture attributes (including endpoint identifying information) and provides that payload to the Posture Attribute Repository interface, for persistence.

### Coordinate Periodic Collection
Similar to ad-hoc collection, the Orchestrator supplies a payload of collection instructions similar to those of ad-hoc collection.  Additional information elements containing collection identification and periodicity are included.

#### Schedule Periodic Collection
To enable operations on periodic collection, the scheduling payload MUST include both a unique identifier for the set of collection instructions, as well as a periodicity expression to enable the collection schedule.  An optional "immediate collection" flag will indicate to the collection component that, upon receipt of the collection instructions, a collection will automatically be initiated prior to engagement of the scheduled collection.

#### Cancel Periodic Collection
The Orchestrator disables the periodic collection of posture attributes by supplying collector(s) the unique identifier of previously scheduled collection instructions.  An optional "final collection" flag will indicate to the collection component that, upon receipt of the cancellation instructions, a final ad-hoc collection is to take place.

### Coordinate Observational/Event-based Collection
In these scenarios, the Posture Collection Service acts as the "observer".  Interactions with the observer could specify a time period of observation and potentially information intended to filter observed posture attributes to aid the PCS in determining those attributes that are applicable for collection and persistence to the Posture Attribute Repository.

#### Initiate Observational/Event-based Collection
The Orchestrator supplies a payload of instructions to a topic or set of topics to which Posture Collection Services (observers) are subscribed.  This payload could include specific instructions based on the observer's capabilities to determine specific posture attributes to observe and collect.

#### Cancel Observational/Event-based Collection
The Orchestrator supplies a payload of instructions to a topic or set of topics to which Posture Collection Services are subscribed.  The receiving PCS components cancel the identified observational/event-based collection executing on those PCS components.

### Persist Collected Posture Attributes
Following successful collection, Posture Collection Services (PCS) will supply the payload of collected posture attributes to the interface(s) supporting the persistent storage of those attributes to the Posture Attribute Repository.  Information in this payload should include identifying information of the computing resource(s) for which attributes were collected.

### Initiate Ad-Hoc Evaluation
The Orchestrator supplies a payload of evaluation instructions to a Posture Evaluation Services (PES) either through direct or broadcast mechanisms.  The receiving PES components perform the required evaluation based on their capabilities.  The PES generates a payload of posture evaluation results and publishes that payload to the Evaluation Results Repository interface, for persistence.

### Coordinate Periodic Evaluation
Similar to ad-hoc evaluation, the Orchestrator supplies a payload of evaluation instructions similar to those of ad-hoc evaluation.  Additional information elements containing evaluation identification and periodicity are included.

#### Schedule Periodic Evaluation
To enable operations on periodic evaluation, the scheduling payload MUST include both a unique identifier for the set of evaluation instructions, as well as a periodicity expression to enable the evaluation schedule.  An optional "immediate evaluation" flag will indicate to the Posture Evaluation Service (PES) that, upon receipt of the evaluation instructions, an evaluation will automatically be initiated prior to engagement of the scheduled evaluation.

#### Cancel Periodic Evaluation
The Orchestrator disables the periodic evaluation of posture attributes by supplying Posture Evaluation Service(s) the unique identifier of previously scheduled evaluation instructions.  An optional "final evaluation" flag will indicate to the PES that, upon receipt of the cancellation instructions, a final ad-hoc evaluation is to take place.

### Coordinate Change-based Evaluation
A more fine-grained approach to periodic evaluation may be enabled through the triggering of Posture Evaluation based on changes to posture attribute values at the time of their collection and persistence to the Posture Attribute Repository.

#### Identify Attributes
The Orchestrator enables change-based evaluation through a payload published to Posture Attribute Repository component(s).  This payload includes appropriate information elements describing the posture attributes on which changes in value will trigger posture evaluation.

#### Cancel Change-based Evaluation
An Orchestrator may disable change-based evaluation through a payload published to Posture Attribute Repository component(s), including those information elements necessary to identify those posture attributes for which change-based evaluation no longer applies.

### Queries
Queries should allow for a "freshness" time period, allowing the requesting entity to determine if/when posture attributes must be re-collected prior to performing evaluation.  This freshness time period can be "zeroed out" for the purpose of automatically triggering re-collection regardless of the most recent collection.


# Operations
The following sections describe a number of operations required to enable a cooperative ecosystem of posture attribute collection and evaluation functions.

## Component Registration
{: #component-registration-op title="Component Registration"}

Component registration describes how an individual component becomes part of the SACM ecosystem; registering with the Manager, and establishing the administrative interface.

- Interaction Type: Directed (Request/Response)
- Source Component: Any component wishing to join the ecosystem, such as Posture Collection Services, Repository Interfaces, Posture Evaluation Services and more.
- Target Component(s): Manager

### Request Payload
When a component onboards with the ecosystem, it must identify itself to the Manager, using either descriptive information or an already-existing component unique identifier.

~~~~~~
component-registration-request:
  {:component-identification:}

component-identification:
  component-unique-identifier (if re-establishing communication)
    #-OR-#
  component-type {:component-type:}
  component-name
  component-description (optional)

component-type:
  enumeration:
    - posture-collection-service
    - posture-evaluation-service
    - repository-interface
    - orchestrator
    - others?
~~~~~~

When registering for the first time, the component will send identifying information including the component type and a name.  If the component is reestablishing communications, for example after a restart of the component or deployment of a new version, the component only needs to supply its previously generated (and persisted) [component-unique-identifier].

### Request Processing
When the Manager receives the component's request for onboarding, it will:

- Generate a unique identifier, `[component-unique-identifier]`, for the onboarding component,
- Persist identifying information, including the `[component-unique-identifier]` to its component inventory, enabling an up-to-date roster of components being managed, 
- Establish the administrative interface to the onboarded component by enabling a service handler to listen for directed messages from the component.

### Response Payload
The Manager will respond to the component with a payload including the component's unique identifier.  At this point, the Manager is aware of the component's existence in the ecosystem, and the component can self-identify by virtue of receiving its unique identifier.

~~~~~~
component-registration-response:
  component-unique-identifier: [component-unique-identifier]
~~~~~~

### Response Processing
Successful receipt of the Manager's response, including the `[component-unique-identifier]`, indicates the component is onboarded to the ecosystem.  Using the response payload, the component can then establish it's end of the administrative interface with the Manager.  The component must then persist it's unique identifier for use when re-establishing communication with the Manager after failure recovery or restart.


## Administrative Interface
{: #administrative-interface title="Administrative Interface"}
A number of functions may take place which, instead of being published to multiple subscribers, may require direct interaction between the Manager and a registered component (and vice-versa).  During component onboarding, this direct channel, known as the Administrative Interface, is established first by the Manager and subsequently complemented by the component onboarding the SACM ecosystem.  Three operations are defined for the administrative interface, but any number of application or capability-specific operations MAY be enabled using the directed messaging provided by this interface.


### Capability Advertisement Handshake
{: #capability-advertisement-op title="Capability Advertisement Handshake"}
Capability advertisement represents the ability of any registered component to inform the Manager of that component's capacity for performing certain operations. For example, a Posture Collection Service component may advertise its capability to perform collection using a particular collection system/serialization.  This capability advertisement is important for the Manager to persist in order for the Manager to correctly classify components registered within the SACM ecosystem, and therefore provide the ability to publish messages to components in accordance with their capabilities.


REMOVE ME: If the Manager receives the component's capabilities, it persists them, and coordinates the interfaces to which the component should support, in order to receive notifications, instructions, or other directives intended to invoke the component's supported capabilities.

- Interaction Type: Directed (Request/Response)
- Source Component: Any registered component, such as Posture Collection Services, Repository Interfaces, Posture Evaluation Services and more.
- Target Component(s): Manager

#### Request Payload
The component's capability advertisement request payload will include a list of "Capability URNs" (TBD IANA SECTION) that represent it's supported operational capabilities.

~~~~~~
capability-advertisement:
  capabilities:
    capability-urn: [urn]
    capability-urn: [urn]
    capability-urn: [urn]
    ...
~~~~~~

#### Request Processing
Upon receipt of the component's capability advertisement, the Manager SHOULD:

- Persist the component's capabilities to the Manager's inventory
- Coordinate, based on the supplied capabilities, the service handlers (for directed messages) and/or event listeners (for broadcast messages) to which the component should support.

#### Response Payload
The response payload delivered to the component should include the appropriate service handling/event listening information required for the component to handle further interactions based on each advertised capability.  If a capability was not registered successfully, appropriate error messages SHOULD be supplied to inform the component of the failure(s).

~~~~~~
capability-advertisement-response:
  capabilities:
    capability:
      capability-urn: [urn]
      registration-status: (success | failure)
      service-handler-or-event-listener: [info]
      messages: [messages]
    capability:
      capability-urn: [urn]
      registration-status: (success | failure)
      service-handler-or-event-listener: [info]
      messages: [messages]
~~~~~~

#### Response Processing
Once the component has received the response to its capability advertisement, it should configure the capability-specific service handler(s) or event listener(s). Once these handlers/listeners have been configured, the component is considered fully onboarded to the SACM ecosystem.


### Health Check
{: #health-check-op title="Health Check"}
As time passes, it is important that the Manager maintains knowledge of all registered component's current operational status.  The health check operation describes the efforts taken by the Manager to maintain the most up-to-date inventory of it's component roster, and to potentially alert users or other outside systems of unavailable components.

- Interaction Type: Directed (Request/Response)
- Source Component: Manager
- Target Component(s): Any registered component, such as Posture Collection Services, Repository Interfaces, Posture Evaluation Services and more.

#### Request Payload
The request for the health check is a simple "ping".

~~~~~~
health-check-request:
  action: ping
~~~~~~

#### Request Processing
When the target component receives the health check request, the target component need only respond that it is operational and connected to the integration service.  This is a simple "Hello component, are you listening?  Yes, I am" interaction.  The health check request from the Manager should be made with an appropriately small timeout indicator; only an operational component will be able to respond to the request, so if that component is offline and cannot respond, the Manager should not be kept waiting for an extended amount of time.

#### Response Payload
When responding to the health check request, the response payload will simply indicate success:
~~~~~~
health-check-response:
  response: success
~~~~~~

#### Response Processing
Upon receipt of the "health-check-response" payload, the Manager will update its inventory of currently operational components with the timestamp of the receipt.  Manager implementations may raise alerts, inform users, or take other actions when health checks are unsuccessful, at their discretion.


### Heartbeat
{: #heartbeat-op title="Heartbeat"}
As time passes and SACM ecosystem components which have previously registered are brought offline (perhaps for maintenance or redeployment) and back online, it is important that registered components maintain administrative contact with the Manager. The heartbeat operation describes the efforts taken by a registered component to determine the status of contact with the Manager, and to take appropriate action if such contact cannot be made.

- Interaction Type: Directed (Request/Response)
- Source Component: Any registered component, such as Posture Collection Services, Repository Interfaces, Posture Evaluation Services and more.
- Target Component(s): Manager

#### Request Payload
The request payload simply defines the hearbeat action:

~~~~~~
heartbeat-request:
  action: pulse
~~~~~~

#### Request Processing
When the Manager receives the heartbeat request, it need only respond that it is operational and connected to the integration service.  This is a simple "Hello Manager, are you listening?  Yes, I am" interaction.  The heartbeat request from the component should be made with an appropriately small timeout indicator; only an operational Manager will be able to respond to the request, so if it is offline and cannot respond, the component should not be kept waiting for an extended amount of time.

#### Response Payload
When responding to the heartbeat request, the response payload will simply indicate success:
~~~~~~
heartbeat-response:
  response: success
~~~~~~

#### Response Processing
Upon receipt of the "heartbeat-response" payload, the component may reset its heartbeat timer and continue normal operations, awaiting incoming message payloads.  Component implementations may raise alerts, inform users, or take other actions when heartbeat requests are unsuccessful (potentially indicating a downed Manager), at their discretion.


## Status Notification
{: #-op title=""}

## Initiate Ad-Hoc Collection
### Manager to Orchestrator
{: #-op title=""}

### Orchestrator to Posture Collection Service
{: #-op title=""}

### Posture Collection Service to Posture Attribute Repository
{: #-op title=""}

## Initiate Ad-Hoc Evaluation
### Manager to Orchestrator
{: #-op title=""}

### Orchestrator to Evaluator
{: #-op title=""}

### Evaluator to Posture Evaluation Repository
{: #-op title=""}


# Privacy Considerations
[TBD]

# Security Considerations
[TBD]

# IANA Considerations
{: #iana-considerations title="IANA Considerations"}

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
