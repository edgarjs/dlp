# Cross-Cutting Concerns

This folder contains guidance for concerns that span all phases of development. Unlike the phase-based documents, these apply throughout the entire software development lifecycle.

---

## Quick Reference

| Concern                           | Purpose                      | Key Questions                                                     |
| --------------------------------- | ---------------------------- | ----------------------------------------------------------------- |
| [Security](security.md)           | Protect systems from threats | What data is sensitive? Who can access what?                      |
| [Performance](performance.md)     | Optimize efficiency          | What are the response time goals? What scale is expected?         |
| [Accessibility](accessibility.md) | Ensure usability for all     | Who are the users? What assistive technologies must be supported? |
| [Observability](observability.md) | Understand system state      | How will we know if something is wrong? What metrics matter?      |

---

## Phase Integration Matrix

Reference these concerns at each phase:

### REQUIREMENTS Phase

| Concern           | Actions                                                                                   |
| ----------------- | ----------------------------------------------------------------------------------------- |
| **Security**      | Identify sensitive data, authentication requirements, compliance needs (GDPR, PCI, HIPAA) |
| **Performance**   | Define response time goals, throughput expectations, scalability requirements             |
| **Accessibility** | Identify user accessibility needs, required compliance (WCAG level)                       |
| **Observability** | Define monitoring requirements, alerting needs, audit logging requirements                |

### DESIGN Phase

| Concern           | Actions                                                                             |
| ----------------- | ----------------------------------------------------------------------------------- |
| **Security**      | Establish trust boundaries, design auth/authz, plan encryption, create threat model |
| **Performance**   | Design for efficiency, identify potential bottlenecks, plan caching strategy        |
| **Accessibility** | Design inclusive interfaces, plan keyboard navigation, ensure color contrast        |
| **Observability** | Design logging strategy, define metrics, plan distributed tracing                   |

### DEVELOPMENT Phase

| Concern           | Actions                                                                            |
| ----------------- | ---------------------------------------------------------------------------------- |
| **Security**      | Validate all input, encode output, use parameterized queries, follow secure coding |
| **Performance**   | Implement efficiently, avoid N+1 queries, use appropriate data structures          |
| **Accessibility** | Use semantic HTML, add ARIA labels, ensure focus management                        |
| **Observability** | Add structured logging, emit metrics, propagate trace context                      |

### TESTING Phase

| Concern           | Actions                                                                        |
| ----------------- | ------------------------------------------------------------------------------ |
| **Security**      | Test authentication bypass, authorization at every endpoint, injection attacks |
| **Performance**   | Load test critical paths, verify response times, test under stress             |
| **Accessibility** | Test with screen readers, verify keyboard navigation, check color contrast     |
| **Observability** | Verify logs contain expected data, test alerting, validate metrics             |

---

## How to Use

1. **At each phase transition**, review the relevant row in the integration matrix
2. **When making decisions**, check if any concern provides relevant guidance
3. **Before completing a phase**, verify concern-related requirements are addressed
4. **During code review**, verify concern-specific practices are followed

---

## Contents

| Document                             | Purpose                                                      |
| ------------------------------------ | ------------------------------------------------------------ |
| [security.md](security.md)           | Protecting systems from threats and vulnerabilities          |
| [performance.md](performance.md)     | Optimizing system efficiency and responsiveness              |
| [accessibility.md](accessibility.md) | Ensuring usability for people with diverse abilities         |
| [observability.md](observability.md) | Understanding system state through logs, metrics, and traces |

---

## When to Prioritize Concerns

Not all concerns are equally important for every project. Prioritize based on context:

**Security-critical projects:**

- Financial systems, healthcare, authentication services
- Security is non-negotiable; other concerns flex around it

**Performance-critical projects:**

- Real-time systems, high-traffic applications, games
- Performance requirements drive architectural decisions

**Accessibility-critical projects:**

- Government services, public-facing applications, educational tools
- Accessibility may be legally required and is ethically important

**Observability-critical projects:**

- Distributed systems, microservices, production systems
- Understanding system behavior in production is essential

When concerns conflict, document the trade-off explicitly using `templates/design-decision.md`.
