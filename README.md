# Rituals

A local-first Flutter app for keeping daily habits — tasks you check off, and
squares that remember whether you did.

## Features

- **Tasks** — a daily list with swipe-to-edit and swipe-to-delete, repeat
  and alarm tags, and a completion toggle that doesn't fight the layout when
  a task is skipped.
- **Consistency heatmap** — a hand-drawn, GitHub-style grid of the last
  year, greener the more was kept each day. Always fills the card, even on
  day one: weeks before you started are drawn muted rather than left out.
- **At a glance** — current streak, longest streak, completion rate, active
  days, and best day, read straight off the tracked history.
- **Month by month** — a running breakdown underneath the heatmap.

## Tech stack

- **Flutter** (Dart 3 — sealed classes, records, pattern matching)
- **flutter_bloc** — Cubit for state management
- **isar_community** — local, offline-first storage
- **flutter_slidable** — swipe actions on task rows
- **GetIt** — dependency injection
- A hand-rolled sealed-class `Result<T>` in place of `dartz`/`fpdart`

## Architecture

Feature-first, loosely clean-architecture layered — but not every feature
carries the full stack, and that's deliberate rather than unfinished:

```
lib/
  core/
    di/           # GetIt setup
    theme/         # colors, typography
    utils/
  features/
    tasks/
      data/
        models/
      presentation/
        cubit/
        pages/
        widgets/
    heatmaps/
      data/
      presentation/
        cubit/
        widgets/
```

- **tasks** has a single local data source and no abstract repository
  interface — there's nothing to swap it out for yet, so the indirection
  would just be ceremony.
- **heatmaps** has no data or domain layer of its own. It's a read-model
  nested under `tasks/presentation`, reading straight through
  `TaskRepository`.

## Design

Two typefaces: **Fraunces** for display, **Manrope** for everything else.
Palette runs parchment (background), ink (text), moss (what's done), clay
(what needs attention).

The heatmap is drawn by hand rather than with `flutter_heatmap_calendar` —
that package paints every date in one color and scrolls its weekday legend
off screen, which doesn't hold up once you actually want to read a specific
day.

## Getting started

```bash
flutter pub get

# Isar's models are code-generated
flutter pub run build_runner build --delete-conflicting-outputs

flutter run
```

## Status

Personal project, actively evolving — expect breaking changes between
commits.
