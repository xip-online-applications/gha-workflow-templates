---
name: common-domain-driven-design
description: Guides the agent through applying Domain-Driven Design principles when modeling, structuring, and implementing business logic.
---

# common-domain-driven-design

Apply Domain-Driven Design (DDD) to model complex business domains, enforce clear boundaries, and produce maintainable, intent-revealing code.

## When to use

Use this skill when:

- Designing or restructuring a domain model
- Creating new bounded contexts, aggregates, entities, or value objects
- Implementing domain events, repositories, or application services
- Reviewing code for proper separation of domain logic from infrastructure
- Discussing or documenting ubiquitous language with stakeholders

## Core concepts

### Ubiquitous Language

- Use a single, shared vocabulary between domain experts and developers.
- Every class, method, and variable in the domain layer must use terms from the ubiquitous language.
- If a term is ambiguous, clarify it and document the agreed definition.

### Bounded Contexts

- A bounded context is an explicit boundary within which a domain model is defined and consistent.
- Different bounded contexts may use the same term with different meanings — that is expected.
- Communication between bounded contexts happens through well-defined interfaces (context mapping): Anti-Corruption Layer, Shared Kernel, Open Host Service, or Published Language.

### Building blocks

| Building block     | Purpose                                                                 |
|--------------------|-------------------------------------------------------------------------|
| Entity             | An object with a unique identity that persists over time.               |
| Value Object       | An immutable object defined only by its attributes, no identity.        |
| Aggregate          | A cluster of entities/value objects with a single root entity as entry. |
| Aggregate Root     | The only entity through which external code may reference the aggregate.|
| Domain Event       | A record of something meaningful that happened in the domain.           |
| Repository         | Abstracts persistence; retrieves and stores aggregates.                 |
| Domain Service     | Stateless operation that doesn't naturally belong to an entity or VO.   |
| Application Service| Orchestrates use cases; delegates to domain objects, no business logic. |
| Factory            | Encapsulates complex creation logic for aggregates or entities.         |

## Instructions

1. **Identify the bounded context.** Before writing code, determine which bounded context you are working in. Name it explicitly. If one does not exist yet, propose one using the ubiquitous language.

2. **Define the ubiquitous language.** List the key domain terms relevant to the task. Use these terms consistently in code, comments, commit messages, and documentation.

3. **Model aggregates carefully.**
   - Each aggregate should be as small as possible — only include what is needed to enforce invariants.
   - Reference other aggregates by identity (ID), not by direct object reference.
   - All state changes go through the aggregate root.
   - Protect invariants inside the aggregate — never allow external code to put it in an invalid state.

4. **Use value objects liberally.**
   - Prefer value objects over primitives for domain concepts (e.g., `Money`, `EmailAddress`, `DateRange`).
   - Value objects are immutable: operations return new instances.
   - Implement equality by comparing all attributes.

5. **Raise domain events for side effects.**
   - When an aggregate completes a meaningful state change, emit a domain event.
   - Name events in past tense using ubiquitous language (e.g., `OrderPlaced`, `PaymentReceived`).
   - Keep events minimal: include only the data a consumer needs.
   - Process side effects (notifications, projections, integrations) in event handlers, not in the aggregate.

6. **Separate layers clearly.**
   - **Domain layer**: entities, value objects, aggregates, domain events, repository interfaces, domain services. No framework or infrastructure imports.
   - **Application layer**: application services (use-case orchestrators), command/query handlers. Depends on domain layer only.
   - **Infrastructure layer**: repository implementations, messaging adapters, ORM mappings, external API clients. Implements interfaces defined in domain/application.
   - **Presentation/API layer**: controllers, serializers, DTOs. Translates between external input and application commands/queries.

7. **Repository rules.**
   - One repository per aggregate root.
   - Repository interface lives in the domain layer; implementation lives in infrastructure.
   - Repositories return and accept only whole aggregates (not partial entities).

8. **Apply context mapping when crossing boundaries.**
   - Use an Anti-Corruption Layer (ACL) to translate between your model and an external/legacy model.
   - Define explicit DTOs or integration events at context boundaries — never leak internal domain objects.
   - If two teams share a small model, use Shared Kernel with clear ownership rules.

9. **Folder/module structure.** Organize code to mirror bounded contexts:

   ```text
   src/
     <bounded-context>/
       domain/
         model/          # Aggregates, entities, value objects
         event/          # Domain events
         service/        # Domain services
         repository/     # Repository interfaces
       application/
         command/        # Command handlers / use cases
         query/          # Query handlers / read models
       infrastructure/
         persistence/    # Repository implementations
         messaging/      # Event bus adapters
       presentation/     # Controllers, DTOs
   ```

10. **Validate the design.**
    - Every public method on an aggregate root should correspond to a domain action in the ubiquitous language.
    - If you cannot name something using domain terms, reconsider the model.
    - Ask: "Can this aggregate enforce its own invariants without reaching outside itself?" If no, redraw boundaries.
    - Confirm no business logic leaked into application services, controllers, or infrastructure.
