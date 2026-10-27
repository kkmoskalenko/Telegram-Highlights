---
name: extract-telegram-ios
description: Extract reusable Telegram iOS features into TelegramHighlights, refresh upstream-derived code, or maintain extraction provenance. Use for feature boundary research, dependency decisions, and minimal adaptations of Telegram implementations.
---

# Extract Telegram iOS

Keep TelegramHighlights standalone and narrowly scoped, with minimal divergence from Telegram iOS. Apply only the steps relevant to the request; small maintenance changes do not require a full extraction.

## Establish the upstream baseline

- Prefer the sibling `../Telegram-iOS` checkout. Verify its revision and relevant local modifications; disclose unavailable access or uncertain freshness.
- Before editing implementation, inspect the affected upstream code, callers, and related tests. For a new extraction or dependency change, also inspect architecture, resources, build definitions, and direct and transitive dependencies to establish the feature boundary.
- Before changing existing derived code, inspect current upstream code and relevant history. Compare each file's recorded revision, current upstream, and local adaptations. Do not assume a rewrite is needed or silently import unrelated upstream changes.

## Agree on implementation scope

Present the included behavior, exclusions, retained public API, required adaptations, dependency choices, validation approach, and logical steps before copying or changing implementation. Resolve material ambiguities and obtain agreement where the existing request or approved plan does not already cover those decisions.

- Exclude Telegram-specific business logic. Discuss any resulting public API conflict before changing the API.
- Identify newly required third-party dependencies, including libraries vendored inside Telegram and their transitive dependencies. Ask explicitly how they should be connected unless the user has already specified that choice. Never silently copy, replace, or reimplement a dependency, especially a large or legacy implementation such as AsyncDisplayKit.
- Approval of a concrete plan covers its listed adaptations, import adjustments, and surgical removals. Explain unexpected source, API, behavior, or dependency changes and obtain approval before implementing them.
- For large features, agree on any layer review checkpoints during planning. Wait at those checkpoints; otherwise continue within the approved scope.

## Transfer and verify

1. Where practical, capture current upstream behavior with existing tests, fixtures, or repeatable UI checks. Treat this as the behavior baseline; discuss and obtain approval for bug fixes separately. Explain the rationale and obtain explicit permission before writing new tests, including temporary test code. Keep temporary comparison suites outside the package and do not commit them.
2. Copy files verbatim wherever possible. Preserve the retained public API, names, formatting, comments, and file boundaries. Remove only unrelated or unused portions required by the agreed scope. Avoid opportunistic cleanup, modernization, and abstractions; keep necessary package integration separate where practical.
3. For large features, transfer independent models and logic before dependent implementation and UI. Validate each logical layer and report its changes and results.
4. Transfer all existing upstream tests relevant to retained behavior, including required fixtures and resources, with minimal adaptations. Discuss test dependency conflicts or necessary omissions. Report missing or unrunnable upstream tests; do not invent replacements without permission.
5. Repeat baseline checks against the extracted implementation and run the transferred tests. Build, run, and test through Swift Package Manager or Xcode with an appropriate destination. Do not add Shell, Python, or other helper scripts.
6. Inspect the diff against each recorded upstream revision, update and validate provenance, and report intentional deviations, validation results, and limitations. For an upstream refresh, reconcile the old baseline, new upstream, and local code without overwriting approved adaptations or importing unrelated changes.

## Maintain provenance

Place `provenance.json` directly inside each relevant source or test target. Exclude it in that target's `Package.swift` declaration with `exclude: ["provenance.json"]`, preserving other exclusions.

Every report must declare `schemaVersion: 1`. Use this compact structure:

```json
{
  "schemaVersion": 1,
  "upstream": {
    "repository": "https://github.com/TelegramMessenger/Telegram-iOS"
  },
  "files": [
    {
      "source": "submodules/Display/Source/Font.swift",
      "local": "Font.swift",
      "revision": "fb0e62ba8a147f0821da6aa63c09da7d79a10111",
      "changes": []
    }
  ]
}
```

- Keep the upstream repository shared in `upstream.repository`. Record a required `revision` on **every** file entry, using the full 40-character upstream commit SHA that actually supplied that mapping. Treat each file's revision as authoritative.
- Preserve existing per-file revisions when migrating older reports. Expand an old `upstream.revision` only into entries that lack their own revision, then remove it from `upstream`. Do not substitute the current checkout revision or advance unrelated entries during a refresh.
- Keep `source` upstream-repository-relative and `local` target-relative, using forward slashes without absolute paths or `.`/`..` path segments.
- Describe current intentional differences in `changes`, not chronological activity. Keep notes short and omit unchanged behavior. Use `[]` when only the required attribution header differs; record import adjustments when present.
- Represent splits or combinations with multiple source/local mappings. Omit original package-only files from the upstream mapping.
- Do not duplicate Git history, timestamps, approvals, test output, or long explanations.
- Check that every new or changed report is valid JSON, includes the required per-file revisions, and maps the intended upstream and local files. Change `schemaVersion` only as part of an explicit format change.

Read and update an existing record in place. Do not relocate it or create a competing record unless the user requests a migration. When relocating a report, update its target exclusions as needed.

## Preserve source headers

- For derived files, follow the attribution and license convention in the [workspace template](../../../TelegramHighlights.xcworkspace/xcshareddata/IDETemplateMacros.plist). Include "Modified for this package..." only for changes beyond imports and the required header. Preserve upstream copyright notices.
- For original files, follow the [example project template](../../../Examples/TelegramHighlights.xcodeproj/xcshareddata/IDETemplateMacros.plist). Resolve the author at creation time: prefer the active Git author name, then the system's full user name. Ask if neither supplies a usable identity. Never hardcode a person or leave unresolved Xcode placeholders.
