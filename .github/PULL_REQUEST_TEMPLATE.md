## What does this change

<!-- One or two sentences. What, and why — not a restatement of the diff. -->

## Which rule does this trace to

<!-- Link the SPEC.md/STACK.md section (or Memory.md entry) this change
     implements or follows. If there isn't one, say so — that's fine for a
     bug fix, but a new behavior with no traceable rule usually means the
     docs need updating first (see CONTRIBUTING.md). -->

## Checklist

- [ ] `bash tool/check.sh` passes locally (format, analyze, architecture
      check, tests — the same gate CI runs).
- [ ] `dart run build_runner build --delete-conflicting-outputs` was run if
      I touched `@freezed`, `@riverpod`/`@Riverpod`, `@JsonSerializable`/DTO,
      a drift `Table`/DAO, or a `.arb` file, and the generated output is
      committed.
- [ ] My commits follow [Conventional Commits](https://www.conventionalcommits.org/)
      (`<type>(<scope>)?: description`) — this drives the automatic version
      bump and changelog.
- [ ] I updated `SPEC.md`/`STACK.md`/`Memory.md` if this change introduces or
      changes a rule, not just code.

## Screenshots / recording (UI changes)

<!-- Drag in a screenshot or GIF if this touches presentation/. -->
