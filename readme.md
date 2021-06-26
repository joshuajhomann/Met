Sample app for 26.Jun.2021 meetup for aflockofswifts.org  an app using the Met API https://metmuseum.github.io .  We discussed:
  * Code generating the response with quicktype.io and manually cleaning up the generated code
  * A generic networking layer using the new `try await URLSession.shared.data(for:)` API
  * Using an `actor` for the service layer of the app
  * The new `AsyncImage` View in iOS 15
  * The new `.searchable`, `.searchCompletion` and `.onSubmit` modifiers in iOS 15
  * The new `@MainActor` annotation
  * Reviewed the `@AppStorage` property wrapper from iOS 14
  * discussed chaining `await` calls and a problem with using `withThrowingTaskGroup(of:` inside a `async`
![image](./preview.gif "Preview")