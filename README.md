# Financial Planner

Mobile financial planner for Muslim users. Flutter · iOS + Android · **no server, no account, no data leaves the device**.

> Status: v0 scaffold — see [docs/product/brd.md](docs/product/brd.md) for scope.

## What it does (v1 target)

- Track holdings (cash, gold, stocks, funds).
- See net worth and ROI.
- Calculate **zakat** with cited sources.
- **Screen** stocks and funds for halal compliance.
- Track interest-free (`qard hasan`) debts.
- Track one saving goal.

## Stack

- Flutter (stable), Dart null-safe.
- Riverpod + feature-first folders.
- Money math in `Decimal`. Never `double`.
- Local storage: SQLite (Drift) behind repository interfaces — see [ADR-0001](docs/adr/0001-data-access-behind-repositories.md).
- English + Arabic (RTL).

## Running locally

```bash
flutter pub get
flutter run             # pick simulator from the menu
flutter test            # all tests
flutter analyze         # static checks
```

## Project rules

[CLAUDE.md](CLAUDE.md) · [docs/process/agent-loop.md](docs/process/agent-loop.md)

## License

TBD.
