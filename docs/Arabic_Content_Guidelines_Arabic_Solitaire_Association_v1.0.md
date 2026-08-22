# Arabic Content Guidelines
## Arabic Solitaire Association Game

**Version:** 1.0  
**Status:** Decision-Aligned (Final Decision Register v1.1)  
**Source Documents:** Final Decision Register v1.1 + Approved GDD v1.0 + Full Product Scope v1.0 + MVP Scope v1.0 + Game Economy Design v1.0 + Progression Design v1.0 (`docs/Progression_Design_Arabic_Solitaire_Association_v1.0.md`) + Screen Inventory & User Flows v1.0 + Content Design System v1.0  
**Important:** Register-approved language/content decisions are **CONFIRMED**. New editorial conventions not closed by the Register remain **PROPOSED**. Explicitly deferred systems are **Post-MVP**. Open terminology/commercial items remain **STILL TBD**.

---

# 1. Purpose

This document defines how Arabic content should be written, normalized, reviewed, displayed, and validated across the game.

It covers:

- Modern Arabic usage.
- Simplified Modern Standard Arabic.
- Dialect handling.
- Word choice.
- Clue phrasing.
- Diacritics.
- Orthography.
- Hamza and Alef handling.
- Ya / Alif Maqsura.
- Ta Marbuta.
- Foreign terms.
- Proper nouns.
- Numbers.
- Symbols.
- Punctuation.
- Capitalization equivalents.
- Mixed Arabic/Latin text.
- Gender and plurality.
- Ambiguity.
- Cultural neutrality.
- Content-review expectations.
- Search normalization.
- Aliases.
- UI/card readability.

The objective is to make the game feel naturally Arabic rather than translated, while preserving fairness across the Arab world.

---

# 2. Core Arabic Language Strategy

## 2.1 Main Language

**CONFIRMED** — Final Decision Register v1.1 §1

The Main Journey uses:

**Simplified modern Arabic with controlled dialect influence**

The language should be:

- Natural.
- Clear.
- Modern.
- Broadly understandable.
- Concise enough for card-based gameplay.
- Allow controlled, broadly recognizable colloquial influence without becoming region-locked.

Avoid:

- Overly formal classical phrasing.
- Bureaucratic Arabic.
- Literal translation from English.
- Artificially “pure” Arabic where common usage clearly favors another form.
- Strong local dialect that fails cross-Arab comprehension.

---

# 3. Arabic Market Scope

**CONFIRMED**

The Main Journey targets Arabic speakers across the Arab world.

Therefore wording should prioritize:

- Cross-regional comprehension.
- Neutral Arabic.
- Common modern usage.

Strongly local expressions should generally move to:

- Dialect Packs.
- Special Events.
- Regional Challenges.

---

# 4. Tone of Voice

## 4.1 Gameplay Content

The tone should be:

- Direct.
- Smart.
- Neutral.
- Non-academic.
- Non-childish.

The game targets 13+ but must remain interesting for adults.

## 4.2 UI Copy

UI text should be:

- Short.
- Action-oriented.
- Conversational without becoming dialect-heavy.
- Consistent.

Examples:

Preferred:
- `متابعة`
- `إعادة`
- `تلميح`
- `المتجر`
- `نفدت الحركات`

Avoid overly formal equivalents when a simpler version is clearer.

---

# 5. Clue Writing Philosophy

**CONFIRMED**

The Association Card should usually display:

**One or two words**

when that remains fair.

The clue should point toward the relation without fully explaining it.

Example:

Internal relation:
`أشياء تجدها في المطار`

Visible clue:
`مطار`

Internal relation:
`دول تطل على البحر الأحمر`

Visible clue:
`البحر الأحمر`

---

# 6. Good Clue Characteristics

A good clue is:

- Short.
- Natural.
- Semantically meaningful.
- Broad enough to require discovery.
- Specific enough to remain fair.
- Understandable in Arabic without translation artifacts.

Examples:

Good:
- `أجنحة`
- `مطار`
- `الصحراء`
- `مصر`
- `ض`

Weak:
- `أشياء`
- `مجموعة`
- `أماكن وأشياء`
- `ما يلي`

---

# 7. Clue vs Full Relation

**CONFIRMED**

The player sees only the concise clue.

The system stores the full relation internally.

Example:

### Display
`مصر`

### Internal Relation
`معالم مصرية`

The full relation is used for:

- Review.
- QA.
- Difficulty classification.
- AI generation.
- Editorial maintenance.

It is not automatically shown on completion.

---

# 8. Word Choice

Prefer words that are:

- Familiar across markets.
- Natural in modern Arabic.
- Short enough for cards.
- Semantically precise.

Avoid:

- Obscure synonyms when a common equivalent exists.
- Region-specific terms in Main Journey.
- Words whose meaning depends entirely on a local dialect.
- Overly literary vocabulary in early progression.

---

# 9. Simplified Arabic

**CONFIRMED** direction: simplified modern Arabic with controlled dialect influence.

Use the simplest natural form that preserves meaning.

Preferred:
`سيارة`

Instead of unnecessarily formal or less common alternatives.

Preferred:
`هاتف`

when intended meaning is general.

Use:
`موبايل`

only if the content context intentionally relies on contemporary colloquial usage and the term is considered broadly understood.

Such cases should be reviewed.

---

# 10. Dialects

**CONFIRMED** — Final Decision Register v1.1 §1

The language model is hybrid: simplified modern Arabic with controlled dialect influence.

## Main Journey

Use:

- Simplified modern Arabic.
- Controlled dialect influence limited to broadly understood colloquial terms.

## Dialect Packs (**Post-MVP**)

May use:

- Egyptian.
- Gulf.
- Saudi.
- Levantine.
- Maghrebi.
- Other regional variants.

Dialect Pack content may intentionally test dialect knowledge because the player opted into the Pack.

---

# 11. Dialect Labeling

**PROPOSED**

Every dialect-specific entry should store metadata such as:

- Dialect family.
- Country/region.
- MSA equivalent.
- Common alternate spelling.
- Reviewer notes.

Example:

Display:
`عربية`

Dialect:
Egyptian

MSA equivalent:
`سيارة`

---

# 12. Diacritics

**CONFIRMED**

Default:
**Do not use full diacritics.**

Use diacritics only when necessary to disambiguate meaning.

Examples:

`عَلَم`
vs
`عِلْم`

Avoid decorating normal words with unnecessary tashkeel.

---

# 13. Partial Diacritics

**PROPOSED**

When only one or two marks are enough to clarify meaning, use minimal necessary diacritics.

Do not fully vocalize the whole word unless absolutely required.

Goal:
clarity without visual clutter.

---

# 14. Hamza

**PROPOSED**

Use standard modern Arabic spelling.

Examples:

- `أحمر`
- `إجابة`
- `مؤتمر`
- `مسؤول`

Avoid inconsistent spelling variants inside the same content set.

Search normalization may ignore certain Hamza variants internally, but display text should remain correct.

---

# 15. Alef Variants

**PROPOSED**

Display text should use the orthographically correct form:

- ا
- أ
- إ
- آ

Do not normalize all Alef forms visually.

Internal search/deduplication may normalize them.

---

# 16. Ya and Alif Maqsura

**PROPOSED**

Use correct Arabic spelling:

- `على`
- `إلى`
- `فتى`
- `علي`

Do not interchange `ى` and `ي` in display text.

Search normalization may tolerate variants.

---

# 17. Ta Marbuta and Ha

**PROPOSED**

Use:

- `ة` when grammatically correct.
- `ه` only when actually part of the word.

Example:
`سيارة`
not
`سياره`

Unless the content deliberately reflects dialect spelling inside a dialect-specific Pack.

---

# 18. Tatweel

**PROPOSED**

Do not use Arabic Tatweel:

`ـ`

inside normal card text.

It creates inconsistent layout and complicates search/normalization.

---

# 19. Punctuation

**PROPOSED**

Use Arabic punctuation where appropriate:

- `،`
- `؟`
- `؛`

However, card content should avoid punctuation unless it is part of the puzzle.

Examples of valid symbol-based cards may intentionally use:

- `؟`
- `!`
- `%`
- `@`

---

# 20. Quotation Marks

**PROPOSED**

Avoid quotation marks inside card text unless they are essential to the relation.

UI and explanatory content may use consistent Arabic-friendly quotation formatting.

---

# 21. Numbers

**CONFIRMED**

Numbers are valid card content.

## Proposed Display Policy

**PROPOSED**

Use the numeral system most familiar for the target context.

Possible forms:

- 7
- 24
- 2025

Avoid mixing Arabic-Indic and Western digits within the same puzzle unless intentional.

The final numeral policy should be tested across the target audience.

---

# 22. Percentages and Symbols

Symbols may appear as cards when they are part of the association.

Examples:

- `%`
- `+`
- `@`
- `#`

Ensure:

- Correct rendering.
- Sufficient size.
- Cross-platform consistency.

---

# 23. Latin Text

Latin text is allowed where that is the most natural form.

Examples may include:

- iPhone
- Netflix
- HTML
- GPS

Do not transliterate automatically when the original form is more familiar to users.

---

# 24. Foreign Terms

**CONFIRMED**

Use the form most familiar to Arabic users.

Examples:

Possible:
- `جوجل`
- `Google`

depending on context and common usage.

The Content Library may store:

- Primary display form.
- Arabic alias.
- Original-language alias.

---

# 25. Brand Names

**CONFIRMED**

Brands are generally outside the Main Journey.

If used in Event/Pack content:

- Use official/common brand spelling.
- Do not invent Arabic translations.
- Consider trademark/rights review.

---

# 26. Proper Nouns

Proper nouns should use:

- Widely accepted Arabic spelling.
- Commonly recognized transliteration.
- Consistent form across the game.

Examples:

Use the same approved form for a city/person every time unless the puzzle specifically depends on variant naming.

---

# 27. Geographic Names

Use widely recognized Arabic names.

Avoid politically sensitive or disputed naming choices unless explicitly reviewed.

Where naming varies regionally, use the form with the broadest neutral comprehension or move the content to a regional Pack.

---

# 28. Historical Names

Use the form most recognizable to the intended Arabic audience.

Where multiple forms exist, store aliases internally.

---

# 29. Person Names

For historical/scientific figures:

- Use common Arabic transliteration.
- Avoid overlong honorifics.
- Use the form players are likely to recognize.

Example:
`أينشتاين`

rather than a long formal full name unless required.

---

# 30. Titles and Honorifics

**PROPOSED**

Avoid:

- د.
- السيد
- الشيخ
- الملك

unless the title is semantically necessary.

Use the shortest recognizable name.

---

# 31. Gender

Arabic gender should be grammatically correct.

Avoid forcing masculine or feminine phrasing when the clue can remain neutral.

Examples:

Prefer noun-based clues where possible.

---

# 32. Singular and Plural

Relations may intentionally use:

- Singular/plural.
- Broken plural.
- Dual.

When not part of the puzzle, use the form most natural to the category.

Example:
`حيوانات`
rather than awkward singular category wording.

---

# 33. Definite Article

Use `الـ` when it makes the clue more natural.

Examples:

`البحر الأحمر`

Do not add or remove the definite article inconsistently across related clues.

---

# 34. Prepositions

Because clues are short, avoid unnecessary prepositions when a noun is sufficient.

Example:

Preferred:
`مطار`

Instead of:
`في المطار`

unless the relation specifically requires the phrase.

---

# 35. Verb Forms

Verb-based clues are allowed but should remain concise.

Prefer noun clues when possible because they fit cards better.

Example:

`يطير`

may be valid if the intended relation is action-based.

---

# 36. Roots

Arabic root-based associations are supported.

Examples may group words from one root.

Rules:

- Relation must be linguistically correct.
- Avoid disputed derivations.
- Require language review.
- Use in later progression where appropriate.

---

# 37. Prefix/Suffix

Arabic morphological relations may use:

- Prefixes.
- Suffixes.
- Common particles.

Examples:

Clue:
`أبو`

Members may form recognized names/phrases.

Ensure combinations are actually common and not artificially generated.

---

# 38. Letter-Based Associations

**CONFIRMED**

Letters may be used as clues.

Example:

`ض`

Possible relation:
words beginning with ض.

Rules:

- Use actual letter, not description.
- Ensure Member spelling is correct.
- Avoid controversial orthographic edge cases.

---

# 39. Rhyming / Sound-Based Content

**PROPOSED**

Phonetic associations may be used later.

Require caution because:

- Pronunciation differs by dialect.
- Some written forms do not reflect pronunciation consistently.

Prefer broadly stable pronunciation patterns.

---

# 40. Synonyms

Synonym Relations are allowed.

Avoid pretending near-synonyms are identical when nuance matters.

Human semantic review is required.

---

# 41. Antonyms

Antonym-based associations are allowed.

Ensure all Members follow the same relation logic.

---

# 42. Idioms and Expressions

Arabic expressions may be used.

Rules:

- Prefer widely recognized expressions in Main Journey.
- Local idioms belong in Dialect Packs.
- Avoid incomplete expressions that feel arbitrary.

---

# 43. Proverbs

**PROPOSED**

Proverb-based puzzles may be suitable for advanced content or special Packs.

Main Journey use should be limited to widely recognized proverbs.

---

# 44. Quranic / Religious Language

**PROPOSED — requires explicit approval before use**

Because religious text is sensitive and can create moderation/cultural risks, do not use sacred text or highly religious phrase completion in normal Main Journey unless specifically approved and reviewed.

General non-sensitive cultural/religious concepts may still require careful review.

---

# 45. Political Content

**PROPOSED**

Avoid current partisan/political associations in Main Journey.

Historical/geographic political content may be used only when stable, neutral, and appropriate.

---

# 46. Sensitive Cultural Topics

Avoid:

- Sectarian labeling.
- Ethnic stereotypes.
- National stereotypes.
- Gender stereotypes.
- Insult-based associations.
- Derogatory slang.

---

# 47. Humor

Humor can appear in Events/Packs if natural and culturally safe.

Main Journey should prioritize clarity over jokes.

---

# 48. Ambiguity

**CONFIRMED**

Ambiguity is allowed in advanced content.

But ambiguity must be:

- Intentional.
- Fair.
- Reviewable.
- Solvable by context.

Bad ambiguity:
Two equally valid answers with no way to distinguish.

Good ambiguity:
One card looks plausible in two groups, but the remaining cards reveal the intended grouping.

---

# 49. Lexical Ambiguity

Words with multiple meanings can be powerful in Arabic.

Example:

`عين`

Possible meanings:

- Eye.
- Spring.
- Spy.
- Letter name/contextual meanings.

Use only when the intended context is recoverable.

---

# 50. Ambiguous Spelling

When spelling alone creates unintended ambiguity:

Use diacritics if that resolves it.

If not, replace the card.

Fairness is more important than preserving a clever idea.

---

# 51. Regional Ambiguity

If a word means something different across regions:

- Avoid in Main Journey if the difference matters.
- Use in Dialect Packs if intentional.

---

# 52. Card Text Length

**PROPOSED**

Preferred:

- 1 word.
- 2 words.

Acceptable:

- Short phrase.

Avoid:

- Full sentences.
- Long explanatory clauses.

UI testing should determine final character/line limits.

---

# 53. Clue Length

**PROPOSED**

Preferred:

- 1 word.
- Maximum 2 words where practical.

Longer clue only when shortening would make the puzzle unfair.

---

# 54. Line Breaks

**PROPOSED**

Avoid manual line breaks in content data.

Let the UI handle wrapping.

Content should be authored as clean text.

---

# 55. Capitalization

Arabic does not use capitalization.

For Latin terms:

Preserve official/common capitalization.

Examples:

- iPhone
- YouTube
- GPS

---

# 56. Abbreviations

Abbreviations are allowed when widely recognizable.

Examples:

- GPS
- DNA
- AI

If an Arabic equivalent is much more common, use that instead.

---

# 57. Acronyms

Use only when:

- Broadly recognizable.
- Fair for the intended difficulty.
- Correctly styled.

---

# 58. Mixed Arabic and Latin

Ensure BiDi-safe display.

Examples:

`iPhone 15`
inside RTL UI must remain readable.

This is partly an engineering/UI concern but content authors should avoid unnecessarily complex mixed strings.

---

# 59. Emojis

**CONFIRMED supported content type**

Rules:

- Use common Emoji.
- Avoid ambiguous platform-dependent Emoji.
- Test visual meaning on iOS and Android.
- Keep all Members in the Association as Emoji.

---

# 60. Illustration Naming

Illustration Cards have no visible labels.

Internally each asset should have:

- Arabic canonical name.
- Search aliases.
- Concept ID.
- Asset ID.

This supports review and analytics.

---

# 61. Illustration Cultural Accuracy

Illustrations representing:

- Clothing.
- Food.
- architecture.
- cultural objects.

must avoid stereotypical or misleading visual shortcuts.

---

# 62. Food Content

Use names broadly recognized.

If dish name has regional variants:

- Store aliases.
- Use region-specific version only in appropriate content.

---

# 63. Sports Content

Evergreen sports concepts are suitable.

Avoid relying on current players/teams in Main Journey if information will age quickly.

---

# 64. Technology Content

Prefer stable concepts:

- Internet.
- Keyboard.
- Browser.
- Wi-Fi.

Current brands/products belong mainly in Event/Pack content.

---

# 65. Science Content

Use stable, well-established scientific facts.

Avoid oversimplified wording that becomes technically wrong.

---

# 66. Geography Content

Use stable geography.

Avoid relying on facts that change frequently.

Example:
Countries bordering a sea is generally stable.

Current political office-holders are not.

---

# 67. History Content

Use broadly accepted historical facts.

Avoid controversial framing where there is no consensus.

---

# 68. Literature and Arts

Use well-known authors, works, artistic concepts, genres, and forms where appropriate.

Ensure copyright-sensitive text is not reproduced unnecessarily.

---

# 69. Everyday Life

Everyday-life content is highly suitable for early and relief levels.

Examples:

- Kitchen.
- School.
- Travel.
- Home.
- Work.
- Weather.

---

# 70. Early-Game Vocabulary

Early levels should use:

- High-frequency words.
- Familiar categories.
- Direct relations.
- No obscure spelling.
- No heavy wordplay.

---

# 71. Mid-Game Vocabulary

May introduce:

- Less common words.
- Contextual clues.
- More abstract relations.
- Simple language patterns.

---

# 72. Advanced Vocabulary

May include:

- Rare but fair words.
- Root relations.
- Linguistic manipulation.
- Controlled ambiguity.
- Wordplay.

Rare words should not dominate.

---

# 73. Difficulty and Language

Do not make a puzzle “hard” merely by using obscure vocabulary.

A strong hard puzzle should preferably be difficult because of:

- Inference.
- Ambiguity.
- Relation complexity.
- Board pressure.

Not just because players have never seen the word.

---

# 74. Arabic Search Normalization

**PROPOSED**

For CMS search/deduplication only, normalized search may:

- Remove diacritics.
- Remove Tatweel.
- Normalize Alef forms.
- Normalize Ya/Alif Maqsura optionally.
- Lowercase Latin.
- Trim punctuation/extra spaces.

Display text remains unchanged.

---

# 75. Canonical Display Form

Every Member should have one approved primary display form.

Aliases are for search and content maintenance.

The player should not randomly see different spellings of the same concept without intent.

---

# 76. Duplicate Detection

Potential duplicates should compare:

- Canonical text.
- Normalized Arabic.
- Aliases.
- Meaning.
- Relation overlap.

Do not treat spelling difference alone as unique content.

---

# 77. Editorial Review Questions

For every Arabic text item:

1. Is this natural Arabic?
2. Would users across Arab markets understand it?
3. Is there a shorter natural form?
4. Does spelling need diacritics?
5. Is the spelling standardized?
6. Is this unintentionally dialect-specific?
7. Is there a more common equivalent?
8. Could another meaning confuse the puzzle?
9. Is the clue too revealing?
10. Is the clue too vague?

---

# 78. Main Journey Acceptance Rules

A Main Journey item should be rejected or moved to a Pack if:

- Strongly dialect-specific.
- Very time-sensitive.
- Requires obscure local knowledge.
- Has unstable spelling/meaning.
- Is culturally contentious.
- Depends on current celebrity/brand familiarity.
- Produces unfair ambiguity.

---

# 79. Dialect Pack Acceptance Rules

Dialect Packs can intentionally include:

- Local vocabulary.
- Regional spelling.
- Local idioms.
- Country-specific foods.
- Local pronunciation-based wordplay.

But each Pack should be reviewed by someone familiar with the dialect.

---

# 80. AI Arabic Generation Guidelines

AI prompts should explicitly request:

- Natural Arabic.
- No literal translation.
- Short clue.
- Clear full relation.
- Target difficulty.
- Cross-Arab comprehensibility.
- Avoid dialect unless requested.
- Avoid weak members.
- Avoid duplicated concepts.
- Explain why each Member fits.

---

# 81. AI Review Output

AI may flag:

- Spelling concerns.
- Dialect risk.
- Ambiguity.
- Duplicate candidates.
- Uncommon terms.
- Better clue wording.

AI suggestions remain advisory.

---

# 82. Human Language Review

A human reviewer should approve:

- Display spelling.
- Clue wording.
- Dialect neutrality.
- Diacritics.
- Foreign-term form.
- Naturalness.

---

# 83. Human Semantic Review

A semantic reviewer confirms:

- Every Member actually belongs.
- The clue is fair.
- The relation is coherent.
- No Member is a weak outlier.
- Ambiguity is intentional.

---

# 84. Advanced Content Review

Advanced wordplay should require stronger review.

Recommended:

**PROPOSED**

Two-person review for:

- Root-based puzzles.
- Ambiguous clues.
- Dialect crossover.
- Sensitive cultural content.

---

# 85. Arabic UI Copy Standards

UI labels should prefer:

- Verb or clear noun.
- Short phrasing.
- Consistent terminology.

Example terminology set:

- `متابعة`
- `إعادة`
- `تلميح`
- `تراجع`
- `المتجر`
- `الحركات`
- `العملات`
- `الفصل`
- `المستوى`

Exact final UI lexicon should be frozen in UI Content Specification.

---

# 86. Terminology Consistency

Do not alternate between two Arabic terms for the same game concept.

For example, once the product selects a term for:

- Hint.
- Move.
- Chapter.
- Association.
- Stack.

use it consistently.

Technical/internal English terms may remain in engineering documents.

---

# 87. Association Terminology

The player-facing Arabic name for “Association” is not yet approved.

Possible forms may include concepts such as:

- مجموعة.
- رابط.
- تصنيف.
- علاقة.

Do not finalize without explicit product/UX approval.

Internal documentation may continue using “Association”.

---

# 88. Stack Terminology

Player-facing Arabic term is TBD.

Possible options:

- مجموعة كروت.
- رزمة.
- كومة.

Final choice should be natural in gameplay context.

---

# 89. Stock Terminology

Player-facing Arabic term is TBD.

Possible:

- الرزمة.
- الكومة.
- المخزون.

The chosen term should be intuitive and not over-technical.

---

# 90. Avoid Translationese

Common warning signs:

- Unnatural noun chains.
- Literal English prepositions.
- Overuse of passive voice.
- Phrases no Arabic speaker would normally say.

All generated content should be read as Arabic first, not checked only for grammatical correctness.

---

# 91. Avoid Over-Formalization

Do not prefer a rare formal word merely because it is “more Arabic”.

The goal is:

**natural Arabic gameplay language**

not language-purity scoring.

---

# 92. Avoid Over-Colloquialization

Main Journey should not feel Egyptian-only, Gulf-only, or Levant-only.

**CONFIRMED** controlled dialect influence means:

Use colloquial wording only when it is broadly familiar across Arab markets.

Strong local slang belongs in Dialect Packs (**Post-MVP**).

---

# 93. Cultural Neutrality

When a concept has several valid regional forms:

- Prefer the most broadly recognized neutral form.
- Store other forms as aliases.
- Use local form in Dialect Packs.

---

# 94. Content Fairness Across Regions

A player should not fail a Main Journey puzzle simply because they come from a different Arab country.

This is a key editorial rule.

---

# 95. Content Review Severity Levels

**PROPOSED**

### Blocker
Factually wrong, offensive, or unsolvable ambiguity.

### Major
Strong regional bias, weak clue, bad spelling affecting meaning.

### Minor
Stylistic inconsistency, slightly better wording available.

Only Blocker/Major should block publication in fast editorial workflows.

---

# 96. Editorial QA Checklist

Before production approval:

- [ ] Arabic spelling checked
- [ ] Natural phrasing checked
- [ ] Clue length checked
- [ ] Relation accuracy checked
- [ ] Members validated
- [ ] Ambiguity reviewed
- [ ] Dialect risk checked
- [ ] Diacritics reviewed
- [ ] Foreign terms reviewed
- [ ] Cultural sensitivity checked
- [ ] Duplicate search completed
- [ ] Difficulty tag assigned
- [ ] Content type validated
- [ ] Evergreen status validated

---

# 97. Confirmed Language Decisions

The following are **CONFIRMED** (including Final Decision Register v1.1):

1. Main Journey uses simplified modern Arabic with controlled dialect influence.
2. Game targets the whole Arab world.
3. Dialects are supported through a hybrid strategy.
4. Strong dialect content belongs mainly in Packs/Events (**Post-MVP**).
5. Clues should be concise.
6. Clue may be only one or two words.
7. Same clue can represent different Relations.
8. Diacritics are used only when needed.
9. Foreign terms use the form familiar to Arabic users.
10. Words may belong to multiple global Relations.
11. Advanced semantic ambiguity is allowed.
12. Arabic linguistic relations are supported.
13. Letters, numbers, and symbols are valid content.
14. Text remains the dominant content type.
15. Association Cards remain textual.
16. Main Journey content is Evergreen-focused.
17. Contemporary celebrities/brands are generally outside Main Journey.
18. Human content validation is mandatory.
19. Full relation is internal and is not automatically shown on completion.
20. Progression reuse/visual pacing follows Progression Design v1.0 / Final Decision Register v1.1 §3 (Clue cooldown ≥20 Levels; no exact Variant repeat in same Chapter; early/mid max one visual Association per Level).

---

# 98. Proposed Language Decisions Requiring Approval

The following are **PROPOSED** or **STILL TBD**:

1. Orthographic normalization rules.
2. Search normalization behavior.
3. Minimal-diacritic policy details.
4. No Tatweel rule.
5. Main numeral display preference.
6. Sensitive-topic exclusions.
7. Religious content handling.
8. Political content handling.
9. Two-person review for advanced linguistic puzzles.
10. Editorial severity levels.
11. Terminology choices for Association / Stack / Stock (**STILL TBD**).
12. Exact card/clue text length limits.

---

# 99. Recommended Next Arabic Content Deliverables

After aligning these guidelines, create:

1. **Arabic UI Terminology Glossary**
2. **Arabic Orthography & Normalization Rules**
3. **Dialect Content Guide**
4. **Arabic Wordplay Guide**
5. **Arabic Review Checklist**
6. **Arabic AI Prompt Library**
7. **Approved Foreign-Term Style List**
8. **Content Examples Catalogue**
9. **Rejected Content Examples Catalogue**

---

# 100. Baseline Status

This document is **Arabic Content Guidelines v1.0**, decision-aligned to **Final Decision Register v1.1**.

It defines the editorial and linguistic baseline for Arabic content across the game.

Register-closed language strategy is **CONFIRMED**: simplified modern Arabic with controlled dialect influence.

Any spelling convention, normalization rule, sensitivity rule, or terminology choice not closed by the Register remains **PROPOSED** / **STILL TBD**.

**End of Arabic Content Guidelines v1.0**
