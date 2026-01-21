# Accessibility

Accessibility ensures software is usable by people with diverse abilities. This includes users with visual, auditory, motor, or cognitive disabilities, as well as those using assistive technologies.

---

## Accessibility Mindset

### Universal Design

Design for the widest range of users from the start, not as an afterthought.

```
Retrofitting accessibility:
  Build feature → Discover barriers → Expensive fixes

Universal design:
  Consider diverse users → Build inclusively → Fewer barriers
```

### Permanent, Temporary, Situational

Disabilities exist on a spectrum:

| Type      | Permanent           | Temporary     | Situational       |
| --------- | ------------------- | ------------- | ----------------- |
| Visual    | Blind               | Eye infection | Bright sunlight   |
| Auditory  | Deaf                | Ear infection | Noisy environment |
| Motor     | Missing limb        | Broken arm    | Holding a baby    |
| Cognitive | Learning disability | Concussion    | Distraction       |

Accessible design helps everyone, not just those with permanent disabilities.

### Assistive Technologies

Users interact with software through various tools:

- **Screen readers** — Read content aloud (JAWS, NVDA, VoiceOver)
- **Screen magnifiers** — Enlarge portions of the screen
- **Voice control** — Navigate and input via speech
- **Switch devices** — Single buttons for users with limited mobility
- **Braille displays** — Tactile output for blind users

Software must work with these tools, not against them.

---

## Core Principles (POUR)

### Perceivable

Information must be presentable in ways users can perceive.

**Text alternatives** — Non-text content has text equivalents.

```
Images:
  <img src="chart.png" alt="Sales increased 25% in Q3">

Icons:
  <button aria-label="Close dialog">×</button>

Decorative images:
  <img src="divider.png" alt="" role="presentation">
```

**Captions and transcripts** — Audio and video have text alternatives.

```
Video content needs:
  - Captions for dialogue and sounds
  - Audio description for visual information
  - Transcript for full text access
```

**Adaptable presentation** — Content can be presented differently without losing meaning.

```
Good:
  Use semantic HTML (headings, lists, tables)
  Content makes sense without styles

Bad:
  Meaning conveyed only through color
  Layout-dependent content order
```

**Distinguishable** — Easy to see and hear content.

```
Color contrast:
  - Normal text: 4.5:1 minimum ratio
  - Large text (18pt+): 3:1 minimum ratio
  - UI components: 3:1 minimum ratio

Don't rely on color alone:
  Poor:  "Required fields are red"
  Better: "Required fields are marked with *"
```

### Operable

Interface components must be operable by all users.

**Keyboard accessible** — All functionality available via keyboard.

```
Requirements:
  - All interactive elements focusable
  - Logical tab order
  - No keyboard traps
  - Visible focus indicator

Test:
  Can you complete all tasks using only Tab, Enter, Space, and arrow keys?
```

**Navigable** — Users can find content and know where they are.

```
Page structure:
  - Descriptive page titles
  - Clear heading hierarchy (h1 → h2 → h3)
  - Skip links to main content
  - Multiple ways to find pages (nav, search, sitemap)

Focus management:
  - Logical focus order
  - Focus visible at all times
  - Focus moves appropriately in dynamic content
```

### Understandable

Information and interface operation must be understandable.

**Readable** — Text content is readable and understandable.

```
Language:
  - Declare page language (<html lang="en">)
  - Mark language changes in content
  - Define unusual words or abbreviations

Clarity:
  - Use plain language
  - Keep sentences concise
  - Explain jargon and acronyms
```

**Predictable** — Pages behave in predictable ways.

```
Consistency:
  - Navigation in same location across pages
  - Similar components behave similarly
  - No unexpected context changes

Context changes:
  - Don't change context on focus alone
  - Warn before opening new windows
  - Explain form submission results
```

**Input assistance** — Help users avoid and correct mistakes.

```
Error handling:
  - Identify errors clearly
  - Describe errors in text (not just color)
  - Suggest corrections
  - Allow review before final submission

Labels and instructions:
  - Label all form fields
  - Provide format examples
  - Mark required fields clearly
```

### Robust

Content must work with current and future technologies.

**Compatible** — Works with assistive technologies.

```
Valid markup:
  - Complete start and end tags
  - No duplicate attributes
  - Unique IDs

ARIA usage:
  - Use native HTML elements when possible
  - Add ARIA only when HTML isn't sufficient
  - Ensure ARIA roles, states, and properties are correct
```

---

## Implementation Guidelines

### Semantic HTML

Use HTML elements for their intended purpose.

```
Poor:
  <div class="button" onclick="submit()">Submit</div>
  <div class="heading">Page Title</div>

Better:
  <button type="submit">Submit</button>
  <h1>Page Title</h1>
```

**Common semantic elements:**

| Purpose      | Element                          |
| ------------ | -------------------------------- |
| Page regions | header, nav, main, footer, aside |
| Headings     | h1-h6 (in order)                 |
| Lists        | ul, ol, li                       |
| Tables       | table, th, td (with scope)       |
| Forms        | form, label, fieldset, legend    |
| Buttons      | button                           |
| Links        | a (with href)                    |

### Forms

Forms are critical for accessibility.

```
Label association:
  <label for="email">Email</label>
  <input type="email" id="email" name="email">

Required fields:
  <label for="name">Name (required)</label>
  <input type="text" id="name" required aria-required="true">

Error messages:
  <input type="email" id="email" aria-describedby="email-error">
  <span id="email-error" role="alert">Please enter a valid email</span>

Grouping related fields:
  <fieldset>
    <legend>Shipping Address</legend>
    <!-- address fields -->
  </fieldset>
```

### Images

All images need appropriate text alternatives.

```
Informative images:
  <img src="graph.png" alt="Revenue grew from $1M to $1.5M in 2024">

Functional images (links/buttons):
  <a href="/home">
    <img src="logo.png" alt="Company Name - Home">
  </a>

Decorative images:
  <img src="decorative-border.png" alt="" role="presentation">

Complex images:
  <figure>
    <img src="complex-diagram.png" alt="System architecture overview">
    <figcaption>
      Detailed description: The system consists of...
    </figcaption>
  </figure>
```

### Dynamic Content

Single-page apps and dynamic updates need special attention.

```
Focus management:
  // After loading new content
  newContent.focus()

  // After closing modal
  triggerButton.focus()

Live regions (announce changes):
  <div aria-live="polite">
    3 items in cart
  </div>

  <div role="alert">
    Error: Payment failed
  </div>

Loading states:
  <button aria-busy="true" aria-label="Submitting...">
    <span class="spinner"></span>
  </button>
```

### Keyboard Interaction

Standard keyboard patterns users expect:

| Element       | Key          | Action         |
| ------------- | ------------ | -------------- |
| Button        | Enter, Space | Activate       |
| Link          | Enter        | Follow link    |
| Checkbox      | Space        | Toggle         |
| Radio buttons | Arrow keys   | Move selection |
| Tabs          | Arrow keys   | Switch tab     |
| Menu          | Arrow keys   | Navigate items |
| Dialog        | Escape       | Close          |

```
Custom components must implement expected patterns:

// Tab panel example
Tab: aria-selected="true/false"
Panel: aria-labelledby="tab-id"
Arrow keys move between tabs
Tab content receives focus
```

---

## Testing Accessibility

### Automated Testing

Tools catch ~30% of issues automatically.

```
Tools:
  - axe DevTools (browser extension)
  - WAVE (browser extension)
  - Lighthouse (built into Chrome)
  - Pa11y (command line)
  - jest-axe (unit testing)

Automated tests catch:
  - Missing alt text
  - Color contrast issues
  - Missing form labels
  - Invalid ARIA
  - Heading order issues
```

### Manual Testing

Essential for complete coverage.

**Keyboard testing:**
```
1. Unplug mouse
2. Navigate entire page with Tab
3. Activate all controls with Enter/Space
4. Check focus visibility throughout
5. Verify no keyboard traps
```

**Screen reader testing:**
```
Test with at least one:
  - NVDA (Windows, free)
  - VoiceOver (macOS/iOS, built-in)
  - TalkBack (Android, built-in)

Verify:
  - All content announced
  - Images have descriptions
  - Forms are labeled
  - Dynamic updates announced
  - Navigation makes sense
```

**Zoom testing:**
```
1. Zoom to 200%
2. Check content reflows (no horizontal scroll)
3. Verify all content visible
4. Check touch targets remain usable
```

### Accessibility Review Checklist

```
Perceivable:
- [ ] Images have alt text
- [ ] Videos have captions
- [ ] Color contrast meets minimums
- [ ] Color isn't only indicator
- [ ] Content works without styles

Operable:
- [ ] All functions keyboard accessible
- [ ] Focus order is logical
- [ ] Focus indicator visible
- [ ] No keyboard traps
- [ ] Skip link to main content

Understandable:
- [ ] Page language declared
- [ ] Headings are hierarchical
- [ ] Form fields labeled
- [ ] Errors clearly identified
- [ ] Instructions provided

Robust:
- [ ] HTML is valid
- [ ] ARIA used correctly
- [ ] Works with screen readers
- [ ] Dynamic content accessible
```

---

## Accessibility by Phase

### Requirements Phase

- Include accessibility in requirements
- Define target conformance level (WCAG A, AA, AAA)
- Identify user groups and assistive technologies
- Consider legal requirements (ADA, Section 508, EN 301 549)

### Design Phase

- Check color contrast in designs
- Design visible focus states
- Plan heading hierarchy
- Design for keyboard navigation
- Include error states and messages

### Development Phase

- Use semantic HTML
- Implement keyboard support
- Add ARIA where needed
- Test with automated tools
- Test with keyboard

### Testing Phase

- Run automated accessibility scans
- Perform manual keyboard testing
- Test with screen readers
- Test at various zoom levels
- Include users with disabilities if possible

---

## Resources

- WCAG 2.1 Guidelines (W3C standard)
- WAI-ARIA Authoring Practices (interaction patterns)
- A11y Project (community resources)
- WebAIM (articles and tools)
- Inclusive Components (pattern library)
