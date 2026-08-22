# Game Design Document (GDD)

## Arabic Solitaire Association Game

**Version:** 1.0  
**Status:** Product & Core Game Design Baseline — Decision-Aligned / Approved  
**Genre:** Solitaire / Word Association / Puzzle / Casual Brain Game  
**Primary Language:** Arabic  
**Target Market:** Arabic-speaking markets worldwide  
**Target Audience:** 13+ General Audience with progressive Adult-Level difficulty  
**Platform Scope:** Mobile — Flutter client (iOS 15+; Android 8 / API 26+; portrait; responsive tablet support); Firebase-first cloud baseline per Final Decision Register v1.1  
**Source Documents:** Final Decision Register v1.1 (decision baseline) + Progression Design v1.0 (`Progression_Design_Arabic_Solitaire_Association_v1.0.md`).

---

# 1. Game Vision

المنتج عبارة عن لعبة ألغاز عربية تجمع بين:

- Solitaire mechanics
- Association puzzles
- Arabic language puzzles
- Semantic reasoning
- Strategic card management
- Visual associations
- Progressive brain challenges

اللعبة مستوحاة من ميكانيكية Solitaire Associations، لكن يتم تطويرها كمنتج مستقل بهوية ومحتوى عربيين ونظام محتوى وتقدم خاصين به.

الهدف ليس تقديم ترجمة مباشرة للعبة أجنبية، وإنما بناء لعبة عربية أصلية تستخدم نفس الفكرة الجوهرية وتوسعها بما يناسب اللغة والثقافة العربية.

---

# 2. Product Principles

اللعبة يجب أن تحقق المبادئ التالية:

### Easy to Learn

يستطيع لاعب 13+ فهم أساسيات اللعبة بسرعة.

### Hard to Master

الصعوبة ترتفع تدريجيًا حتى تصل إلى مستوى مناسب للاعبين البالغين ومحبي ألعاب التفكير.

### Arabic First

المحتوى مصمم للعربية من الأساس، وليس ترجمة لمحتوى إنجليزي.

### Strategic + Semantic

الصعوبة تأتي من محورين مستقلين:

1. إدارة الـSolitaire Board.
2. اكتشاف العلاقات بين الكلمات والمفاهيم.

### Endless

لا يوجد Final Level.

### Fair Randomization

الـBoards يتم توليدها عشوائيًا، لكن لا يتم تقديم Board للاعب قبل التأكد بواسطة Solver أنها قابلة للحل ومتوافقة مع مستوى الصعوبة المطلوب.

### Fast Gameplay

يتم تجنب interruptions غير الضرورية أثناء اللعب.

---

# 3. Target Audience

الجمهور الأساسي:

**13+ General Audience**

مع إمكانية وصول مستوى الألغاز تدريجيًا إلى:

**Adult-Level Semantic & Strategic Difficulty**

بالتالي يمكن للاعب الجديد البدء بألغاز مباشرة جدًا، بينما تحتوي المراحل المتقدمة على:

- Ambiguous words
- Linguistic relationships
- Wordplay
- Complex associations
- Harder board states
- Tight move limits

---

# 4. Target Market

اللعبة تستهدف:

**جميع الناطقين باللغة العربية عالميًا.**

لا يتم تصميم الـMain Journey لدولة عربية بعينها.

---

# 5. Language Strategy

## 5.1 Primary Language

يتم استخدام:

**العربية الفصحى المبسطة والمعاصرة.**

يتم تجنب الأسلوب الرسمي أو اللغوي الثقيل عندما توجد صياغة عربية طبيعية وأكثر شيوعًا.

---

# 6. Dialects

يتم استخدام Hybrid Language Model.

### Main Journey

تعتمد أساسًا على العربية المشتركة والفصحى المعاصرة.

يمكن استخدام الكلمات العامية المنتشرة عربيًا عندما تكون مفهومة على نطاق واسع.

### Dialect Content

الكلمات المحلية بوضوح يتم استخدامها بصورة أكبر في:

- Dialect Packs
- Special Levels
- Events
- Regional Challenges

يمكن مستقبلًا تقديم محتوى مثل:

- المصرية
- السعودية
- الخليجية
- الشامية
- المغاربية

---

# 7. Core Gameplay

الـMain Gameplay يستخدم Solitaire Association mechanic.

الـBoard يتكون أساسًا من:

- Tableau Columns
- Face-down Cards
- Face-up Cards
- Stock
- Association Cards
- Association Slots

هدف اللاعب هو اكتشاف العلاقات وتجميع كل Cards التابعة لكل Association حتى يتم تصفية جميع Cards الموجودة في الـLevel.

---

# 8. Card Types

يوجد نوعان وظيفيان أساسيان:

## 8.1 Association Card

Card تمثل الـclue الخاصة بالمجموعة.

مثال:

**فواكه**

أو:

**البحر الأحمر**

أو:

**ض**

الـAssociation Card نفسها جزء من الـDeck.

يمكن أن تظهر:

- داخل الـTableau.
- داخل الـStock.

ولا تبدأ داخل Association Slot.

---

## 8.2 Member Card

Card تنتمي إلى Association معينة.

يمكن أن تكون:

- Text
- Number
- Symbol
- Emoji
- Illustration/Icon

---

# 9. Association Slots

يوجد عدد محدود من Association Slots أعلى الـBoard.

العدد:

**Variable per Level.**

قد يحتوي Level على Associations أكثر من عدد Slots المتاحة.

وبالتالي يحتاج اللاعب إلى إكمال Association لتحرير Slot واستخدامه لمجموعة أخرى.

جميع Association Slots تبدأ فارغة.

---

# 10. Activating an Association

عندما تظهر Association Card، يستطيع اللاعب نقلها إلى Association Slot فارغ.

عندها تتحول إلى:

**Active Association**

وتستطيع استقبال Member Cards أو Stacks التابعة لها.

مثال:

**فواكه 0/4**

ثم:

**فواكه 1/4**

ثم:

**فواكه 2/4**

إلخ.

---

# 11. Association Completion

عندما يصل عدد Member Cards الموجودة في Active Association إلى العدد المطلوب:

**Association Complete**

ويحدث تلقائيًا:

1. Completion detection.
2. Completion animation.
3. إزالة Association Card.
4. إزالة Member Cards الخاصة بها.
5. تحرير Association Slot.

لا يحتاج اللاعب إلى Confirm.

---

# 12. Completion Location

Association لا تعتبر مكتملة داخل الـTableau.

حتى إذا قام اللاعب بجمع جميع كلمات المجموعة داخل Stack، يجب أن تصل المجموعة مع Association Card إلى Association Slot حتى يتم Completion.

---

# 13. Tableau

عدد Tableau Columns:

**Variable per Level.**

عدد Cards داخل كل Column:

**Variable per Level.**

كل Column يبدأ بـ:

**1 Face-up Card**

والـCards الموجودة تحته تكون:

**Face-down**

---

# 14. Auto Reveal

عند إزالة الـCard أو Stack المكشوفة من أعلى Column:

إذا كان تحتها Face-down Card:

**يتم كشفها تلقائيًا.**

---

# 15. Empty Tableau Column

إذا أصبح Column فارغًا بالكامل:

يصبح Free Space.

يمكن نقل أي movable unit إليه، بما في ذلك:

- Word Card
- Association Card
- Word Stack
- Association Stack

---

# 16. Word-to-Word Stacking

يمكن وضع Member Card فوق Member Card أخرى فقط عندما يكون الاثنان تابعين لنفس Association.

مثال:

تفاح + موز

إذا كان الاثنان تابعين إلى:

**فواكه**

فالحركة Valid.

---

# 17. Stack Formation

يمكن تجميع عدد غير محدود من Cards التابعة لنفس Association، حتى الحد الفعلي لعدد Cards الخاصة بالمجموعة.

مثال:

تفاح  
موز  
عنب  
مانجو

يمكن أن تصبح كلها Stack واحدة.

---

# 18. Stack Atomicity

بمجرد تكوين Stack:

**لا يمكن تقسيمها.**

لا يمكن:

- إخراج Card منفردة منها.
- تحريك جزء منها.
- Split Stack.

كل Stack تتحرك دائمًا كوحدة واحدة.

---

# 19. Stack Ordering

الترتيب الداخلي للـCards داخل Stack لا يؤثر على صحة اللعب.

الـStack تعامل منطقيًا كمجموعة Cards مرتبطة بنفس Association.

---

# 20. Stack-to-Stack Merge

يمكن دمج Stack مع Stack أخرى عندما يكون الاثنان تابعين لنفس Association.

النتيجة:

**Atomic Stack واحدة.**

وتعتبر العملية:

**1 Move**

بغض النظر عن عدد Cards.

---

# 21. Association Card inside Tableau

Association Card الموجودة داخل الـTableau ليست Active Association.

لا يمكن إضافة Member Cards إليها مباشرة وهي داخل الـTableau.

---

# 22. Association-to-Word Stack

يمكن وضع Association Card فوق Word Card أو Word Stack التابعة لنفس Association.

مثال:

فواكه  
↓  
تفاح + موز + عنب

يصبح الجميع Combined Stack.

---

# 23. Direction Restriction

داخل الـTableau:

**Association Card → Word Stack = Valid**

لكن:

**Word Stack → Association Card = Invalid**

---

# 24. Association Stack Locking

عندما تصبح Association Card جزءًا من Stack داخل الـTableau:

لا يمكن إضافة Cards جديدة إلى هذه Stack وهي داخل الـTableau.

لكن يمكن تحريك الـStack بالكامل كوحدة واحدة.

---

# 25. Moving Association Stack to Slot

يمكن نقل Association Card مع جميع Member Cards المرتبطة بها إلى Association Slot كحركة واحدة.

مثال:

Association + 2 Member Cards

عند نقلهم:

**Association 2/4**

وتعتبر العملية:

- 1 Move
- 1 Correct Streak Action

---

# 26. Active Association Accepts Stacks

Active Association يمكنها استقبال:

- Single Member Card
- Complete Member Stack

طالما جميع Cards تتبع نفس Association.

مثال:

Association 1/5

+

Stack تحتوي 3 Cards

=

Association 4/5

والعملية:

**1 Move**

---

# 27. Player Freedom

اللعبة لا تجبر اللاعب على أفضل حركة.

إذا كانت هناك عدة Valid Moves، فاللاعب حر في اختيار أي منها.

مثال:

يمكن للاعب الاحتفاظ بـWord Card داخل Tableau رغم وجود Active Association تستقبلها.

الـGame Engine يتحقق من:

**Valid / Invalid**

بينما الـSolver مسؤول عن معرفة المسارات التي تؤدي للحل.

---

# 28. Invalid Association Placement

إذا حاول اللاعب وضع Member Card على Association غير صحيحة:

الحركة يتم رفضها فورًا.

الـCard تعود لمكانها.

الحركة:

- لا تخصم Move.
- تعتبر Wrong Action بالنسبة للـStreak.

---

# 29. Controls

الحركة الأساسية للكروت:

**Drag & Drop**

لا يوجد Auto-placement بالـTap ضمن الـcore rules الحالية.

---

# 30. Stock

الـStock يحتوي على نفس أنواع Cards الموجودة في Tableau:

- Association Cards
- Member Cards

عدد Cards الموجودة في Stock:

**Variable per Level.**

---

# 31. Stock Window

يتم عرض آخر:

**3 Cards**

من دورة الـStock.

لكن فقط:

**آخر Card**

هي playable.

مثال:

A — B — C

C هي المتاحة للحركة.

إذا تم لعب C:

A — B

B تصبح playable.

ثم إذا تم لعب B:

A

A تصبح playable.

---

# 32. Stock Cycling

يمكن الاستمرار في تدوير الـStock حتى الوصول للنهاية.

عند النهاية يمكن استخدام:

**Restore Stock**

---

# 33. Restore Stock

Restore Stock:

- غير محدود.
- يعيد Cards المتبقية.
- يحافظ على نفس ترتيبها.
- لا يعمل Shuffle.

---

# 34. Move System

كل Level لديه:

**Fixed Move Limit**

الـMove Limit لا يتغير عند Restart.

---

# 35. Actions That Consume Moves

تعتبر Move:

- تدوير Stock.
- Restore Stock.
- نقل Card بين Tableau Columns.
- نقل Stack.
- نقل Association Card إلى Slot.
- نقل Word Card إلى Active Association.
- نقل Stack إلى Active Association.

Stack كاملة تعتبر:

**1 Move**

مهما كان عدد Cards بداخلها.

---

# 36. Invalid Actions

الحركة المرفوضة:

**لا تستهلك Move.**

---

# 37. Out of Moves

عندما يصل Move Counter إلى صفر قبل الفوز:

يتم إيقاف اللعب وتقديم Rescue Offer.

يمكن الحصول على Extra Moves عبر أنظمة مثل:

- Rewarded Ad
- Coins

**CONFIRMED** (Final Decision Register v1.1):

- Grant: **+5 Moves**
- First: **150 Coins**; Second: **250 Coins**
- Max **2** Extra-Move rescues per Attempt
- Rewarded Ads supported for Extra Moves

---

# 38. Undo

Undo:

- يرجع آخر Move فقط.
- يعيد الـMove المستهلك إلى العداد.
- لا يمكن استخدام Undo مرتين متتاليتين.
- يجب تنفيذ Move جديدة قبل استخدام Undo مرة أخرى.

مثال:

20 → Move → 19 → Undo → 20

---

# 39. Undo Completion Restriction

إذا أدت آخر Move إلى إكمال Association وإزالتها:

**Undo غير متاح.**

---

# 40. Hint System

Hint لا ينفذ الحركة.

يعرض رسالة للاعب توضح الحركة المقترحة.

مثل:

**انقل "تفاح" إلى مجموعة "فواكه".**

أو:

**انقل المجموعة من العمود الثالث إلى الخامس.**

أو:

**اسحب الكارت التالي من الـStock.**

---

# 41. Hint Cost

استخدام Hint:

- لا يستهلك Move.
- يستهلك Hint من رصيد اللاعب.

عند انتهاء الرصيد يمكن الحصول على المزيد باستخدام:

- Coins (**75 Coins** per Hint — CONFIRMED)
- Rewarded Ads (**1 Ad → 1 Hint**)

Starting Hints: **3** (CONFIRMED)

---

# 42. Solver-powered Hints

الـHint System يجب أن يعتمد على Solver لتقديم حركة Safe/Useful بدل اقتراح حركة Valid عشوائية.

---

# 43. Win Condition

الفوز يحدث فقط عند:

**تصفية جميع Cards الموجودة في الـLevel بالكامل.**

بما يشمل:

- Tableau
- Stock
- جميع Associations

---

# 44. Base Win Reward

الفوز بالـLevel يمنح:

**50 Coins**

كمكافأة أساسية.

---

# 45. Remaining Moves Reward

كل Move متبقية عند الفوز تتحول إلى:

**2 Coins**

مثال:

17 Moves Remaining

=

34 Coins

---

# 46. Correct Move Streak

يوجد Streak Reward أثناء اللعب.

البداية:

**3 Correct Moves → 3 Coins**

بعد تحقيقها:

**4 Correct Moves → 4 Coins**

بعد تحقيقها:

**5 Correct Moves → 5 Coins**

ثم يظل النظام على:

**5 Correct Moves → 5 Coins**

بشكل متكرر.

---

# 47. Streak Tier Persistence

إذا وصل اللاعب إلى Tier 4 أو Tier 5:

الخطأ لا يعيده إلى Tier أقل.

بل يعيد فقط:

**Current Streak Counter → 0**

---

# 48. Correct Streak Actions

تزيد Streak بمقدار 1:

- Word → Same Association Word.
- Stack → Same Association Stack.
- Association Card → Association Slot.
- Word/Stack → Active Association.
- Association Card → Correct Word Stack.
- Association Stack → Association Slot.

كل Move صحيحة تعتبر:

**+1**

بغض النظر عن عدد Cards التي تحركت.

---

# 49. Neutral Streak Actions

لا تزيد ولا تكسر الـStreak:

- Stock cycling.
- Restore Stock.
- نقل Card/Stack إلى Empty Column.

---

# 50. Wrong Streak Actions

Invalid Move:

- لا تستهلك Move.
- تعيد Current Streak إلى 0.
- لا تقلل Streak Tier.

---

# 51. Dead-End Detection

اللعبة تستخدم Solver لاكتشاف الحالات التي أصبح الفوز منها مستحيلًا.

يتم تنبيه اللاعب تلقائيًا بدل تركه يستهلك باقي Moves.

---

# 52. Dead-End Rescue

عند اكتشاف Dead End يمكن تقديم:

- Undo إذا كان متاحًا.
- Dead-End Rescue: **Solver-Guided Recovery** (حفظ التقدم المكتمل قدر الإمكان وضمان مسار فوز).
- Coins: **200** — max **1** per Attempt.
- Rewarded Ad rescue.

**لا يوجد Mid-Level Reshuffle منفصل في MVP** (Post-MVP / DEFERRED).

---

# 53. Level Group Size

Group Size تتطور تدريجيًا.

**CONFIRMED:**

- البداية: مجموعات **3**
- ثم تصبح **4** الحجم القياسي
- لاحقًا: **5** و/أو Mixed Group Sizes

Difficulty waves: **10-Level Wave × 5** per Chapter (50 Levels).

---

# 54. Number of Associations

عدد Associations داخل Level:

**Progressive + Mixed**

لا توجد قاعدة ثابتة بأن كل Level يجب أن يحتوي نفس العدد.

---

# 55. Level Configuration

كل Level يمكن أن يحدد:

- Number of Associations
- Group Sizes
- Number of Tableau Columns
- Cards per Column
- Stock Size
- Association Slot Count
- Move Limit
- Difficulty Targets
- Content Set

---

# 56. Full Randomization

أماكن جميع Cards يتم عمل Randomization لها.

يشمل ذلك:

- Association Cards
- Member Cards

ويتم توزيعها بين:

- Tableau
- Stock

مع الحفاظ على Level Configuration.

---

# 57. First Attempt Randomization

الـRandomization يحدث من:

**أول محاولة للـLevel.**

لا توجد Initial Fixed Board.

---

# 58. Restart

كل Restart ينتج:

**Full New Shuffle**

لنفس Level Content.

---

# 59. Random Repetition

لا يوجد حاليًا نظام لمنع تكرار نفس Shuffle.

Randomization عادية.

---

# 60. Initial Face-up Cards

الكارت المكشوف في كل Column يتم اختياره ضمن الـRandomization بالكامل.

يمكن أن يكون:

- Association Card
- Member Card

ولا توجد Initial Placement Constraints خاصة.

---

# 61. Solver Validation

قبل عرض Board للاعب:

1. Generate shuffle.
2. Deal Tableau.
3. Build Stock.
4. Run Solver.
5. Verify solvability.
6. Verify difficulty.
7. Accept or reshuffle.

---

# 62. Move Limit Validation

Move Limit ثابت لكل Level.

لكن الـSolver يجب أن يتأكد أن الـgenerated board:

**Solvable within Move Limit.**

---

# 63. Hybrid Difficulty Validation

الـSolver لا يتحقق فقط من إمكانية الحل.

بل يجب أن يقيس الحد الأدنى أو الحل المرجعي للحركات ويتأكد أن الـBoard تقع داخل Difficulty Range المطلوب للـLevel.

---

# 64. Difficulty Model

يوجد محوران مستقلان:

## Board Difficulty

يتأثر بـ:

- Tableau depth
- Column count
- Stock size
- Association count
- Association Slots
- Move Limit
- Required Stock cycles
- Number of valid branches
- Dead-end potential
- Solver complexity

## Semantic Difficulty

يتأثر بـ:

- وضوح العلاقة
- صعوبة الكلمات
- المعرفة المطلوبة
- Ambiguity
- Wordplay
- Indirect clues
- Linguistic complexity

---

# 65. Difficulty Waves

الصعوبة لا ترتفع خطيًا Level بعد Level.

يتم استخدام:

**Difficulty Waves**

مثل:

Easy → Medium → Hard → Relief → Medium → Hard → Peak

مع اتجاه عام لزيادة العمق مع تقدم اللاعب.

---

# 66. Semantic Ambiguity

في المستويات المتقدمة يمكن استخدام كلمات تبدو منطقية لأكثر من Association موجودة في نفس Level.

لكن كل Card لها:

**Target Association واحدة محددة.**

يجب أن تظل الـPuzzle عادلة وقابلة للاستنتاج.

---

# 67. Endless Progression

اللعبة:

**Endless**

لا يوجد Final Level.

Level Numbers تستمر بلا حد نظري.

---

# 68. Chapters

الـMain Journey مقسمة إلى Chapters.

Standard Chapter:

**50 Levels**

Launch content (**CONFIRMED**): **5 Chapters = 250** Level Definitions.

Sequential unlock: complete Level N → unlock Level N+1.

مع إمكانية وجود Special Chapters بأحجام مختلفة لاحقًا.

---

# 69. Chapter Content

الـChapters:

**Mixed Content**

ولا يتم تخصيص كل Chapter لموضوع واحد.

وظيفة Chapter الأساسية:

- Progress milestone
- Organization
- Reward/progression opportunities

Chapter completion reward (**CONFIRMED**): **500 Coins + 2 Hints**

وليست تحديد مجال الكلمات.

---

# 70. Content Strategy

الـMain Journey تعتمد أساسًا على:

**Evergreen Content**

بينما المحتوى المرتبط بوقت معين يستخدم في:

- Events
- Special Packs

---

# 71. Contemporary Content

أمثلة المحتوى الذي يفضل وضعه خارج Main Journey:

- Current celebrities
- Current sports events
- Trends
- Seasonal entertainment
- Time-sensitive brands/topics

---

# 72. Association Reuse

يمكن إعادة استخدام نفس Association Concept في Levels مختلفة بشرط استخدام Word Sets مختلفة.

**CONFIRMED** (Final Decision Register v1.1):

- Same Association Clue reuse cooldown: **≥ 20 Levels**
- Exact same Variant cannot repeat inside the same Chapter

مثال:

**فواكه — Easy**

تفاح، موز، عنب

ثم:

**فواكه — Medium**

رمان، كيوي، جوافة، أناناس

ثم:

**فواكه — Hard**

ليتشي، بابايا، كاكا...

---

# 73. Word Reuse

نفس Word يمكن أن تنتمي إلى Associations مختلفة داخل Content Library.

لكن داخل Level معين يكون لها:

**Target Association واحدة.**

لا يتم حاليًا وضع نسختين متطابقتين من نفس الكلمة في نفس Level بإجابتين مختلفتين.

---

# 74. Association as Semantic Clue

Association Card لا تحتاج إلى وصف العلاقة كاملًا.

يفضل استخدام:

**كلمة أو كلمتين**

قدر الإمكان.

مثال:

"أشياء لها أجنحة"

يظهر:

**أجنحة**

"دول تطل على البحر الأحمر"

يظهر:

**البحر الأحمر**

"كلمات تبدأ بحرف الضاد"

يظهر:

**ض**

"أشياء تجدها في المطار"

يظهر:

**مطار**

---

# 75. Hidden Full Relation

يتم تخزين Full Relation داخليًا في Content System.

مثال:

**Card Clue:** البحر الأحمر

**Internal Relation:** دول تطل على البحر الأحمر.

اللاعب يرى فقط:

**البحر الأحمر**

---

# 76. Clue Reuse

نفس Clue يمكن أن تمثل Relations مختلفة في Puzzles مختلفة.

مثال:

**مصر**

يمكن أن ترتبط في Puzzle بمدن مصرية.

وفي Puzzle آخر بأكلات مصرية.

وفي Puzzle آخر بمعالم مصرية.

---

# 77. Multi-Type Associations

العلاقات ليست Semantic Categories فقط.

يمكن دعم:

- Categories
- Shared properties
- Common phrases
- Prefix relationships
- Suffix relationships
- Letter patterns
- Wordplay
- Linguistic patterns
- Numerical relationships
- Symbol relationships

---

# 78. Arabic Diacritics

القاعدة:

**No Diacritics by Default**

لكن يتم استخدام التشكيل عندما يكون ضروريًا لتحديد المعنى.

مثال:

**عَلَم**

مقابل:

**عِلْم**

---

# 79. Foreign Terms

يتم عرض الأسماء الأجنبية بالشكل الأكثر شيوعًا لدى المستخدم العربي.

لا يوجد إجبار على:

- Arabic transliteration
- Original-language spelling

الـContent Guidelines تحدد الشكل الأنسب لكل حالة.

---

# 80. Content Types

Member Cards يمكن أن تكون:

- Text
- Number
- Symbol
- Emoji
- Illustration/Icon

---

# 81. Association Homogeneity

كل Association تستخدم Member Content Type واحد.

مثال:

Association واحدة لا تخلط:

Text + Image + Emoji

داخل نفس المجموعة.

---

# 82. Mixed Level Content

نفس Level يمكن أن يحتوي Associations بأنواع مختلفة.

مثال:

- Text Association
- Emoji Association
- Illustration Association
- Number Association

لكن:

**Text هو النوع الأكثر استخدامًا في اللعبة.**

**CONFIRMED:** Text remains dominant. Early/mid Levels: max one visual Association per Level. Illustration content introduced gradually after tutorial/early Levels.

---

# 83. Association Card Type

Association Card نفسها:

**Text Clue دائمًا.**

حتى عندما تكون Member Cards صورًا أو Emoji أو رموزًا.

---

# 84. Image Cards

Image Cards:

**Image only**

بدون Label أو اسم مكتوب.

---

# 85. Visual Asset Style

Visual Cards تستخدم:

**Illustrations / Icons only**

ولا تستخدم Real Photos.

---

# 86. Visual Clarity

Illustrations يجب أن تكون:

**واضحة ومباشرة.**

صعوبة التعرف على الرسم ليست Difficulty Mechanic.

الصعوبة تأتي من:

- Association
- Board

---

# 87. People & Brands

Main Journey يمكن أن تستخدم:

- Historical figures
- Scientific figures
- Educational/historical personalities

بينما:

- Contemporary celebrities
- Brands

يتم إبقاؤهم خارج Main Journey الأساسي.

---

# 88. Content Generation

يتم استخدام:

**AI-Assisted Content Generation + Human Validation**

الـAI لا ينشر محتوى مباشرة.

---

# 89. Content Pipeline

المسار المستهدف:

AI Generation  
↓  
Language Validation  
↓  
Semantic Validation  
↓  
Duplicate Detection  
↓  
Ambiguity Analysis  
↓  
Difficulty Estimation  
↓  
Human Review  
↓  
Approval  
↓  
Content Library

---

# 90. Tutorial

يتم استخدام:

**Explanation + Interactive Tutorial**

أي:

- شرح مختصر.
- تعليم تفاعلي تدريجي داخل اللعب.

---

# 91. Lives / Energy

لا يوجد:

- Lives System
- Energy System

يمكن للاعب Restart والاستمرار بدون انتظار زمني.

---

# 92. Daily Reward

يوجد:

**Daily Reward Calendar**

**CONFIRMED** (Final Decision Register v1.1) — 7-day repeating calendar:

| Day | Reward |
|---|---:|
| Day 1 | 100 Coins |
| Day 2 | 125 Coins |
| Day 3 | 150 Coins |
| Day 4 | 1 Hint |
| Day 5 | 175 Coins |
| Day 6 | 200 Coins |
| Day 7 | 300 Coins + 1 Hint |

Missing a day does **not** reset calendar progression. Backend authoritative for Daily time/eligibility.

---

# 93. Daily Challenge

يوجد:

**Daily Puzzle واحد.**

**CONFIRMED:** Reward **150 Coins** auto-granted on first completion; unlimited retries; deterministic board; reset **00:00** player-local; backend authoritative. Leaderboard: Post-MVP / DEFERRED.

---

# 94. Daily Streak

يوجد:

**Daily Play Streak**

**CONFIRMED:** Streak breaks on miss. Milestones: 3 → 100; 7 → 250; 14 → 400; 30 → 750 Coins.

---

# 95. Coin Sinks

Coins يمكن استخدامها في:

- Hints (**75 Coins**)
- Extra Moves (**+5** at **150** then **250**; max **2**/Attempt)
- Dead-End Rescue / Solver-Guided Recovery (**200**; max **1**/Attempt)

Starting Coins: **300**. No Mid-Level Reshuffle in MVP. Cosmetics/Themes: Post-MVP / DEFERRED.

Coin Pack amounts **CONFIRMED** (1,000 / 3,000 / 7,000 / 15,000); real-money prices **TBD**.

---

# 96. Rewarded Ads

Rewarded Ads يمكن استخدامها اختياريًا للحصول على:

- Extra Moves
- Hints
- Dead-End Rescue
- Coins (**100** per Coin Ad; cap **3/day**)

---

# 97. Interstitial Ads

يتم استخدام:

**Adaptive Interstitial Frequency**

**CONFIRMED:** ~every **3–5** completed Levels; max **3**/session; suppressions after Rewarded Ad, purchase, tutorial, failure, Dead-End, Out-of-Moves decline.

---

# 98. In-App Purchases

الـIAP المعتمدة حاليًا:

- Remove Ads (**Interstitials only**; real-money price **TBD**)
- Coin Packs (amounts confirmed; prices **TBD**)

لا يوجد: Starter Pack / Subscription / Premium Currency / paid randomized rewards.

---

# 99. Events

اللعبة تدعم لاحقًا:

**Temporary Events**

**Post-MVP / DEFERRED** until post-launch stability (First Event: 10 Levels; core rules only; no new currency; no leaderboard).

---

# 100. Permanent Packs

اللعبة تدعم لاحقًا:

**Permanent Special Packs**

**Post-MVP / DEFERRED.** Future Pack monetization model **TBD** (free / Coin / real-money). No paid Pack at initial introduction.

---

# 101. Meta Progression

اللعبة تحتوي على:

- Main Level Number
- Chapters

**Post-MVP / DEFERRED:** Player XP, Player Level, Achievements, Collections, Badges.

تفاصيل Progression Design تُنشأ لاحقًا في:
`Progression_Design_Arabic_Solitaire_Association_v1.0.md`

---

# 102. Leaderboards

**Post-MVP / DEFERRED**

ولا يوجد حاليًا ضمن التصميم المعتمد:

- PvP
- Friend system

---

# 103. Account Strategy

اللاعب يستطيع البدء بدون Registration إجباري.

يتم استخدام:

**Anonymous Cloud Save**

مع إمكانية ربط الحساب اختياريًا عبر:

- Sign in with Apple
- Google Sign-In

**CONFIRMED:** Main Journey playable offline once content is downloaded; offline Coin spend with reconciliation. Purchases/Rewarded Ads require network. Main Journey includes **Report a problem** from launch.

---

# 104. Notifications

يتم استخدام Smart Notifications مع تحكم المستخدم.

**CONFIRMED at launch:** Daily Challenge + Streak Risk only. Quiet hours **22:00–09:00** player-local.

Richer types: **Post-MVP / DEFERRED**.

---

# 105. Full Product vs MVP

يتم أولًا تصميم:

**Full Product Scope**

ثم يتم استخراج:

**MVP Scope**

منه.

لا يتم السماح لقيود الـMVP بتحديد التصميم النهائي للمنتج من البداية.

---

# 106. Core Technical Requirement — Solver

الـSolver يعتبر Core Component وليس Utility ثانوية.

يجب أن يدعم على الأقل:

### Board Validation

هل الـBoard قابلة للحل؟

### Move-Bounded Validation

هل يمكن حلها داخل Move Limit؟

### Difficulty Analysis

كم عدد الحركات المطلوبة؟

ما مدى تعقيد مسار الحل؟

### Hint Generation

ما الحركة الآمنة أو المناسبة التالية؟

### Dead-End Detection

هل ما زال يوجد حل من Current State؟

---

# 107. Randomization Pipeline

المسار الأساسي لإنشاء محاولة:

Level Configuration  
↓  
Content Selection  
↓  
Build Card Pool  
↓  
Full Random Shuffle  
↓  
Deal Tableau  
↓  
Build Stock  
↓  
Initialize Empty Association Slots  
↓  
Solver Validation  
↓  
Difficulty Validation  
↓  
Accept Board / Reshuffle  
↓  
Play

---

# 108. Restart Pipeline

عند Restart:

Same Level Configuration  
↓  
Same Level Content  
↓  
New Full Shuffle  
↓  
New Deal  
↓  
Solver Validation  
↓  
Difficulty Validation  
↓  
Play

---

# 109. Level Completion Economy

إجمالي Coins الناتجة عن Level يمكن أن يأتي من:

**50 Base Win Coins**

+

**2 × Remaining Moves**

+

**Correct Move Streak Rewards**

+

أي Rewards إضافية مستقبلية يتم اعتمادها.

---

# 110. Game Identity

اللعبة يجب ألا تتحول إلى مجرد:

"صنّف أربع كلمات."

الهوية الأساسية هي التقاء:

**Solitaire Strategy**

مع:

**Association Discovery**

مع:

**Arabic Linguistic & Cultural Depth**

---

# 111. Main Journey Content Philosophy

الـMain Journey يجب أن تكون:

- متنوعة.
- Evergreen.
- مفهومة عربيًا.
- غير مرتبطة بدولة واحدة.
- قابلة للتدرج من البسيط إلى المعقد.
- عادلة لغويًا.
- غير قائمة على Trivia شديدة التخصص إلا عندما يتناسب ذلك مع مستوى الصعوبة.

---

# 112. Arabic-Specific Opportunity

اللعبة يمكن أن تستفيد من خصائص العربية في:

- تعدد المعاني.
- الجذور.
- الحروف.
- التشكيل.
- التراكيب.
- الأمثال والتعبيرات.
- الكلمات المشتركة.
- المفرد والجمع.
- المرادفات.
- الأضداد.
- الكلمات الدخيلة.
- الاختلافات اللهجية.

استخدام كل نوع يخضع لمراجعة Content Design حتى لا يتحول الغموض إلى تخمين غير عادل.

---

# 113. Current Out-of-Scope / Deferred Mechanics

**Post-MVP / DEFERRED** (Final Decision Register v1.1) — not open TBD:

- Player XP / Player Level
- Achievements
- Badges
- Collections
- Permanent Special Packs
- Leaderboards
- Richer Smart Notification types beyond Daily Challenge / Streak Risk
- Major temporary Event system until post-launch
- Paid Cosmetics unless later approved
- Mid-Level Reshuffle (MVP)
- Locked Association Slots / Keys / Crowns
- PvP / Friends system
- ASP.NET Core + PostgreSQL / always-on relational DB unless Firebase-first proves insufficient
- Dedicated Redis / Message Broker / Kubernetes unless later justified

Azure-heavy MVP baseline items in Register §13A are **SUPERSEDED**.

---

# 114. Open Product Decisions (TBD)

Intentionally left open (Final Decision Register v1.1):

### Commercial
- Exact real-money prices for Remove Ads and Coin Packs (1,000 / 3,000 / 7,000 / 15,000)

### Packs
- Future Pack monetization model (free / Coin unlock / real-money)

### Solver / Technical Tuning
- Exact Solver algorithm composition after benchmarking
- Exact timeout/performance budgets
- Whether native optimization is ever necessary
- Exact backend Solver fallback rules

### Delivery / Staffing
- Final team size, roles, rates, calendar dates, commercial budget, P0/P1 delivery dates

### Production Operations
- Exact DR RPO/RTO values
- Exact Firebase / Google Cloud quotas, billing budgets, Cloud Functions / Cloud Run resource limits and scaling thresholds
- Final ad mediation network mix
- Final penetration-test vendor
- Exact analytics cost thresholds that trigger retention-policy review

### Still open product/UX
- Game name / brand / visual identity details
- Exact tutorial level count and sequencing
- Exact accessibility certification target
- Whether English UI is included at launch

**Already APPROVED** (do not treat as TBD): soft-currency economy values, Daily systems, Interstitial rules, Remove Ads = Interstitials only, Coin Pack amounts, Flutter client stack, Firebase-first cloud baseline (Auth/Firestore/Storage/Functions or Cloud Run; no Azure in MVP), launch 5 Chapters / 250 Levels, offline Main Journey + offline Coin spend, Report a problem from launch.

---

# 115. Next Design Documents

Aligned with Final Decision Register v1.1 update pass. Progression Design exists at:

`Progression_Design_Arabic_Solitaire_Association_v1.0.md`

Related documents include:

1. **Full Product Scope**
2. **MVP Scope**
3. **Game Economy Design**
4. **Progression Design** (`Progression_Design_Arabic_Solitaire_Association_v1.0.md`) — Decision-Aligned
5. **Screen Inventory & User Flows**
6. **Content Design System**
7. **Arabic Content Guidelines**
8. **Level Design Framework**
9. **Difficulty Model**
10. **Solver Specification**
11. **Game Engine Technical Design**
12. **Data Model**
13. **Software Architecture**
14. **Backend & Cloud Architecture**
15. **Analytics & KPI Specification**
16. **Monetization Specification**
17. **LiveOps & Events Design**
18. **Admin/CMS Specification**
19. **QA & Automated Game Validation Strategy**
20. **MVP Product Backlog / WBS**
21. **Estimation & Delivery Roadmap**

---

# 116. Baseline Status

هذا المستند يمثل **Game Design Baseline v1.0** aligned with **Final Decision Register v1.1**.

Items marked **TBD** are intentionally unresolved. Items marked **Post-MVP / DEFERRED** are decided deferrals, not open TBDs.

وأي تغيير جوهري في:

- Core Rules
- Solitaire Mechanics
- Association Model
- Content Philosophy
- Economy Foundation
- Progression Foundation

يجب تسجيله لاحقًا كـDesign Decision جديد وتحديث نسخة الـGDD.

**End of GDD v1.0**