# AI Workout Generation — Implementation Notes

This document explains how TabataNow's **AI-generated workout** feature works end-to-end, and lists every file involved in the implementation. It follows the app's MVVM architecture: Views stay declarative, business logic lives in ViewModels, networking lives in a Service, and configuration/secrets are isolated in their own layer.

## Overview

A user taps the sparkles (✨) button on the session list, fills in a short preferences form (location, resistance, equipment, focus, etc.), and taps **Generate**. The app builds a prompt from those preferences, calls the OpenAI Chat Completions API with a strict JSON schema, decodes the structured response into a `GeneratedTabataSessionDTO`, and hands it to the existing "New Session" form pre-filled for review before saving.

## High-level flow

```
SessionListView (✨ button)
        │  sheet
        ▼
GenerateSessionView            — preferences form
        │  Task { await viewModel.generate() }
        ▼
GenerateSessionViewModel.generate()
        │  calls
        ▼
OpenAIService.generateSession(preferences:)
        │  reads key from
        ├─── AppSecrets.openAIAPIKey  (Info.plist → Secrets.xcconfig)
        │  builds prompt from
        ├─── WorkoutGenerationPreferences.promptDescription()
        │  POSTs to api.openai.com, decodes JSON into
        ▼
GeneratedTabataSessionDTO
        │  navigationDestination
        ▼
NewSessionView(generated:)      — pre-filled review/edit form
        │  NewSessionViewModel(from: generated)
        │  user taps Save
        ▼
TabataSession (SwiftData model) — persisted, or "Regenerate" loops back
```

## Files involved

### 1. Entry point — `Features/Session/SessionList/SessionListView.swift`

Owns `isPresentingGenerateSession` (`@Published` on `SessionListViewModel`) and presents `GenerateSessionView` as a sheet when the sparkles toolbar button is tapped.

```39:64:TabataNow/TabataNow/Features/Session/SessionList/SessionListView.swift
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button {
                    viewModel.isPresentingGenerateSession = true
                } label: {
                    Image(systemName: "sparkles")
                }
                .accessibilityLabel("Generate AI Workout")
            }
            ToolbarItem(placement: .primaryAction) {
                Button {
                    viewModel.isPresentingNewSession = true
                } label: {
                    Image(systemName: "plus")
                }
                .accessibilityLabel("New Session")
            }
        }
        .sheet(isPresented: $viewModel.isPresentingNewSession) {
            NavigationStack {
                NewSessionView()
            }
        }
        .sheet(isPresented: $viewModel.isPresentingGenerateSession) {
            GenerateSessionView()
        }
```

### 2. Preferences model — `Models/WorkoutGenerationPreferences.swift`

Defines the form's data: `WorkoutLocation`, `ResistanceType`, `WeightEquipment`, `WorkoutFocus`, `BodyPart` (all small `CaseIterable` enums), and `WorkoutGenerationPreferences`, which bundles the user's selections and turns them into a human-readable `promptDescription()` string that becomes part of the LLM prompt (e.g. combining location, resistance/equipment, focus/body part, and which extra movements to include or exclude).

### 3. Generation form — `Features/Session/GenerateSession/GenerateSessionView.swift`

A SwiftUI `Form` bound to `viewModel.preferences`, with segmented pickers for location/resistance/focus, conditional pickers (equipment only if weighted, body part only if targeted), and toggles for burpees/running/cycling. The toolbar's **Generate** button triggers `viewModel.generate()`; a loading overlay shows while `isLoading` is true, and on success it navigates to `NewSessionView(generated:)` for review.

### 4. Generation view model — `Features/Session/GenerateSession/GenerateSessionViewModel.swift`

An `ObservableObject` holding `preferences`, `isLoading`, `errorMessage`, `generatedSession`, and `isPresentingPreview`. `generate()` calls the injected `OpenAIServiceProtocol`, stores the result, and flips `isPresentingPreview`; `regenerate()` resets state so the user can go back to the form. The service is injected via the initializer (defaulting to the real `OpenAIService()`), which is what makes the view model unit-testable/previewable with `MockOpenAIService`.

### 5. Networking — `Services/OpenAI/OpenAIService.swift`

The core integration with OpenAI:

- `OpenAIServiceProtocol` — a single async method, `generateSession(preferences:) -> GeneratedTabataSessionDTO`, so the view model doesn't depend on a concrete networking type.
- `OpenAIService` (real implementation):
  - Reads the API key via an injected `apiKeyProvider` closure (defaults to `{ AppSecrets.openAIAPIKey }`), throwing `OpenAIError.missingAPIKey` if it's `nil`.
  - Builds the request body: a `gpt-4o-mini` chat completion using `response_format: json_schema` (strict mode) with the schema from `GeneratedTabataSessionDTO.jsonSchema`, a system prompt describing Tabata timing rules, and a user prompt built from `preferences.promptDescription()`.
  - POSTs to `https://api.openai.com/v1/chat/completions`, validates the HTTP status, and decodes the model's JSON `content` string into `GeneratedTabataSessionDTO`.
  - Surfaces failures as typed `OpenAIError` cases (network, invalid response, decode failure, API error message).
- `MockOpenAIService` — a fixture implementation returning a canned `GeneratedTabataSessionDTO` (or a configured error), used by SwiftUI previews and tests so no network/API key is required during development.

### 6. Error handling — `Services/OpenAI/OpenAIError.swift`

A `LocalizedError` enum (`missingAPIKey`, `invalidResponse`, `decodingFailed`, `network(underlying:)`, `apiError(message:)`) with user-facing `errorDescription` strings, shown directly in `GenerateSessionView` via `viewModel.errorMessage`.

### 7. Response model — `Models/GeneratedTabataSessionDTO.swift`

The `Codable` shape returned by OpenAI: `name`, `description`, `exerciseTime`, `restTime`, `repetitions`. It also owns the **JSON Schema** (`jsonSchema` static property) passed to OpenAI's structured-output API to guarantee the response matches this shape, and `toTabataSession()`, which maps the DTO into the persisted `TabataSession` model.

### 8. Review/save form — `Features/Session/NewSession/NewSessionView.swift` + `NewSessionViewModel.swift`

Reused from manual session creation. `NewSessionViewModel` has a second initializer, `init(from generated: GeneratedTabataSessionDTO)`, which pre-fills the name/description/timing fields from the AI response. The view shows a **Regenerate** button (instead of Cancel) when it was opened from the generation flow, wired back to `GenerateSessionViewModel.regenerate()`, letting the user bounce back to the preferences form without losing their selections. Saving validates the fields and inserts a `TabataSession` into SwiftData.

### 9. Persisted model — `Shared/TabataSession.swift`

The final `@Model` (SwiftData) type that both manually created and AI-generated sessions are saved as — there's no separate storage path for AI-generated workouts once they're saved.

### 10. Secrets/configuration

The OpenAI API key is kept out of source control and injected at build time:

- `Config/Config.xcconfig` — the base project `.xcconfig`, `#include?`s `Secrets.xcconfig` if present.
- `Config/Secrets.example.xcconfig` — committed template showing the expected `OPENAI_API_KEY = ...` format.
- `Config/Secrets.xcconfig` — **gitignored**; the developer's real key, e.g. `OPENAI_API_KEY=sk-...`.
- `TabataNow/Info.plist` — declares `OpenAIAPIKey` as `$(OPENAI_API_KEY)`, substituted at build time from the xcconfig chain above. (This is a real, checked-in `Info.plist` — not Xcode's auto-generated one — because custom keys aren't reliably propagated through `GENERATE_INFOPLIST_FILE`/`INFOPLIST_KEY_*`.)
- `Utilities/AppSecrets.swift` — reads `OpenAIAPIKey` out of `Bundle.main`'s Info dictionary at runtime, trims it, and returns `nil` if it's missing/empty/still the placeholder value, which is what `OpenAIService` checks before making a request.

### 11. Tests — `TabataNowTests/WorkoutGenerationTests.swift`

Unit tests covering the pure logic pieces (no network calls):

- `promptDescription()` includes all selected preferences (location, resistance, equipment, focus, body part, included movements) and correctly excludes unselected ones.
- Home workouts get the "in-place variants" guidance appended.
- `GeneratedTabataSessionDTO` decodes correctly from a sample OpenAI JSON payload.
- `GeneratedTabataSessionDTO.toTabataSession()` maps fields correctly onto the persisted model.

## Full file list

| File | Role |
|---|---|
| `TabataNow/TabataNow/Features/Session/SessionList/SessionListView.swift` | Entry point (✨ button, presents sheet) |
| `TabataNow/TabataNow/Features/Session/GenerateSession/GenerateSessionView.swift` | Preferences form UI |
| `TabataNow/TabataNow/Features/Session/GenerateSession/GenerateSessionViewModel.swift` | Generation state & orchestration |
| `TabataNow/TabataNow/Models/WorkoutGenerationPreferences.swift` | Preferences model + prompt building |
| `TabataNow/TabataNow/Services/OpenAI/OpenAIService.swift` | OpenAI networking + mock |
| `TabataNow/TabataNow/Services/OpenAI/OpenAIError.swift` | Typed, user-facing errors |
| `TabataNow/TabataNow/Models/GeneratedTabataSessionDTO.swift` | Response model, JSON schema, mapping |
| `TabataNow/TabataNow/Features/Session/NewSession/NewSessionView.swift` | Review/edit/save UI (shared with manual flow) |
| `TabataNow/TabataNow/Features/Session/NewSession/NewSessionViewModel.swift` | Review/save state (shared with manual flow) |
| `TabataNow/TabataNow/Shared/TabataSession.swift` | Persisted SwiftData model |
| `TabataNow/TabataNow/Utilities/AppSecrets.swift` | Reads API key from Info.plist |
| `TabataNow/TabataNow/Info.plist` | Declares `OpenAIAPIKey` (`$(OPENAI_API_KEY)`) |
| `TabataNow/TabataNow/Config/Config.xcconfig` | Base build config, includes secrets |
| `TabataNow/TabataNow/Config/Secrets.example.xcconfig` | Template for developers |
| `TabataNow/TabataNow/Config/Secrets.xcconfig` | Real key (gitignored, not committed) |
| `TabataNow/TabataNowTests/WorkoutGenerationTests.swift` | Unit tests for prompt/DTO logic |

## Notes for extending this feature

- Swap the model or endpoint by editing `makeRequestBody(preferences:)` in `OpenAIService.swift`.
- Add a new preference by extending `WorkoutGenerationPreferences`, its `promptDescription()`, and the corresponding picker/toggle in `GenerateSessionView`.
- Add a new field to the generated result by updating `GeneratedTabataSessionDTO`, its `jsonSchema`, the system prompt, and `toTabataSession()`.
- For local development without hitting the network, inject `MockOpenAIService` into `GenerateSessionViewModel`/`GenerateSessionView` (already done in the `#Preview`).
