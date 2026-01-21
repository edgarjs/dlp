# Performance

Performance determines how efficiently a system uses resources to accomplish tasks. Poor performance frustrates users, wastes resources, and can cause systems to fail under load.

---

## Performance Mindset

### Measure First

Never optimize without data. Intuition about bottlenecks is often wrong.

```
Optimization without measurement:
  "This loop looks slow, let me optimize it"
  Result: 2 hours spent, 0.1% improvement

Optimization with measurement:
  Profile shows 80% of time in database query
  Result: Add index, 10x improvement
```

### Optimize the Right Thing

Focus on what matters:
- **Hot paths** — Code that runs frequently
- **User-facing latency** — What users wait for
- **Resource constraints** — Memory, CPU, network, storage

Don't optimize:
- Code that rarely runs
- Differences users won't notice
- Problems you don't have yet (YAGNI)

### Performance Budgets

Set explicit limits:
- Page load time < 2 seconds
- API response time < 200ms (p95)
- Memory usage < 512MB
- Bundle size < 200KB

Budgets make performance a requirement, not an afterthought.

---

## Common Performance Issues

### Database

**N+1 queries** — Fetching related data one record at a time.

```
Problem:
  orders = get_all_orders()          // 1 query
  for order in orders:
    order.user = get_user(order.user_id)  // N queries

Solution:
  orders = get_all_orders_with_users()    // 1 query with join
  // Or batch: get_users(order.user_ids)  // 2 queries total
```

**Missing indexes** — Full table scans on large tables.

```
Problem:
  SELECT * FROM orders WHERE user_id = 123
  // Scans millions of rows

Solution:
  CREATE INDEX idx_orders_user_id ON orders(user_id)
  // Direct lookup
```

**Over-fetching** — Retrieving more data than needed.

```
Problem:
  SELECT * FROM users  // Returns 50 columns
  // Only need name and email

Solution:
  SELECT name, email FROM users
```

### Memory

**Unbounded collections** — Loading entire datasets into memory.

```
Problem:
  all_records = database.get_all()  // Millions of records
  for record in all_records:
    process(record)

Solution:
  for batch in database.get_in_batches(1000):
    for record in batch:
      process(record)
```

**Memory leaks** — Objects retained longer than needed.

```
Common causes:
  - Event listeners not removed
  - Caches without eviction
  - Circular references (in some languages)
  - Growing buffers never cleared
```

**Large object allocation** — Creating unnecessary copies.

```
Problem:
  data = get_large_data()
  copy = data.clone()  // Doubles memory
  process(copy)

Solution:
  data = get_large_data()
  process(data)  // Process in place if possible
```

### Network

**Chatty protocols** — Too many round trips.

```
Problem:
  get_user(id)           // Round trip 1
  get_user_orders(id)    // Round trip 2
  get_user_preferences(id)  // Round trip 3

Solution:
  get_user_with_details(id)  // Single round trip
  // Or batch multiple requests
```

**Large payloads** — Transferring more data than needed.

```
Problem:
  API returns entire object graph
  Client only needs summary

Solution:
  Separate endpoints for summary vs detail
  Or use field selection (GraphQL, sparse fieldsets)
```

**Missing compression** — Sending uncompressed data.

```
Enable gzip/brotli for:
  - API responses
  - Static assets
  - Large text payloads
```

### Computation

**Redundant calculation** — Computing the same thing repeatedly.

```
Problem:
  for item in items:
    tax_rate = get_tax_rate(region)  // Same every iteration
    item.tax = item.price * tax_rate

Solution:
  tax_rate = get_tax_rate(region)  // Once
  for item in items:
    item.tax = item.price * tax_rate
```

**Inefficient algorithms** — Wrong complexity for the data size.

```
Problem:
  // O(n²) search in large list
  for item in large_list:
    if item in another_large_list:
      process(item)

Solution:
  // O(n) with set lookup
  lookup_set = set(another_large_list)
  for item in large_list:
    if item in lookup_set:
      process(item)
```

**Blocking operations** — Synchronous waits that could be parallel.

```
Problem:
  result_a = fetch_from_service_a()  // Wait
  result_b = fetch_from_service_b()  // Wait
  // Total: time_a + time_b

Solution:
  future_a = async fetch_from_service_a()
  future_b = async fetch_from_service_b()
  result_a, result_b = await all(future_a, future_b)
  // Total: max(time_a, time_b)
```

---

## Optimization Techniques

### Caching

Store computed results to avoid recomputation.

**Cache levels:**
- Application memory (fastest, limited size)
- Distributed cache (shared across instances)
- CDN (static content, edge locations)
- Browser cache (client-side)

**Cache considerations:**
```
Questions to answer:
  - What to cache? (expensive or frequent operations)
  - How long? (TTL based on data freshness needs)
  - When to invalidate? (on update, on schedule)
  - Cache key? (must uniquely identify cached item)
```

**Cache pitfalls:**
- Stale data served after updates
- Cache stampede (many requests on expiry)
- Memory exhaustion (unbounded cache)

### Lazy Loading

Defer work until needed.

```
Eager (always loaded):
  user.orders = fetch_all_orders(user.id)  // Maybe never used

Lazy (loaded on access):
  user.orders  // Fetches only when accessed
```

**Good for:**
- Related data that may not be needed
- Expensive initialization
- Large resources (images, documents)

**Bad for:**
- Data that's almost always needed (adds latency)
- Situations where you'd create N+1 queries

### Pagination

Process or display data in chunks.

```
Problem:
  return all_10000_records

Solution:
  return records[offset:offset+limit]
  // With metadata: total_count, next_page, prev_page
```

**Pagination strategies:**
- Offset/limit (simple, slow for large offsets)
- Cursor-based (consistent, better for large datasets)
- Keyset (efficient, requires sortable column)

### Denormalization

Trade storage for query speed.

```
Normalized:
  Order → OrderItems → Products
  // 3 joins to get order with product names

Denormalized:
  Order contains product_name copied from Products
  // 1 query, but product_name updates don't propagate
```

**Use when:**
- Read performance is critical
- Data changes infrequently
- Consistency lag is acceptable

### Asynchronous Processing

Move work out of the critical path.

```
Synchronous:
  create_order()
  send_confirmation_email()  // User waits
  update_analytics()         // User waits
  return response

Asynchronous:
  create_order()
  queue(send_confirmation_email)  // Background
  queue(update_analytics)         // Background
  return response  // User doesn't wait
```

**Good for:**
- Non-critical operations
- Operations that can fail independently
- Work that takes unpredictable time

---

## Measuring Performance

### Key Metrics

**Latency** — Time to complete a request.
- p50 (median) — Typical experience
- p95/p99 — Worst cases most users see
- Max — Worst case (often outliers)

**Throughput** — Requests handled per unit time.
- Requests per second
- Transactions per minute

**Resource utilization** — How much capacity is used.
- CPU usage
- Memory usage
- Network bandwidth
- Disk I/O

**Error rate** — Failed requests under load.

### Profiling

Identify where time is spent.

**Types of profiling:**
- CPU profiling — Which functions use CPU time
- Memory profiling — What allocates memory
- I/O profiling — What waits on disk/network
- Database profiling — Which queries are slow

**Profiling approach:**
```
1. Reproduce the slow scenario
2. Run profiler during execution
3. Identify hotspots (top time consumers)
4. Analyze if hotspot is necessary
5. Optimize or eliminate
6. Verify improvement with measurement
```

### Load Testing

Verify performance under realistic conditions.

**Test types:**
- Baseline — Normal expected load
- Stress — Find breaking point
- Soak — Extended duration for leaks
- Spike — Sudden traffic increases

**Load test checklist:**
```
- [ ] Realistic data volumes
- [ ] Realistic request patterns
- [ ] Realistic user behavior
- [ ] Production-like environment
- [ ] Monitor all resources during test
```

---

## Performance by Phase

### Requirements Phase

- Define performance requirements explicitly
- Identify performance-critical operations
- Set measurable targets (latency, throughput)
- Consider expected load and growth

### Design Phase

- Choose appropriate data structures
- Plan caching strategy
- Design for horizontal scaling if needed
- Consider async processing for heavy operations
- Review database schema for query patterns

### Development Phase

- Use efficient algorithms and data structures
- Avoid premature optimization
- Profile before and after changes
- Keep an eye on dependency bloat

### Testing Phase

- Include performance tests in CI/CD
- Test with realistic data volumes
- Profile periodically during development
- Load test before major releases

---

## Performance Review Checklist

### Database
```
- [ ] Queries are indexed appropriately
- [ ] No N+1 query patterns
- [ ] Only needed columns selected
- [ ] Pagination for large result sets
- [ ] Connection pooling configured
```

### Caching
```
- [ ] Frequently accessed data cached
- [ ] Cache invalidation strategy defined
- [ ] Cache size bounded
- [ ] Cache hit rate monitored
```

### Network
```
- [ ] Compression enabled
- [ ] Minimal round trips
- [ ] Appropriate payload sizes
- [ ] CDN for static assets
```

### Code
```
- [ ] No unnecessary computation in loops
- [ ] Appropriate algorithm complexity
- [ ] Async for independent operations
- [ ] Memory not leaked
```

### Monitoring
```
- [ ] Latency tracked (p50, p95, p99)
- [ ] Throughput tracked
- [ ] Resource utilization tracked
- [ ] Alerts on degradation
```
