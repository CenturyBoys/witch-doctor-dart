# How it compares

| | **witch_doctor** | get_it | injectable | kiwi | riverpod |
|---|:--:|:--:|:--:|:--:|:--:|
| Type-safe registration | ✅ | ✅ | ✅ | ✅ | ✅ |
| Code generation required | ❌ optional | ❌ | ✅ | ❌ optional | ❌ |
| Deps resolved inside factory | ✅ `Injector` | manual | ✅ | ✅ | ✅ `ref` |
| Named, mergeable scopes | ✅ last-wins | partial | via get_it | ❌ | overrides |
| Factory / singleton / lazy | ✅ | ✅ | ✅ | ✅ | providers |
| Cycle detection | ✅ | ❌ | ❌ | ❌ | ✅ |
| Zero runtime dependencies | ✅ | ✅ | ❌ | ✅ | ❌ |
| Primary focus | pure-Dart DI | service locator | codegen over get_it | DI container | state + DI |

## Where Witch Doctor fits

Witch Doctor's sweet spot is when you want:

- **get_it-level simplicity and type safety** — closure registration, resolve by
  type, no reflection;
- **kiwi-style dependency resolution inside registrations** — the `Injector`
  passed into every factory;
- **named scopes you can merge and override** — great for prod/test/environment
  wiring;
- the **option, not the obligation,** of **injectable-style code generation**;

all with **zero runtime dependencies** and built-in **cycle detection**.

If you need full app state management with reactive rebuilds, reach for riverpod.
If you want a pure-Dart DI container that stays out of your way, Witch Doctor is
designed for exactly that.
