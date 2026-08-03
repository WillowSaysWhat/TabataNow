# TabataNow

A Tabata timer for iOS. Create custom HIIT sessions, run workouts with audio cues, and track your progress — all stored locally on your device.

## Features

- **Custom sessions** — Define exercise time, rest time, repetitions, name, and description
- **Tabata timer** — Visual progress rings, phase indicators (Go / Rest), countdown beeps, and spoken cues
- **Dashboard** — Activity ring, medals, trophies, and a rolling three-day workout history
- **Profile & goals** — Daily and weekly minute/workout targets, streaks, and progress gauges
- **Offline-first** — All data persists locally via SwiftData; no account or network required

## Requirements

| Requirement | Version |
|---|---|
| Xcode | 16.4+ |
| iOS deployment target | 18.5+ |
| Swift | 5.0 |

## Getting Started

1. Clone the repository:
   ```bash
   git clone https://github.com/<your-username>/TabataNow.git
   cd TabataNow
   ```
2. Open `TabataNow/TabataNow.xcodeproj` in Xcode.
3. Select a simulator or connected device.
4. Build and run (`⌘R`).

## Project Structure

The app follows **MVVM** architecture. Source lives under `TabataNow/TabataNow/`.

```
TabataNow/
├── App/                    # App entry point and global configuration
├── Features/
│   ├── Dashboard/          # Home screen, activity ring, workout history
│   ├── Profile/            # Stats, goals, settings
│   ├── Session/            # Create, edit, list, and detail views
│   ├── Timer/              # Tabata timer UI and logic
│   └── TABView/            # Root tab bar navigation
├── Shared/                 # SwiftData models shared across features
└── Resources/              # Colours, assets, shared UI components
```

Each file contains one primary type. Business logic lives in ViewModels; Views remain composable and declarative.

## Data Models

### `TabataSession`

A saved workout configuration.

| Property | Type | Description |
|---|---|---|
| `id` | `UUID` | Unique identifier |
| `name` | `String` | Session name |
| `sessionDescription` | `String` | Short description |
| `exerciseTime` | `Int` | Work interval in seconds |
| `restTime` | `Int` | Rest interval in seconds |
| `repetitions` | `Int` | Number of rounds |
| `createdAt` | `Date` | Creation timestamp |
| `lastUpdatedAt` | `Date` | Last edit timestamp |

### `CompletedWorkout`

A record created when a timer session finishes.

| Property | Type | Description |
|---|---|---|
| `id` | `UUID` | Unique identifier |
| `completedAt` | `Date` | When the workout finished |
| `durationSeconds` | `Int` | Total elapsed time |
| `sessionName` | `String` | Name of the session completed |
| `exerciseTime` | `Int` | Work interval used |
| `restTime` | `Int` | Rest interval used |
| `repetitions` | `Int` | Rounds completed |

User preferences (daily/weekly goals, dark mode, medal state) are stored in `UserDefaults` via typed wrappers in `Features/Profile/` and `Features/Dashboard/`.

## App Flow

```
TABView (Tab Bar)
├── Dashboard
│   ├── Activity ring & medals
│   ├── 3-day history list
│   └── Select Workout → SessionListView → SessionDetailView → TimerView
├── History (placeholder)
└── Profile
    ├── Progress gauge & stat cards
    └── Settings (daily/weekly goals)
```

### Timer behaviour

- Alternates between **exercise** and **rest** phases for each repetition
- No rest interval after the final exercise round
- Announces "Go" and "Rest" via speech synthesis
- Plays countdown beeps at 3, 2, and 1 seconds
- Saves a `CompletedWorkout` to SwiftData on completion

## Design

- Dark-first UI with a **neon** accent colour
- SF Symbols throughout
- Custom tab bar styling configured in `TabataNowApp`

## Roadmap

- [ ] History tab (dedicated workout log)
- [ ] PushUps Now quick-start workout
- [ ] Awards and levelling system (medals/trophies currently use placeholder data on Dashboard)
- [ ] AI generated workouts
## License

See repository settings for license details.
