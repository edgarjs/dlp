# Observability

Observability is the ability to understand a system's internal state from its external outputs. It answers: "What is happening, and why?"

---

## Observability Mindset

### You Can't Fix What You Can't See

Production systems fail in unexpected ways. Without observability:
- Problems are discovered by users, not operators
- Root causes remain mysteries
- Fixes are guesses, not solutions

### The Three Pillars

**Logs** — Discrete events that happened.
```
"User 123 logged in at 10:23:45"
"Payment failed: insufficient funds"
```

**Metrics** — Aggregated measurements over time.
```
request_count: 1,523
error_rate: 0.02%
response_time_p95: 245ms
```

**Traces** — Request flow through distributed systems.
```
Request → API Gateway → Auth Service → Database → Response
         [12ms]        [45ms]         [89ms]
```

Each pillar answers different questions:
- Logs: What specifically happened?
- Metrics: What is the overall health?
- Traces: Where did time go?

---

## Logging

### What to Log

**Do log:**
- Request/response summaries
- Errors and exceptions
- Authentication events
- Business-significant actions
- State transitions
- External service calls

**Don't log:**
- Sensitive data (passwords, tokens, PII)
- High-volume routine events (in production)
- Redundant information
- Binary data

### Log Levels

Use levels consistently:

| Level | Purpose                           | Example                       |
| ----- | --------------------------------- | ----------------------------- |
| ERROR | Something failed, needs attention | Database connection lost      |
| WARN  | Potential problem, degraded state | Retry succeeded after failure |
| INFO  | Significant business events       | Order completed               |
| DEBUG | Detailed diagnostic info          | Cache hit/miss                |
| TRACE | Very detailed flow information    | Method entry/exit             |

```
Production: INFO and above
Development: DEBUG and above
Troubleshooting: TRACE when needed
```

### Structured Logging

Use structured formats (JSON) over plain text.

```
Poor (plain text):
  "User 123 failed to login from 192.168.1.1 - invalid password"

Better (structured):
  {
    "event": "login_failed",
    "user_id": 123,
    "ip": "192.168.1.1",
    "reason": "invalid_password",
    "timestamp": "2024-01-15T10:23:45Z"
  }
```

**Benefits of structured logging:**
- Machine-parseable
- Searchable by field
- Aggregatable
- Consistent format

### Contextual Information

Include context that aids debugging:

```
Essential context:
  - Timestamp (ISO 8601, UTC)
  - Request/correlation ID
  - User/tenant identifier
  - Service/component name
  - Environment (prod, staging)

Situational context:
  - HTTP method and path
  - Response status code
  - Duration
  - Error details
```

### Correlation IDs

Track requests across services with a shared ID.

```
Request arrives → Generate correlation_id: "abc-123"
  → Service A logs: {correlation_id: "abc-123", ...}
  → Service B logs: {correlation_id: "abc-123", ...}
  → Service C logs: {correlation_id: "abc-123", ...}

Search for "abc-123" → See entire request flow
```

---

## Metrics

### Types of Metrics

**Counters** — Values that only increase.
```
http_requests_total
errors_total
orders_completed
```

**Gauges** — Values that go up and down.
```
active_connections
queue_depth
memory_usage_bytes
```

**Histograms** — Distribution of values.
```
request_duration_seconds
response_size_bytes
```

### What to Measure

**RED method (request-driven):**
- **R**ate — Requests per second
- **E**rrors — Failed requests per second
- **D**uration — Time per request

**USE method (resource-driven):**
- **U**tilization — Percentage of resource used
- **S**aturation — Amount of queued work
- **E**rrors — Error events

### Naming Conventions

Use consistent, descriptive names:

```
Format: <namespace>_<name>_<unit>

Examples:
  http_requests_total
  http_request_duration_seconds
  db_connections_active
  queue_messages_pending
  cache_hits_total
  cache_misses_total
```

### Cardinality

Be careful with label values:

```
Dangerous (unbounded cardinality):
  request_duration{user_id="..."}  // Millions of users

Safe (bounded cardinality):
  request_duration{endpoint="/users", method="GET", status="200"}
```

High cardinality explodes storage and query costs.

---

## Distributed Tracing

### Trace Structure

```
Trace: End-to-end request
  └── Span: API Gateway (12ms)
      └── Span: Auth Service (45ms)
          └── Span: Database Query (30ms)
      └── Span: Order Service (89ms)
          └── Span: Database Query (50ms)
          └── Span: Payment Service (35ms)
```

**Trace** — Complete journey of a request.
**Span** — Single operation within a trace.
**Context** — Propagated identifiers linking spans.

### When Tracing Helps

- Identifying slow services in a chain
- Understanding request flow
- Debugging distributed failures
- Capacity planning

### Context Propagation

Pass trace context between services:

```
Service A:
  trace_id = generate_trace_id()
  span_id = generate_span_id()
  call Service B with headers:
    traceparent: "00-{trace_id}-{span_id}-01"

Service B:
  extract trace_id, parent_span_id from headers
  create child span linked to parent
```

### What to Trace

- Incoming HTTP requests
- Outgoing HTTP calls
- Database queries
- Cache operations
- Message queue operations
- Significant internal operations

---

## Alerting

### Alert Design

**Alert on symptoms, not causes:**
```
Poor:  Alert when CPU > 80%
Better: Alert when response time > 500ms

CPU might be high and users happy.
Response time directly impacts users.
```

**Actionable alerts:**
```
Every alert should have:
  - Clear description of what's wrong
  - Impact on users/business
  - Suggested investigation steps
  - Runbook link if applicable
```

### Alert Levels

| Level    | Meaning                       | Response                 |
| -------- | ----------------------------- | ------------------------ |
| Critical | Service down, data loss risk  | Immediate page           |
| Warning  | Degraded, may become critical | Investigate soon         |
| Info     | Notable but not urgent        | Review in business hours |

### Avoiding Alert Fatigue

```
Problems:
  - Too many alerts → Ignored
  - Noisy alerts → Desensitization
  - False positives → Distrust

Solutions:
  - Alert only on actionable conditions
  - Tune thresholds based on data
  - Group related alerts
  - Regular alert review and cleanup
```

### Alert Checklist

```
For each alert:
- [ ] Is it actionable?
- [ ] Does it indicate user impact?
- [ ] Is the threshold based on data?
- [ ] Is there a runbook?
- [ ] Is the severity appropriate?
- [ ] Will it fire too often?
```

---

## Dashboards

### Dashboard Types

**Overview dashboard** — System health at a glance.
```
Include:
  - Request rate
  - Error rate
  - Latency (p50, p95, p99)
  - Active users/connections
  - Resource utilization
```

**Service dashboard** — Deep dive into one service.
```
Include:
  - Service-specific metrics
  - Dependencies health
  - Recent deployments
  - Error breakdown
```

**Investigation dashboard** — For troubleshooting.
```
Include:
  - Detailed breakdowns
  - Comparison tools
  - Log integration
  - Trace links
```

### Dashboard Guidelines

```
Do:
  - Show what matters at the top
  - Use consistent time ranges
  - Include context (deployments, incidents)
  - Link to related dashboards

Don't:
  - Cram too much on one page
  - Use confusing visualizations
  - Show vanity metrics
  - Let dashboards go stale
```

---

## Implementation Guidelines

### Logging Best Practices

```
- [ ] Use structured logging (JSON)
- [ ] Include correlation IDs
- [ ] Set appropriate log levels
- [ ] Don't log sensitive data
- [ ] Include relevant context
- [ ] Configure log retention
```

### Metrics Best Practices

```
- [ ] Follow naming conventions
- [ ] Use appropriate metric types
- [ ] Watch cardinality
- [ ] Set up RED/USE metrics
- [ ] Define SLIs/SLOs
```

### Tracing Best Practices

```
- [ ] Instrument service boundaries
- [ ] Propagate context correctly
- [ ] Sample appropriately in production
- [ ] Include relevant span attributes
- [ ] Link traces to logs
```

---

## Observability by Phase

### Requirements Phase

- Define SLIs (Service Level Indicators)
- Set SLOs (Service Level Objectives)
- Identify critical user journeys to monitor
- Plan for compliance/audit logging

### Design Phase

- Plan instrumentation points
- Design correlation ID strategy
- Plan log aggregation architecture
- Define key metrics per component

### Development Phase

- Add logging at appropriate points
- Instrument code for metrics
- Add tracing spans
- Include context in all telemetry
- Test that observability works

### Testing Phase

- Verify logs contain expected information
- Test metrics are recorded correctly
- Validate traces connect properly
- Test alerting rules
- Load test observability infrastructure

---

## Observability Review Checklist

```
Logging:
- [ ] Structured format used
- [ ] Correlation IDs present
- [ ] Appropriate log levels
- [ ] No sensitive data logged
- [ ] Sufficient context included

Metrics:
- [ ] Request rate tracked
- [ ] Error rate tracked
- [ ] Latency percentiles tracked
- [ ] Resource utilization tracked
- [ ] Cardinality controlled

Tracing:
- [ ] Traces span service boundaries
- [ ] Context propagated correctly
- [ ] Critical paths instrumented
- [ ] Traces linked to logs

Alerting:
- [ ] Critical paths have alerts
- [ ] Alerts are actionable
- [ ] Runbooks exist
- [ ] On-call rotation defined

Dashboards:
- [ ] Overview dashboard exists
- [ ] Key metrics visible
- [ ] Dashboards maintained
```
