# NewsReader (SwiftUI + Combine + MVVM)

A production-ready sample app that fetches **New York Times → Most Popular → Most Viewed** articles and presents them in a classic **master/detail** flow.  
It features strict MVVM separation, client-side pagination, pull-to-refresh, image caching, and comprehensive tests using **Swift Testing** (`@Test`).

> **Targets:** iOS 17+ • Xcode 16+ • Swift 5.9+  
> **Dependencies:** No third-party networking or persistence libraries.

---

## Table of contents

- [Project structure](#project-structure)
- [Modules (layers) overview](#modules-layers-overview)
- [App setup (API key)](#app-setup-api-key)
- [Build & run](#build--run)
- [Tests (Swift Testing @Test)](#tests-swift-testing-test)
- [Code coverage](#code-coverage)
- [Architecture & data flow](#architecture--data-flow)
- [Decisions & tradeoffs](#decisions--tradeoffs)
- [Known Issues](#known-issues)

---

## Project structure

```

NewsReader/
├─ NewsReader/
│  ├─ App/
│  │  └─ NewsReaderApp.swift
│  │  └─ AppEnvironment.swift
│  ├─ Core/
│  │  ├─ Mappers/      // Mappers for converting Data from API Models
│  │  ├─ Models/
│  │  │  ├─ APIModels/      // Models for receiving API Response
│  │  │  ├─ DataModels/     // DTOs
│  │  │  └─ EndPoints/     // Endpoints for APIs
│  │  ├─ Services/Network
│  │  │  ├─ HttpMethod.swift
│  │  │  ├─ HttpScheme.swift
│  │  │  ├─ RequestModel.swift
│  │  │  ├─ NetworkError.swift
│  │  │  ├─ NetworkService.swift   // For calling the APIs
│  │  │  └─ Endpoint.swift
│  │  ├─ Resositories/
│  │  │  └─ NewsRepository.swift   // For Fetching, Parsing and Mapping Data from APIs
│  │  ├─ Views/    // Common reusable views
│  ├─ Features/
│  │  ├─ ArticlesList/  // Views and View Models related to Articles List
│  │  └─ ArticleDetails/    // Views and View Models related to Articles Details
│  └─ Resources/    // App Resources and Assets
│
├─ NewsReaderTests/     // Unit tests (Swift Testing, @Test)
│  ├─ Mocks/
│  │  ├─ URLSession+Mock.swift
│  │  ├─ MockURLProtocol.swift
│  │  └─ MockNewsRepository.swift
│  └─ UnitTests/
│     ├─ NetworkServiceTests.swift
│     ├─ NewsRepositoryTests.swift
│     └─ ArticlesListViewModelTests.swift

````

---

## Modules (layers) overview

| Layer | Files | Responsibility |
| --- | --- | --- |
| **App** | `NewsReaderApp.swift` | App entry, DI bootstrap (`AppEnvironment`). |
| **Models** | `Article.swift`, `MostPopularResponse.swift` | Domain model (`Article`) and API DTOs; mapping from DTO → domain with Mappers. `NewsEndPoint` for endpoint mapping. |
| **Services** | `NetworkService`, `RequestModel.swift`, `NetworkError.swift`, `Endpoint.swift` | Transport layer: build `URLRequest` (using `RequestModel`), and executed via `NetworkService` using the given instance of `URLSession` + Combine, tries to parse response using the given `JSONDecoder`, map transport errors.  |
| **Repositories** | `NewsRepository.swift` | Business API wrapper for endpoints; returns `[Article]` publishers. Uses `ArticleApiToDataModelMapper` to map API model to domain model. |
| **Images** | `CachedAsyncImage.swift` | Image caching via `URLCache` with a small loader and SwiftUI wrapper. |
| **ViewModels** | `ArticlesListViewModel.swift`, `ArticleDetailsViewModel.swift` | State & intents: load/refresh, fetch images, open in browser. |
| **Views** | `ArticlesListView.swift`, `ArticleListItemView.swift`, `ArticleDetailsView.swift` | SwiftUI UI: master/detail, toolbar for selecting news section, and period. pull-to-refresh state views. |
| **Utilities** | `SafariView.swift` | Convenience wrapper for opening `SFSafariViewController` inside SwiftUI. |
| **Tests** | `MockURLProtocol.swift`, `URLSession+Mock.swift`, `MockNewsRepository.swift`, `*Tests.swift` | Unit tests (`@Test`), deterministic stubs via custom `URLProtocol` and `MockNewsRepository`. |

---

## Build & run

* Open the project in **Xcode 16+**.
* Select **NewsReader** scheme.
* Choose an iOS 17+ simulator (e.g., iPhone 15).
* **Run** (⌘R).

> The app defaults to `section=all-sections` & `period=7`. Change section and period from the toolbar menu.

---

## Tests (Swift Testing `@Test`)

> We use **Apple Swift Testing** (new `Testing` module) with `@Suite` & `@Test`.
> If you’re on older Xcode, you can either install the Swift Testing package or switch to the XCTest variants.

### Unit tests

* In Xcode: select the **NewsReader** scheme → **Test** (⌘U).

  * Targets: files in `Tests/` run as part of the test bundle.
  * Default behavior **stubs the network** with `MockURLProtocol` and JSON files under `Tests/TestAssets/`.

* From CLI:

  ```bash
  xcodebuild \
    -scheme NewsReader \
    -destination 'platform=iOS Simulator,name=iPhone 15' \
    test
  ```

---

## Code coverage

### In Xcode

* Edit Scheme → **Test** → enable **Gather coverage**.
* Run tests (⌘U), then open **Reports** (⌘9) → Coverage tab.

### From CLI

```bash
xcodebuild \
  -scheme NewsReader \
  -destination 'platform=iOS Simulator,name=iPhone 15' \
  -enableCodeCoverage YES \
  test

# Export a JSON summary (adjust DerivedData path as needed):
xcrun xccov view --report --json \
  ~/Library/Developer/Xcode/DerivedData/*/Logs/Test/*.xcresult > coverage.json
```

## Architecture & data flow

* **Strict MVVM**: Views are declarative & stateless; ViewModels own state and call Services; Services call the low-level `APIClient`.
* **Combine pipeline**: `URLSession.dataTaskPublisher → decode DTO → map to Article → publish on main`.
* **Pagination**: The NYT Most Popular endpoint don’t document server paging.

```
User → View (tap/scroll/refresh)
  → ViewModel intent (initialLoad / refresh / pull-to-refresh / select)
    → MostPopularService
      → APIClient (URLSession)
        → Decode DTO → Map → Save (DiskCache)
        → Publish → ViewModel updates @Published → View re-renders
```

---

## Decisions & tradeoffs

* **Combine over async/await**: aligns with `@Published` / streams; easy retry/backoff composition and test await of first value.
* **Client-side pagination**: endpoint doesn’t advertise server offsets.
* **Image Caching** Used `URLCache` (`returnCacheDataElseLoad`); offline returns cached bitmaps when available.
* **Data Caching** per constraint: Only `URLSession` backed caching.

---

## Known Issues

* **Hardcoded NYT App Key**: The key has been hardcoded, ideally it should be accessed via `.xcconfig` → Info.plist substitution to avoid hardcoding.
* **Search Bar always visible**: The search bar is always visible. Tried several approaches to get around this, but no luck. Search Bar should eith be added using `Menu`, or via header view to the top of the `List`.

---