---
name: common-hexagonal-architecture
description: Guides the agent through applying Hexagonal Architecture (Ports & Adapters) to isolate domain logic from external concerns within a service.
---

# common-hexagonal-architecture

Apply Hexagonal Architecture (also known as Ports & Adapters) to keep domain logic independent of frameworks, databases, messaging systems, and UIs within a single service boundary.

## When to use

Use this skill when:

- Designing or restructuring the internal architecture of a service or module
- Ensuring domain/business logic is testable without infrastructure dependencies
- Introducing a new external integration (database, API, queue, file system)
- Reviewing code to verify that infrastructure concerns do not leak into the core
- Refactoring a layered or "big ball of mud" codebase toward cleaner boundaries

## Core concepts

### The Hexagon (Application Core)

The hexagon contains all business logic and domain rules. It knows nothing about the outside world — no HTTP, no SQL, no file I/O. It communicates exclusively through **ports**.

### Ports

A port is an interface (contract) that defines how the application core interacts with the outside world.

| Port type       | Direction | Purpose                                                       |
|-----------------|-----------|---------------------------------------------------------------|
| **Driving port** (primary)  | Inbound   | Defines use cases the outside world can invoke on the core.   |
| **Driven port** (secondary) | Outbound  | Defines what the core needs from external systems.            |

- Driving ports are implemented **by** the application core (the use case / application service).
- Driven ports are implemented **by** adapters in the infrastructure layer.

### Adapters

An adapter translates between the external world and a port.

| Adapter type       | Connects to        | Examples                                                   |
|--------------------|--------------------|------------------------------------------------------------|
| **Driving adapter** (primary)  | Driving port       | REST controller, CLI handler, gRPC server, message consumer |
| **Driven adapter** (secondary) | Driven port        | SQL repository, HTTP client, SMTP mailer, file store        |

### Dependency Rule

Dependencies always point **inward** — adapters depend on ports, ports live in the core, the core depends on nothing external.

```text
[Driving Adapter] --> [Driving Port (interface)]
                            |
                    [Application Core]
                            |
                  [Driven Port (interface)] <-- [Driven Adapter]
```

## Instructions

1. **Define driving ports as use-case interfaces.**
   - One interface per use case or cohesive group of use cases.
   - Name them after domain actions: `PlaceOrder`, `RegisterUser`, `GenerateReport`.
   - Accept and return only domain objects or simple DTOs — never framework-specific types.

2. **Implement driving ports in application services.**
   - Application services live inside the hexagon.
   - They orchestrate domain objects and call driven ports.
   - They contain no infrastructure logic (no SQL, no HTTP calls, no file I/O).

3. **Define driven ports as repository/gateway interfaces.**
   - One interface per external dependency concept: `OrderRepository`, `PaymentGateway`, `NotificationSender`.
   - Keep method signatures focused on domain needs, not technology (e.g., `findByCustomerId(id)` not `executeQuery(sql)`).
   - Driven port interfaces live in the application core alongside the domain.

4. **Implement driven adapters in infrastructure.**
   - Each driven adapter implements exactly one driven port interface.
   - Contains all technology-specific code (ORM calls, HTTP clients, SDK usage).
   - Can be swapped without touching the core (e.g., switch from PostgreSQL to DynamoDB).

5. **Implement driving adapters at the boundary.**
   - A driving adapter receives external input (HTTP request, CLI args, queue message).
   - It translates the input into a call on a driving port.
   - It translates the port's response back into an external response (JSON, exit code, ack).
   - A driving adapter must not contain business logic — only mapping and delegation.

6. **Wire dependencies via injection.**
   - Use constructor injection (or a composition root / DI container) to pass driven adapter instances into application services.
   - The composition root is the **only place** that knows about concrete adapter implementations.
   - In tests, inject fake/mock/in-memory adapters through the same ports.

7. **Folder/module structure.** Organize a service to clearly reflect the hexagon:

   ```text
   src/
     <service-or-module>/
       core/
         domain/
           model/             # Entities, value objects, aggregates
           event/             # Domain events
           service/           # Domain services (pure logic)
         port/
           in/               # Driving port interfaces (use cases)
           out/              # Driven port interfaces (repositories, gateways)
         application/
           service/          # Application services implementing driving ports
           dto/              # Input/output DTOs for ports
       adapter/
         in/
           web/             # REST/GraphQL controllers
           cli/             # CLI command handlers
           messaging/       # Message/event consumers
         out/
           persistence/     # Database repositories
           http/            # External API clients
           messaging/       # Event publishers, queue producers
           filesystem/      # File storage adapters
       config/              # Composition root, DI wiring, framework bootstrap
   ```

8. **Testing strategy aligned to the hexagon.**
   - **Unit tests**: test domain model and application services with in-memory/fake driven adapters. No real I/O.
   - **Integration tests**: test driven adapters against real infrastructure (database, external API with testcontainers or sandbox).
   - **Acceptance tests**: invoke driving ports (or driving adapters) end-to-end with real or near-real adapters to verify full use cases.
   - The majority of tests should be unit tests against the core — fast, deterministic, no mocking of internals.

9. **Guard the boundaries.**
   - The core must never import from `adapter/` packages.
   - Adapters may only import from `core/port/` (and `core/domain/model/` for types).
   - Enforce this with module boundaries (lint rules, package visibility, architecture tests like ArchUnit/Deptrac/dependency-cruiser).

10. **Validate the architecture.**
    - Can you test any use case by injecting fakes for all driven ports? If not, a dependency is leaking.
    - Can you replace a driven adapter (e.g., swap Postgres for an in-memory store) without changing the core? If not, the port is too coupled.
    - Does the driving adapter contain conditional business logic? If yes, push it into the core behind the driving port.
    - Is the composition root the only file that references concrete adapter classes? If not, wiring has leaked.
