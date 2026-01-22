# Compaction Plan

Goal: Reduce protocol from ~50-60K tokens to ~25-35K tokens while retaining core information.

---

## 1. Remove Redundancy ✓

- [x] Identify concepts explained in multiple places
- [x] Replace repeated explanations with cross-references
- [x] Keep the most detailed explanation in one canonical location

## 2. Condense Prose ✓

- [x] Shorten "why" explanations to essential points
- [x] Remove obvious statements
- [x] Tighten paragraph structure

## 3. Shorter Examples ✓

- [x] Reduce "poor vs better" examples to minimal snippets
- [x] Remove redundant example variations
- [x] Keep one clear example per concept

## 4. Tables Over Prose ✓

- [x] Convert list-based explanations to tables where appropriate
- [x] Use tables for comparisons instead of paragraphs

## 5. Merge Documents ✓

Merged:

- [x] api-design.md + interface-contracts.md → api-contracts.md
- [x] unit-testing.md + integration-testing.md → testing-practices.md
- [x] Updated README files with new references

## 6. Condense "When to Violate" Sections ✓

- [x] Convert to brief inline notes or single bullet points
- [x] Remove if covered by decision-making.md

## 7. Consolidate Checklists

- [ ] Create single checklists.md reference document
- [ ] Replace embedded checklists with references
- [ ] Keep checklists in one place for easy access

## 8. Create Compact Variant (Optional)

- [ ] Create a `compact/` folder with condensed versions
- [ ] Target ~15-20K tokens for context-constrained use
- [ ] Maintain full version for reference

---

## Progress

Original: ~244K chars, ~34.5K words, ~50-60K tokens
Target: ~25-35K tokens

After step 1: 225,615 chars, 32,125 words (~7.5% reduction, ~47-55K tokens)
After step 2: 224,023 chars, 31,886 words (~8.2% total reduction)
After step 3: 223,068 chars, 31,698 words (~8.6% total reduction)
After step 4: 222,964 chars, 31,623 words (~8.6% total reduction)
After step 5: 209,776 chars, 29,680 words (~14.0% total reduction)
After step 6: 208,176 chars, 29,403 words (~14.7% total reduction)
