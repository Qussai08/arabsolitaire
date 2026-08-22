# Content Design System
## Arabic Solitaire Association Game

**Version:** 1.0  
**Status:** Decision-Aligned (Final Decision Register v1.1)  
**Source Documents:** Final Decision Register v1.1 + Approved GDD v1.0 + Full Product Scope v1.0 + MVP Scope v1.0 + Game Economy Design v1.0 + Progression Design v1.0 (`docs/Progression_Design_Arabic_Solitaire_Association_v1.0.md`) + Screen Inventory & User Flows v1.0  
**Important:** Register-approved content rules are **CONFIRMED**. New taxonomy, scoring scale, workflow threshold, naming convention, or operational rule not closed by the Register remains **PROPOSED**. Explicitly deferred items are **Post-MVP**. Open items remain **STILL TBD**.

---

# 1. Purpose

This document defines the complete content system for the Arabic Solitaire Association game.

The Content Design System governs:

- How Associations are defined.
- How Member Cards are created.
- How Arabic clues are written.
- How relation types are classified.
- How semantic difficulty is measured.
- How ambiguity is controlled.
- How content is reused safely.
- How dialect content is separated.
- How visual content is authored.
- How AI assists content generation.
- How human validation works.
- How content enters the Main Journey, Events, and Packs.
- How content quality is measured after release.

The objective is to make content scalable enough for an Endless game while keeping puzzles fair, linguistically strong, culturally appropriate, and distinctly Arabic-first.

---

# 2. Content Design Principles

## 2.1 Arabic First

**CONFIRMED** — Final Decision Register v1.1 §1

Content is designed for Arabic from the beginning.

**Language:** simplified modern Arabic with controlled dialect influence.

It must not feel like translated English puzzle content.

Arabic-specific opportunities include:

- Multiple meanings.
- Roots.
- Word families.
- Diacritics.
- Prefix/suffix behavior.
- Common expressions.
- Idioms.
- Letters.
- Synonyms.
- Antonyms.
- Singular/plural relationships.
- Dialect differences.
- Arabicized foreign terms.

## 2.2 Fair Before Clever

A puzzle may be difficult, indirect, or ambiguous.

It must not be arbitrary.

The player should be able to understand the intended relation after solving it, even if they did not immediately see it before.

## 2.3 Short Clue, Rich Relation

**CONFIRMED**

The Association Card displays a concise text clue, typically one or two words where possible.

The full intended relation is stored internally.

Example:

Visible clue:
`البحر الأحمر`

Internal relation:
`دول تطل على البحر الأحمر`

## 2.4 Endless Does Not Mean Repetitive

The system must support:

- Reuse of familiar concepts.
- New Member sets.
- Different relation interpretations.
- Different difficulty levels.
- Different content types.

The same clue may return in a new conceptual form.

## 2.5 Human Approval Is Mandatory

**CONFIRMED**

AI may generate candidate content.

AI does not publish directly to production.

Every production puzzle must pass human validation.

---

# 3. Core Content Entities

The Content System should conceptually separate the following entities.

## 3.1 Clue

The short text shown on the Association Card.

Example:

`مصر`

## 3.2 Relation

The internal description of the intended association.

Example:

`مدن مصرية`

or:

`أكلات مرتبطة بمصر`

## 3.3 Member

A card item belonging to a Relation.

Example:

`القاهرة`

## 3.4 Association Definition

A complete usable puzzle unit consisting of:

- Clue.
- Relation.
- Member Pool.
- Content Type.
- Difficulty metadata.
- Review status.

## 3.5 Association Variant

A selected subset of Members used in a particular level.

Example:

Association Definition:
`فواكه`

Member Pool:
20 approved fruit names.

Variant A:
`تفاح، موز، عنب`

Variant B:
`رمان، كيوي، جوافة، أناناس`

Variant C:
`ليتشي، بابايا، كاكا، فاكهة التنين`

---

# 4. Content Type Model

**CONFIRMED**

Member Cards may be:

- Text.
- Number.
- Symbol.
- Emoji.
- Illustration/Icon.

Text remains the dominant type.

## 4.1 Association Card Type

**CONFIRMED**

Association Cards are always textual clues.

Even when Members are:

- Emoji.
- Icons.
- Numbers.
- Symbols.

---

# 5. Association Homogeneity

**CONFIRMED**

Each Association uses one Member Content Type only.

Valid:

- Text Association.
- Emoji Association.
- Illustration Association.
- Number Association.

Invalid:

- Text + Image + Emoji inside the same Association.

A single level may contain multiple Associations of different types.

---

# 6. Relation Type Taxonomy

The Content System should classify each Relation.

## 6.1 Semantic Category

Examples:

- فواكه.
- حيوانات.
- عواصم.
- أدوات.

## 6.2 Shared Property

Examples:

Clue:
`أجنحة`

Relation:
`أشياء لها أجنحة`

## 6.3 Context / Place

Examples:

Clue:
`مطار`

Relation:
`أشياء توجد في المطار`

## 6.4 Geography

Examples:

Clue:
`البحر الأحمر`

Relation:
`دول تطل على البحر الأحمر`

## 6.5 Person / Place Association

Examples:

Clue:
`مصر`

Relation:
`مدن مصرية`

## 6.6 Language Pattern

Examples:

Clue:
`ض`

Relation:
`كلمات تبدأ بحرف الضاد`

## 6.7 Prefix

Example:

Clue:
`أبو`

Relation:
`كلمات أو أسماء شائعة تبدأ بأبو`

## 6.8 Suffix

Example:

Words sharing a specific ending.

## 6.9 Common Phrase

Relation formed by expressions or collocations.

## 6.10 Synonyms

Members share similar meaning.

## 6.11 Antonyms

Members relate through opposites.

## 6.12 Root / Word Family

Arabic words derived from a common root.

## 6.13 Singular / Plural

Member relations based on number forms.

## 6.14 Numeric Relation

Examples based on:

- Counts.
- Dates.
- Mathematical properties.
- Common numeric associations.

## 6.15 Symbol Relation

Examples involving:

- %
- @
- +
- ?
- Currency symbols.
- Common notation.

## 6.16 Visual Association

Members are illustrations/icons sharing a relation.

## 6.17 Cultural Relation

Stable cultural knowledge.

## 6.18 Historical Relation

Evergreen historical facts.

## 6.19 Scientific Relation

Stable science concepts.

## 6.20 Wordplay

More playful language-based association.

**CONFIRMED:** Wordplay is supported, especially in later progression.

---

# 7. Proposed Relation Complexity Tiers

**PROPOSED**

A useful internal scale:

### R1 — Direct
Obvious classification.

Example:
`فواكه`

### R2 — Contextual
Common shared place/context.

Example:
`مطار`

### R3 — Property-Based
Shared attribute.

Example:
`أجنحة`

### R4 — Indirect Semantic
Clue requires inference.

Example:
`البحر الأحمر`

### R5 — Linguistic
Letter/prefix/suffix/root structure.

### R6 — Wordplay
Requires phrase construction or layered language reasoning.

### R7 — Ambiguous / Advanced
Multiple plausible semantic interpretations.

This is an editorial tool, not a player-facing system.

---

# 8. Clue Design Rules

## 8.1 Concision

**CONFIRMED**

Prefer one or two words where possible.

Good:
`مطار`

Instead of:
`أشياء يمكن أن تجدها في المطار`

## 8.2 Fairness

The clue must be broad enough to require discovery but not so broad that it becomes arbitrary.

## 8.3 Natural Arabic

Avoid overly literal or translated wording.

Use expressions natural to Arabic speakers.

## 8.4 No Hidden Trivia Dependency Unless Intentional

A clue should not require specialist knowledge unless the puzzle is explicitly classified at a higher difficulty.

## 8.5 Avoid Over-Specific Clues

A clue that reveals the exact relation removes the association-discovery challenge.

## 8.6 Avoid Over-Vague Clues

Bad example:
`أشياء`

Too broad to be meaningful.

---

# 9. Clue Reuse

**CONFIRMED**

The same clue may be used with different Relations.

Example:

Clue:
`مصر`

Possible Relations:

- مدن مصرية.
- أكلات مصرية.
- معالم مصرية.
- شخصيات تاريخية مصرية.

The Content Library therefore must not treat clue text as a unique Relation identifier.

---

# 10. Member Reuse

**CONFIRMED**

The same Member concept may belong to multiple Relations globally.

Example:

`عين`

may participate in different Relations.

Within a specific level:

- The card instance has one target Association.
- Duplicate identical cards with different targets are not currently intended.

---

# 11. Content Pool Design

Each reusable Association should preferably maintain a Member Pool larger than the immediate group size.

Example:

Association:
`فواكه`

Pool:
20+ approved Members.

The generator can then select:

- Easy subsets.
- Medium subsets.
- Hard subsets.

This supports Endless reuse without exact repetition.

---

# 12. Member Difficulty

Each Member should be individually rateable.

## Proposed Difficulty Scale

**PROPOSED**

### M1 — Very Common
Known by almost all target users.

### M2 — Common
Widely familiar.

### M3 — Moderate
Requires some general knowledge.

### M4 — Uncommon
Less frequently used or known.

### M5 — Specialist / Rare
Should be used sparingly and intentionally.

Association difficulty can be partially derived from Member difficulty distribution.

---

# 13. Semantic Difficulty

**CONFIRMED**

Semantic Difficulty is separate from Board Difficulty.

Potential inputs:

- Clue directness.
- Member familiarity.
- Relation type.
- Ambiguity.
- Knowledge requirement.
- Wordplay.
- Similar competing Associations in the same level.

## Proposed 5-Level Semantic Scale

**PROPOSED**

### S1 — Easy
Direct, familiar, low ambiguity.

### S2 — Easy/Medium
Still obvious but less trivial.

### S3 — Medium
Requires interpretation.

### S4 — Hard
Indirect, ambiguous, or linguistically richer.

### S5 — Expert
Advanced wordplay or semantic ambiguity.

---

# 14. Association Difficulty Formula

**PROPOSED**

An internal Association score may combine:

- Clue complexity.
- Average Member familiarity.
- Relation-type complexity.
- Ambiguity.
- Cultural knowledge requirement.
- Wordplay depth.

Example conceptual formula:

`Association Difficulty =`
`Clue Complexity`
`+ Member Difficulty`
`+ Relation Complexity`
`+ Ambiguity Weight`

The exact formula belongs to Difficulty Model.

---

# 15. Semantic Ambiguity

**CONFIRMED**

Intentional ambiguity appears in advanced progression only.

Rules:

1. One card instance still has one correct target.
2. Competing interpretation must be plausible.
3. Intended solution must remain inferable.
4. Ambiguity must be human-reviewed.
5. Ambiguity must be tagged in metadata.

---

# 16. Ambiguity Types

## 16.1 Cross-Association Ambiguity

A Member appears plausible for another visible Association.

## 16.2 Clue Ambiguity

The clue itself supports multiple possible Relations.

## 16.3 Lexical Ambiguity

A word has multiple meanings.

## 16.4 Cultural Ambiguity

Different Arabic regions may interpret the word differently.

Cultural ambiguity should be avoided in Main Journey unless broadly understandable.

---

# 17. Main Journey Content Policy

**CONFIRMED**

Main Journey should prioritize:

- Evergreen content.
- Broad Arab-world comprehensibility.
- Mixed subject matter.
- Arabic-first linguistic quality.
- Stable knowledge.

Avoid relying heavily on:

- Current celebrities.
- Current trends.
- Brands.
- Time-sensitive facts.

These belong primarily in Events/Packs.

---

# 18. Contemporary Content Policy

**CONFIRMED**

Time-sensitive content belongs mainly in:

- Temporary Events.
- Permanent special packs where appropriate.

Examples:

- Current tournaments.
- Trending media.
- Contemporary celebrities.
- Current technology brands.
- Seasonal content.

Such content should have expiration/review metadata.

---

# 19. Dialect Content Policy

**CONFIRMED** — Final Decision Register v1.1 §1

Main Journey uses:

- Simplified modern Arabic with controlled dialect influence.
- Widely understood colloquial terms only when broadly recognizable.

Strong local dialect terms belong in:

- Dialect Packs (**Post-MVP**).
- Special Events (**Post-MVP** / post-launch).
- Regional Challenges (**Post-MVP**).

---

# 20. Dialect Metadata

Each Member or Association may optionally include:

- Region.
- Dialect family.
- Country.
- Comprehensibility level.
- Standard-Arabic equivalent.
- Notes for reviewers.

Examples:

- Egyptian.
- Saudi.
- Gulf.
- Levantine.
- Maghrebi.

---

# 21. Arabic Diacritics

**CONFIRMED**

Default:
No diacritics.

Use diacritics only when needed to disambiguate meaning.

Examples:

- عَلَم
- عِلْم

Editorial rule:

Do not over-diacritize ordinary cards.

---

# 22. Arabic Orthography

The Content Guidelines should normalize:

- Hamza forms.
- Alef variants.
- Ya / Alif Maqsura.
- Ta Marbuta.
- Common spelling variants.
- Arabic punctuation.
- Arabic vs Western digits where applicable.

Exact orthographic normalization rules are **PROPOSED** and should be documented in a dedicated Arabic Language Style Guide.

---

# 23. Foreign Terms

**CONFIRMED**

Display the form most familiar to Arabic users.

Examples may be:

- جوجل
- iPhone
- Netflix

depending on usage norms.

The system may store aliases for:

- Search.
- Deduplication.
- Validation.

---

# 24. Alias System

**PROPOSED**

Each Member may contain:

- Primary display form.
- Alternative Arabic spelling.
- English/original name.
- Common transliteration.
- Regional alias.

Aliases are not necessarily shown to the player.

They assist:

- Search.
- Duplicate detection.
- Content QA.
- AI generation.

---

# 25. Text Length Rules

**PROPOSED**

Member Cards should favor concise display text.

Suggested limits:

- Preferred: 1–2 words.
- Allowed: short phrase when needed.
- Avoid full sentences.

Association Clues:

- Preferred: 1–2 words.
- Longer only when necessary for fairness.

Exact character limits should be determined from UI card testing.

---

# 26. Number Content

Number Cards may represent:

- Counts.
- Years.
- Quantities.
- Scores.
- Mathematical properties.
- Common associations.

Rules:

- Relation must be understandable.
- Avoid arbitrary number trivia.
- Ensure formatting works across Arabic locales.

---

# 27. Symbol Content

Symbols may include:

- Mathematical signs.
- Currency symbols.
- Digital symbols.
- Punctuation.
- Common interface symbols.

Use only when:

- The symbol is broadly recognizable.
- The relation is fair.
- The symbol displays consistently across supported devices.

---

# 28. Emoji Content

Emoji Associations are supported.

Rules:

- Every Member in one Association must be Emoji.
- Avoid platform-variant Emoji whose meaning changes materially.
- Avoid obscure Emoji.
- Use human review across iOS/Android rendering where possible.

---

# 29. Illustration/Icon Content

**CONFIRMED**

Visual Member Cards use:

- Illustrations.
- Icons.

Not real photos.

Rules:

- No text label.
- Clear object identity.
- Consistent style.
- No intentional visual ambiguity.
- Association Card remains text.

---

# 30. Illustration Quality Criteria

Each visual asset should pass:

- Recognizability.
- Cultural neutrality where appropriate.
- Correct object representation.
- Appropriate detail at card size.
- Consistent visual style.
- No embedded text unless explicitly required.
- No confusing similarity to another Member in the same level.

---

# 31. People in Main Journey

**CONFIRMED**

Permitted in Main Journey:

- Historical figures.
- Scientific figures.
- Educational figures.

Avoid as standard Main Journey content:

- Current celebrities.
- Contemporary influencers.
- Current political figures unless explicitly approved.

---

# 32. Brands

**CONFIRMED**

Brands and current commercial entities should generally remain outside the standard Main Journey.

They may be considered in Events/Packs subject to:

- Relevance.
- Rights/trademark review.
- Longevity.

---

# 33. Cultural Content

Main Journey cultural content should favor concepts broadly recognizable across Arab markets.

Examples:

- Food.
- Geography.
- History.
- Literature.
- Science.
- Everyday life.
- General culture.

Avoid making Main Journey overly country-specific.

---

# 34. Sensitive Content

**PROPOSED**

Avoid content that depends on:

- Sectarian identity.
- Highly divisive politics.
- Explicit sexual material.
- Graphic violence.
- Hate-related language.
- Offensive stereotypes.

If a topic is educationally valid but potentially sensitive, require enhanced review.

---

# 35. Content Fairness Checklist

Every Association should answer YES to:

1. Is the relation real and defensible?
2. Is the clue fair?
3. Are all Members correct?
4. Are Members reasonably distinguishable?
5. Is there one intended target per card instance?
6. Is ambiguity intentional?
7. Is Arabic wording natural?
8. Is the knowledge level appropriate?
9. Is the content culturally acceptable?
10. Would a player understand the relation after seeing the solution?

---

# 36. Content Quality Levels

**PROPOSED**

### Q1 — Draft
AI/author candidate.

### Q2 — Language Reviewed
Arabic wording checked.

### Q3 — Semantic Reviewed
Relation correctness confirmed.

### Q4 — Game Reviewed
Difficulty/fairness checked.

### Q5 — Production Approved
Ready for publishing.

This can map to CMS workflow states.

---

# 37. AI-Assisted Content Generation

**CONFIRMED**

AI is used as an assistant, not publisher.

AI may generate:

- Relation ideas.
- Clue suggestions.
- Member pools.
- Difficulty suggestions.
- Ambiguity candidates.
- Alternative wording.
- Duplicate warnings.

---

# 38. AI Generation Prompt Inputs

**PROPOSED**

Generation requests should specify:

- Language: Arabic.
- Target relation type.
- Difficulty target.
- Main Journey vs Event/Pack.
- Content type.
- Region restrictions.
- Evergreen requirement.
- Avoided topics.
- Desired Member Pool size.
- Clue length preference.

---

# 39. AI Output Requirements

AI-generated candidate content should include:

- Proposed clue.
- Full relation.
- Member list.
- Relation type.
- Suggested difficulty.
- Potential ambiguity.
- Confidence.
- Notes.

AI confidence is not a substitute for review.

---

# 40. Human Review Workflow

**CONFIRMED concept**

Recommended review stages:

1. Author/AI candidate creation.
2. Arabic language review.
3. Semantic correctness review.
4. Duplicate search.
5. Difficulty review.
6. Ambiguity review.
7. Cultural review where needed.
8. Final approval.
9. Publish.

---

# 41. Language Review

Check:

- Grammar.
- Spelling.
- Natural phrasing.
- Diacritics where required.
- Common usage.
- Foreign-term display.
- Regional neutrality.

---

# 42. Semantic Review

Check:

- Relation validity.
- Member correctness.
- No weak outlier.
- Clue relation.
- No arbitrary grouping.
- No accidental second relation dominating the intended one.

---

# 43. Duplicate Review

Detect:

- Exact duplicate clue + relation + members.
- Same relation with near-identical Member set.
- Same clue repeated too frequently.
- Near-duplicate wording.
- Member set overlap.

---

# 44. Difficulty Review

Reviewers should assign:

- Member familiarity.
- Clue directness.
- Relation complexity.
- Ambiguity.
- Overall semantic difficulty.

Difficulty should be validated later against player analytics.

---

# 45. Cultural Review

For potentially regional/cultural content:

Check:

- Cross-Arab comprehensibility.
- Regional wording.
- Offensive interpretation.
- Country-specific assumptions.
- Whether the item should move to a Dialect Pack.

---

# 46. Content Status Lifecycle

**PROPOSED**

Suggested statuses:

- Draft.
- Needs Review.
- Language Approved.
- Semantic Approved.
- Game Approved.
- Production Approved.
- Active.
- Deprecated.
- Disabled.
- Archived.

The exact workflow may be simplified in MVP CMS.

---

# 47. Content Versioning

Each Association should support version history for:

- Clue text.
- Relation text.
- Member Pool.
- Difficulty.
- Metadata.
- Active state.

Published content changes should be auditable.

---

# 48. Deactivation

Operational users must be able to disable problematic content.

Reasons may include:

- Wrong relation.
- Offensive interpretation.
- Duplicate.
- Outdated.
- Visual asset issue.
- Player complaints.

Deactivation should not require deleting historical analytics.

---

# 49. Reuse Strategy

**CONFIRMED**

Association concepts may return with different Member sets.

Recommended reuse dimensions:

- New Member subset.
- Higher semantic difficulty.
- Different clue interpretation.
- Different relation type.
- Different content type where conceptually valid.

---

# 50. Reuse Cooldown

**CONFIRMED** — Final Decision Register v1.1 §3 / Progression Design v1.0

- Same Association Clue reuse cooldown: **at least 20 Levels**.
- Exact same Variant cannot repeat inside the same Chapter.

The Content Engine should enforce these constraints during Main Journey selection. Additional configurable near-duplicate safeguards may remain editorial tooling (**PROPOSED** thresholds only).

---

# 51. Member Pool Depth

**PROPOSED**

Recommended target sizes:

### Common Association
8–20+ approved Members.

### Narrow Association
Minimum enough Members for multiple variants where possible.

### One-Off Relation
May have only one fixed set if conceptually necessary.

Larger pools improve Endless scalability.

---

# 52. Association Variant Generation

A Variant should specify:

- Selected Members.
- Group size.
- Target semantic difficulty.
- Association clue.
- Relation.
- Content type.

Variants may be:

- Hand-selected.
- AI-assisted.
- Algorithmically selected from approved pools.

All Members themselves must already be approved.

---

# 53. Group Size Content Rules

**CONFIRMED** — Final Decision Register v1.1 §3 / Progression Design v1.0

Groups may contain:

- 3 Members (introduced first).
- 4 Members (become standard).
- 5 Members / mixed sizes (introduced later).

Content review must ensure the selected clue remains fair at each group size.

---

# 54. Multi-Association Level Content Design

When selecting several Associations for one level, the system should evaluate:

- Semantic overlap.
- Clue overlap.
- Member overlap.
- Ambiguity.
- Difficulty mix.
- Content-type mix.

---

# 55. Cross-Association Conflict Detection

**PROPOSED**

Before approving a level content set, detect:

1. Same Member appearing in two Associations.
2. Same visible clue duplicated unintentionally.
3. Members strongly matching multiple Associations.
4. Two Associations whose relations are too similar.
5. Visual assets that look too similar.

Some conflicts may be allowed intentionally in advanced levels.

---

# 56. Controlled Ambiguity Metadata

Associations or Members should support:

- `ambiguity_allowed`
- `ambiguity_type`
- `competing_relation`
- `review_notes`

Exact schema belongs to Data Model.

---

# 57. Main Journey Content Mix

**CONFIRMED:** Main Journey is mixed-topic.

**PROPOSED**

Recommended content-category balancing can include:

- Everyday life.
- Nature.
- Animals.
- Food.
- Geography.
- Science.
- Language.
- History.
- Culture.
- Technology.
- Sports (evergreen).
- Arts/literature.
- Numbers/symbols.

No category should dominate for too long.

---

# 58. Topic Distribution Controls

**PROPOSED**

The generator may use configurable category weights.

Example conceptual weighting:

- 25% everyday/general.
- 15% language.
- 10% geography.
- 10% science.
- 10% nature/animals.
- 10% food.
- 10% culture/history.
- 10% mixed other.

These values are illustrative only and not approved.

---

# 59. Content Difficulty Mix Per Level

**PROPOSED**

A level does not need every Association at the same Semantic Difficulty.

Example:

- 2 easy Associations.
- 1 medium.
- 1 hard.

This can create discovery momentum.

The Difficulty Model should define target distributions.

---

# 60. Relief Content

Difficulty Waves need semantic relief.

Relief levels may use:

- Direct clues.
- Familiar Members.
- Common relation types.
- Low ambiguity.

Relief content is still curated and engaging.

---

# 61. Peak Content

Peak semantic levels may use:

- Indirect clues.
- Harder Members.
- Arabic wordplay.
- Linguistic patterns.
- Controlled ambiguity.

Peak content requires stronger review.

---

# 62. Onboarding Content

Tutorial and early levels should prioritize:

- Obvious categories.
- Common vocabulary.
- Short clues.
- No intentional ambiguity.
- Low cultural specificity.

The purpose is to teach mechanics, not test knowledge.

---

# 63. Mid-Progression Content

May add:

- Contextual clues.
- Shared properties.
- More varied vocabulary.
- Basic number/symbol relations.
- Simple language patterns.

---

# 64. Advanced Content

May add:

- Wordplay.
- Roots.
- Prefix/suffix.
- Multi-meaning words.
- More abstract clues.
- Stronger ambiguity.
- Mixed relation types.

---

# 65. Visual Content Progression

**CONFIRMED** — Final Decision Register v1.1 §3 / Progression Design v1.0

- Text remains the dominant content type.
- Early/mid Levels: max one visual Association per Level.
- Illustration content is introduced gradually after tutorial/early Levels.

Visual content should not appear before the player understands the basic Association mechanic.

Suggested supporting sequence for non-text types (editorial pacing; exact Level indices remain tuning **STILL TBD**):

1. Text.
2. Numbers/Symbols.
3. Emoji.
4. Illustration/Icon.

Exact unlock timing details beyond the Register rules belong to Progression Design.

---

# 66. Dialect Pack Design

Each Dialect Pack should define:

- Target dialect.
- Standard Arabic support notes.
- Regional reviewer.
- Allowed slang depth.
- Cultural context.
- Difficulty.

Examples:

- Egyptian.
- Gulf.
- Levantine.
- Maghrebi.

Dialect Packs may intentionally use words unfamiliar outside the target region because the player opted into that Pack.

---

# 67. Event Content Design

Temporary Events may use:

- Seasonal themes.
- Current sports.
- Entertainment.
- Holidays.
- Cultural moments.

Event content should include:

- Start/end dates.
- Review expiry.
- Rights/trademark considerations.
- Content retirement plan.

---

# 68. Evergreen Classification

**PROPOSED**

Each Association should be tagged:

- Evergreen.
- Semi-evergreen.
- Contemporary.
- Seasonal.

Main Journey selection should favor Evergreen.

---

# 69. Expiry Review

Contemporary content should include:

- Review date.
- Expiry date where appropriate.
- Replacement plan.
- Event/Permanent classification.

This prevents stale facts.

---

# 70. Content Search and Discovery in CMS

CMS should allow filtering by:

- Clue.
- Relation.
- Member.
- Relation type.
- Semantic difficulty.
- Content type.
- Topic.
- Dialect.
- Region.
- Review status.
- Active status.
- Evergreen classification.

---

# 71. Duplicate Detection Strategy

**PROPOSED**

Use multiple checks:

- Exact text match.
- Normalized Arabic match.
- Alias match.
- Semantic similarity.
- Member-set overlap.
- Clue + relation similarity.

AI/embedding-based similarity may assist but should not auto-delete content.

---

# 72. Arabic Normalization for Search

**PROPOSED**

Internal search normalization may ignore:

- Diacritics.
- Some Alef variants.
- Tatweel.
- Case-insensitive Latin text.

But the stored approved display text remains unchanged.

---

# 73. Content IDs

Content must use stable identifiers independent from display text.

Example conceptual IDs:

- `clue_id`
- `relation_id`
- `member_id`
- `association_variant_id`

Changing Arabic wording must not break historical analytics.

---

# 74. Analytics Metadata

Every Association exposure should be traceable by:

- Association ID.
- Variant ID.
- Relation type.
- Semantic difficulty.
- Content type.
- Topic.
- Level.
- Chapter.

This enables content-quality analysis.

---

# 75. Content Analytics

Recommended metrics:

- Association completion rate.
- Wrong placement attempts.
- Hint usage associated with the Association.
- Restart correlation.
- Dead-end correlation.
- Time to complete.
- Player reports.
- Difficulty prediction vs actual behavior.

---

# 76. Semantic Difficulty Calibration

After launch, compare:

`Predicted Semantic Difficulty`

against:

- Completion time.
- Wrong attempts.
- Hint usage.
- Restart rate.

Content difficulty labels should evolve based on data.

---

# 77. Content Quality KPIs

Track:

- Content rejection rate.
- Review turnaround.
- Duplicate rate.
- Player complaint rate.
- Disabled-content rate.
- Average Member Pool size.
- Reuse efficiency.
- Content production velocity.
- AI candidate acceptance rate.

---

# 78. Player Reporting

**CONFIRMED** — Final Decision Register v1.1 §8

Main Journey includes a simple **Report a problem** action from launch.

Possible report reasons:

- Wrong relation.
- Offensive content.
- Spelling issue.
- Image unclear.
- Duplicate.
- Too ambiguous.

Reports should include content IDs automatically.

Publisher/Admin can immediately disable problematic content without app release.

---

# 79. Content Governance

Recommended roles:

**PROPOSED**

- Content Author.
- Arabic Language Reviewer.
- Semantic Reviewer.
- Game Designer.
- Final Approver.
- Admin.

Small teams may combine roles, but approval responsibility should remain explicit.

---

# 80. Approval Rules

**PROPOSED**

No production content should be approved by the same automated process that generated it.

At least one human reviewer is mandatory.

Higher-risk content may require two reviewers.

---

# 81. Editorial Notes

Each Association may include internal notes for:

- Intended interpretation.
- Potential ambiguity.
- Regional nuance.
- Diacritic rationale.
- Why a Member belongs.
- Known false associations.

Useful for future maintenance.

---

# 82. Explanation Text

**CONFIRMED gameplay behavior**

The full relation is not shown when an Association completes.

It may remain internal only.

No automatic educational explanation popup is required.

---

# 83. Content Localization Readiness

Arabic is primary.

The Content Model should still separate:

- Concept.
- Relation.
- Display text.

This allows future localization without rewriting core IDs.

No non-Arabic launch language is currently required.

---

# 84. Main Journey Safety Rules

Do not place in Main Journey without explicit approval:

- Rapidly changing facts.
- Highly local slang.
- Contemporary celebrities.
- Brand-heavy content.
- Politically sensitive categorization.
- Subjective stereotypes.
- Ambiguous regional labels.

---

# 85. Content Production Pipeline

Recommended end-to-end pipeline:

`Content Brief`
→ `AI/Author Generation`
→ `Normalization`
→ `Language Review`
→ `Semantic Review`
→ `Duplicate Detection`
→ `Difficulty Rating`
→ `Ambiguity Review`
→ `Cultural Review`
→ `Member Pool Approval`
→ `Variant Generation`
→ `Level Compatibility Check`
→ `Final Approval`
→ `Publish`
→ `Analytics Monitoring`

---

# 86. MVP Content Scope

Based on the MVP Scope:

## P0

- Text content.
- Numbers.
- Symbols.
- Arabic-first clues (simplified modern Arabic with controlled dialect influence).
- Structured Content Library.
- Human review.
- Semantic Difficulty.
- Relation Type.
- Evergreen classification.
- Content activation/deactivation.
- Basic duplicate detection.
- Basic CMS workflow.
- Hybrid content delivery.
- Reuse cooldown / Chapter Variant uniqueness enforcement.
- Main Journey Report a problem.

## P1

- Emoji Associations.
- Illustration/Icon Associations.
- Richer AI-assisted authoring tools.

## Post-MVP

- Dialect Packs.
- Event-specific content.
- Advanced AI Content Studio.
- More advanced localization.

Player reporting is **P0 / launch** (see §78), not Post-MVP.

---

# 87. MVP Content Volume

**CONFIRMED** — Final Decision Register v1.1 §3 / Progression Design v1.0

Launch Main Journey content:

- 5 Chapters.
- 250 Level Definitions.

The exact number of unique Associations required depends on:

- Reuse policy (Clue cooldown ≥20 Levels; no exact Variant repeat in same Chapter).
- Average Associations per level.
- Member Pool depth.
- Difficulty variants.

A dedicated Content Production Plan should calculate actual required Association/Variant counts after Level Design Framework assembly rules are applied.

---

# 88. Content Capacity Planning

A future calculation should estimate:

`Unique Associations Needed`
=
`Levels × Average Associations`
adjusted for:
- Reuse rate.
- Variant count.
- Cooldown.
- Difficulty coverage.

Do not commit to content production volume before this model exists.

---

# 89. Content Review SLAs

**PROPOSED**

Operational content production may define:

- Draft-to-review target.
- Review turnaround.
- Rejected-content feedback time.
- Emergency deactivation time.

Exact SLAs depend on team structure.

---

# 90. Content Version Release Strategy

**CONFIRMED** — Final Decision Register v1.1 §8

Hybrid content delivery:

- Bundled base content.
- Remote versioned content bundles hosted via **Firebase Storage** (or
  another Firebase/GCP-native static delivery mechanism when justified).
- No separate paid CDN layer for MVP unless measurements demonstrate a need.

Content activation:

- Download.
- Validate hash.
- Validate schema.
- Validate rules compatibility.
- Atomic activation.

Keep last-known-valid bundle for rollback.

---

# 91. Content Integrity

Published content should be immutable by ID/version.

Edits create a new version.

This protects:

- Saved levels.
- Analytics.
- Debugging.
- Reproduction of issues.

---

# 92. Content and Solver Interaction

Content itself does not determine Board solvability.

However, content affects:

- Semantic difficulty.
- Hint interpretation.
- Wrong move patterns.

The Solver operates on game-state rules and Association membership.

The content system supplies:

- Which Member belongs to which Association.
- Group size.
- IDs.

---

# 93. Content and Level Generator Interaction

The Level Generator should request content based on constraints such as:

- Number of Associations.
- Group sizes.
- Semantic Difficulty range.
- Relation-type mix.
- Topic mix.
- Content-type mix.
- Ambiguity allowance.
- Reuse cooldown.

The Content Engine returns eligible Association Variants.

---

# 94. Content Selection Constraints

**PROPOSED**

A generated level should be rejected before board generation if:

- Duplicate identical Member appears across Associations unintentionally.
- Clues are duplicated unintentionally.
- Relation overlap is too high.
- Content-type distribution violates requested profile.
- Semantic Difficulty is outside target.
- Required Member count cannot be fulfilled.

---

# 95. Content Diversity Score

**PROPOSED**

The generator may calculate a diversity score using:

- Topic variety.
- Relation-type variety.
- Clue repetition.
- Member repetition.
- Content-type variety.

This helps prevent repetitive level sequences.

---

# 96. Content Decision Register — Confirmed

The following are **CONFIRMED** (including Final Decision Register v1.1):

1. Arabic-first content.
2. Simplified modern Arabic with controlled dialect influence in Main Journey.
3. Dialect content uses a hybrid strategy.
4. Strong dialect content belongs primarily in Packs/Events (**Post-MVP**).
5. Text is the dominant Member type.
6. Number, Symbol, Emoji, Illustration/Icon Members are supported.
7. Association Card is always text.
8. Each Association uses one Member content type.
9. A level may mix Association content types.
10. Illustrations/Icons are allowed; real photos are not.
11. Illustration Cards have no text label.
12. Illustrations should be clear, not intentionally ambiguous.
13. Historical/scientific figures may appear in Main Journey.
14. Contemporary celebrities/brands are outside normal Main Journey.
15. Main Journey is Evergreen-focused.
16. Contemporary content belongs primarily in Events/Packs.
17. Same Association concept may reappear with different Member sets.
18. Same Member may belong to multiple global Relations.
19. Each card instance has one target Association.
20. Same clue may represent different Relations.
21. Clue should be concise, often one or two words.
22. Full Relation is stored internally.
23. Multi-type Relations are supported.
24. Diacritics are used only when needed.
25. Foreign terms use the form familiar to Arabic users.
26. Semantic Ambiguity appears in advanced progression only.
27. AI-assisted generation is allowed (Draft only).
28. Human Arabic + semantic validation is mandatory.
29. Completed Association does not show a relation explanation popup.
30. Association Clue reuse cooldown ≥ 20 Levels.
31. Exact same Variant cannot repeat in the same Chapter.
32. Group-size progression: 3 → 4 standard → 5/mixed later.
33. Early/mid: max one visual Association per Level; illustration gradual after tutorial/early.
34. Launch volume: 5 Chapters / 250 Level Definitions.
35. Hybrid bundled + remote versioned content delivery via Firebase Storage (validated atomic activation and rollback; no separate paid CDN unless measured need).
36. Main Journey **Report a problem** from launch; Admin can disable content without app release.

---

# 97. Content Decision Register — Proposed / Requires Approval

The following are **PROPOSED** or **STILL TBD**:

1. Relation complexity tiers R1–R7.
2. Member difficulty M1–M5.
3. Semantic difficulty S1–S5.
4. Content status lifecycle.
5. Member Pool target sizes.
6. Topic distribution weights.
7. Sensitive-content editorial policy.
8. Multi-role approval workflow.
9. Search normalization rules.
10. Duplicate-detection thresholds.
11. Diversity scoring.
12. Content review SLAs.
13. Exact unique Association production counts (volume of Levels is CONFIRMED).
14. Exact first-illustration Level index within the gradual window.

---

# 98. Recommended Next Content Deliverables

After aligning this Content Design System, create/update:

1. **Arabic Language Style Guide**
2. **Relation Type Catalogue**
3. **Semantic Difficulty Rubric**
4. **Content Metadata Schema**
5. **Content Review Checklist**
6. **AI Content Generation Prompt Specification**
7. **Content Production Plan**
8. **Content QA Plan**
9. **CMS Specification**
10. **Level Design Framework**

The highest-priority companions remain **Level Design Framework**, **Difficulty Model**, and **Progression Design** (`docs/Progression_Design_Arabic_Solitaire_Association_v1.0.md`).

---

# 99. Baseline Status

This document is **Content Design System v1.0**, decision-aligned to **Final Decision Register v1.1**.

It defines the editorial, structural, semantic, and operational framework for creating Arabic Solitaire Association content at scale.

Register-closed rules are **CONFIRMED**. New taxonomies, scoring scales, and workflow details not closed by the Register remain **PROPOSED** / **STILL TBD**.

**End of Content Design System v1.0**
