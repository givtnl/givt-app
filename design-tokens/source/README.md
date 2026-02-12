# Design token source files

Copy the token JSON files here:

- **Givt**: Copy `Givt.tokens.json` from your Downloads folder to `givt.tokens.json`.
- **Givt4Kids**: Copy `Givt4Kids.tokens.json` from your Downloads folder to `givt4kids.tokens.json`.

Then from the project root run:

```bash
dart run tool/gen_tokens.dart
```

This generates `fun_givt_tokens_generated.dart` and `fun_givt4kids_tokens_generated.dart` under `lib/features/family/shared/design/tokens/`. The app uses the hand-written `FunGivtTokens` and `FunGivt4KidsTokens` (which implement `FunThemeTokens`); the generated files can be wired in or used as reference.

**CI**: The main workflow runs this generator and fails if those generated files changed (so token JSON and generated code stay in sync). Until the two JSON files are present, the design-tokens job will fail.
