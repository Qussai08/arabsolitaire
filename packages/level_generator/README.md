# level_generator

Pure Dart Level Generator for **سوليتير العرب: أسطورة المعاني**.

## Pipeline

1. Validate `LevelConfiguration`
2. Select approved `AssociationVariant` content (IDs only)
3. Build exact card pool
4. Seeded deal → Tableau + Stock (Slots empty)
5. `GameEngine` invariant check
6. `GameSolver.solve` within **fixed** Move Limit
7. Board Difficulty acceptance
8. Accept or retry (bounded)

Never changes visible Move Limit per Attempt. Never bypasses Solver acceptance.

## Versions

- Package: `0.1.0`
- `generatorVersion`: `1.0.0`
- `difficultyModelVersion`: `1.0.0`

## Tests

```bash
dart test
```

## Batch simulation

```bash
dart run tool/generator_simulation.dart --boards=20 --seed=42
```
