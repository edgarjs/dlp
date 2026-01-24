# [System/Feature Name] Architecture

## Overview

[Brief description of the system and its purpose]

---

## System Context

```mermaid
flowchart TD
    User[User] --> System[System Name]
    System --> ExtA[External Service A]
    System --> ExtB[External Service B]
```

[Describe how the system interacts with external entities]

---

## Components

### [Component Name]

**Responsibility:** [What this component does, in 1-2 sentences]

**Interfaces:**

- Exposes: [What other components can call]
- Consumes: [What this component depends on]

**Key decisions:**

- [Important implementation choice and rationale]

---

### [Component Name]

**Responsibility:** [What this component does]

**Interfaces:**

- Exposes: [What other components can call]
- Consumes: [What this component depends on]

**Key decisions:**

- [Important implementation choice and rationale]

---

## Component Diagram

```mermaid
flowchart TD
    subgraph Presentation
        UI[User Interface]
    end

    subgraph Application
        API[API Layer]
        Service[Business Logic]
    end

    subgraph Data
        Repo[Repository]
        DB[(Database)]
    end

    UI --> API
    API --> Service
    Service --> Repo
    Repo --> DB
```

---

## Interactions

### [Flow Name]

```mermaid
sequenceDiagram
    participant User
    participant API
    participant Service
    participant Database

    User->>API: Request
    API->>Service: Process
    Service->>Database: Query
    Database-->>Service: Result
    Service-->>API: Response
    API-->>User: Result
```

---

## Cross-Cutting Concerns

### Security

- [Security approach: authentication, authorization, encryption]

### Error Handling

- [Error handling strategy across components]

### Observability

- [Logging, monitoring, tracing approach]
