# Deliveroo iOS App

## Table of Contents
- [Overview](#overview)  
- [Architecture & Data Flow](#architecture--data-flow)  
- [Testing Strategy](#testing-strategy)  
- [Trade-offs](#trade-offs)  
- [Running the App & Tests](#running-the-app--tests)  
- [Future Improvements](#future-improvements)  
- [Thought Exercise](#thought-exercise)

---

## Overview
This is a simple Delivery Tracking iOS app built in **SwiftUI**. Users can:
- View a list of their orders.  
- Filter orders by status (PENDING, IN_TRANSIT, DELIVERED).  
- Tap an order to view its current status and see live updates over time.  

The app does **not use a real backend**; all data is simulated using mocked repositories and status streams.  


---

## Architecture & Data Flow

### Architecture
The app follows **MVVM (Model-View-ViewModel)**:
- **Model**: `Order`, `OrderStatus` – represents domain data.  
- **ViewModel**: `OrderListViewModel`, `OrderDetailsViewModel` – handles state, business logic, and communicates with repositories.  
- **View**: `OrderListView`, `OrderDetailsView` – observes view models via `@StateObject` and updates UI accordingly.  

**Advantages of MVVM**:
- Separation of concerns: UI code does not directly fetch or mutate data.  
- Testable: ViewModels are decoupled from SwiftUI and can be unit tested.  
- Extensible: Adding new screens or features does not require changes to existing UI logic.

### Data Flow
1. `OrderListView` asks `OrderListViewModel` to load orders.
2. ViewModel requests orders from `OrderRepository` (mocked).  
3. ViewModel updates its published `state` property.  
4. View reacts to state changes and renders:
    - Loading  
    - Error  
    - Empty  
    - Loaded list (with filtering).  
5. Selecting an order navigates to `OrderDetailsView`, which observes `OrderDetailsViewModel`:
    - ViewModel receives an `OrderStatusUpdating` stream.  
    - UI updates as statuses change (`pending → inTransit → delivered`).  

---

## Testing Strategy

### What is Tested
- **OrderListViewModel**:
  - `load()` sets `.loaded` state on successful fetch.
  - `.empty` state when no orders exist.
  - `.error` state when repository fails.
- Deterministic tests using `MockOrderRepository`.

### Design for Testability
- **Dependency Injection**: ViewModels accept repositories/updaters via initializer.  
- **Explicit State Modeling**: `OrderListState` and `OrderDetailsState` cover all UI states.  
- **AsyncStream**: Status updates are testable without timers in production.  

### What is Not Tested
- SwiftUI views directly (UI tests are optional).  
- Navigation and filtering in UI (covered indirectly via state).

### Test Influence on Design
- Explicit states (`.loading`, `.error`, `.empty`) allow straightforward assertions in unit tests.
- Repository behaviors (success/failure/delay) allow deterministic simulation of network conditions.

---

## Trade-offs

### Simplifications due to Time
- Only `OrderListViewModel` tested; `OrderDetailsViewModel` could have its own unit tests.  
- No persistence or offline caching.  
- Filtering logic is simple, no search or combined filters.  

### Potential Refactors
- Move filtering logic into ViewModel for easier testing.  
- Use real networking layer with Codable models.  

---

## Running the App & Tests

### App
1. Clone repository:
```bash
git clone https://github.com/leoanranjit/deliveroo
cd Deliveroo
```
2. Open `Deliveroo.xcodeproj` in Xcode.  
3. Select target device or simulator (supports iPhone SE → iPhone 15 Pro Max).  
4. Build & run (`Cmd+R`).

### Tests
- Run all tests in Xcode (`Cmd+U`)

---

## Future Improvements
- Real backend integration using REST API.  
- Offline support with local caching (CoreData/Realm).  

---

## Thought Exercise
1. **Real-time Driver Tracking**
   - Integrate MapKit with annotations representing drivers.  
   - Use WebSocket for live location updates.  
   - Update `OrderDetailsViewModel` to push location updates to the UI.  

2. **Isolating Map SDK for Testability**
   - Create a protocol `DriverLocationProviding` to abstract MapKit updates.  
   - Inject mock implementations in tests.  
   - Keeps UI and business logic testable without relying on MapKit.  

---

## Domain vs UI Models
- UI uses **explicit state enums** (`OrderListState`, `OrderDetailsState`).  
- Domain models (`Order`, `OrderStatus`) are never mutated by the UI.  
- If the API changes (e.g., new fields, statuses), only ViewModel mapping changes; UI code remains unchanged.

---

## Safe Evolution
- Adding a new status (e.g., `CANCELLED`) requires:
  - Updating `OrderStatus` enum.  
  - Updating `OrderDetailsViewModel` to handle new state.  
  - Updating tests to cover new transitions.  
- Tests protect against regression; invalid states will fail unit tests.

