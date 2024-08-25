Here is a full description of your project with a focus on the architecture, configuration, dependencies, and functionalities:

---

## Project Overview

This Flutter application integrates product listing and e-commerce features with pagination, search, and filter capabilities. It follows the Clean Architecture pattern to maintain a clear separation of concerns and ensures code modularity. The project includes Firebase authentication and follows SOLID principles for better scalability and maintainability.

### Features:

1. **Dynamic Product Listing**: 
   - Implements custom pagination to display a list of products fetched from the DummyJSON API.
   - **Promotions**:
     - Displays a promotion tag for products priced under 50, showing the discount percentage.
     - Displays a "Flash Sale" tag for products priced under 10.
     - Shows a "New" tag for products created within the last 3 days.
  
2. **Search and Filter**:
   - Allows users to search for products by name.
   - Provides a price filter using a `RangeSlider`, with dynamic updates to the product list.

3. **Cart Management**: 
   - Users can add products to their cart.
   - Product details can be viewed.

4. **Authentication**: 
   - Basic email/password authentication using Firebase Authentication.
   - Supports Google Sign-In for easier user login.

5. **Local Notifications**: 
   - Sends local notifications to remind users about special promotions and offers.

---

## Project Structure

Following the Clean Architecture approach, the project is organized into three main layers: **Data**, **Domain**, and **Presentation**.

- **Data Layer**:
  - Contains models and repositories to manage data operations.
  - Handles API calls and data serialization/deserialization.
  
  *Files*:
  - `models/product.dart`: Contains the `Product` model and logic for JSON serialization.
  - `repositories`: Includes the repository pattern classes for Firebase and product management.

- **Domain Layer**:
  - Houses the business logic and domain-specific rules.
  - Contains abstract repository interfaces and entities.

  *Files*:
  - `auth_repository.dart`: Interface for authentication operations.
  - `product_repository.dart`: Interface for product-related operations.
  - `product_repository_impl.dart`: Implementation of the product repository, which handles data retrieval from the API.

- **Presentation Layer**:
  - Manages UI components and state management using BLoC.
  - Organizes pages, widgets, and BLoC classes by feature.

  *Files*:
  - `pages`: Contains individual UI screens for authentication, product list, product details, cart, etc.
  - `blocs`: Includes BLoC files for managing state for authentication (`AuthBloc`), products (`ProductBloc`), and splash screens.

---

## Dependencies

The following dependencies are used in the project:

```yaml
dependencies:
  flutter_bloc: ^8.0.0
  http: ^0.13.3
  flutter_local_notifications: ^9.2.0
  equatable: ^2.0.5
  awesome_dialog: ^3.2.1
  firebase_core: ^3.3.0
  firebase_auth: ^5.1.4
  google_sign_in: ^6.2.1
  shared_preferences: ^2.3.2
  connectivity_plus: ^6.0.5
  infinite_scroll_pagination: ^4.0.0
  fluttertoast: ^8.2.8

environment:
  sdk: '>=3.2.0 <4.0.0'
```

- **`flutter_bloc`**: For BLoC (Business Logic Component) state management.
- **`http`**: For handling API calls to DummyJSON.
- **`flutter_local_notifications`**: To send local notifications to users.
- **`equatable`**: Simplifies the comparison of objects in Dart and enhances Bloc's state management.
- **`awesome_dialog`**: Provides customizable and user-friendly dialogs.
- **`firebase_core`**: Core Firebase SDK integration.
- **`firebase_auth`**: For Firebase Authentication, including email/password and Google Sign-In.
- **`google_sign_in`**: Allows users to authenticate using their Google account.
- **`shared_preferences`**: For persisting small amounts of data locally (e.g., user session).
- **`connectivity_plus`**: For monitoring network connectivity status.
- **`infinite_scroll_pagination`**: Implements infinite scrolling for product lists.
- **`fluttertoast`**: Displays brief notifications at the bottom of the screen.

---

## Core Functionalities

### 1. **Dynamic Product List with Pagination**:
   The app fetches data from the DummyJSON API, displaying products dynamically with pagination. Based on business logic, specific tags (such as promotion, flash sale, and new) are displayed depending on the product's price or creation date.

### 2. **Search and Filter**:
   Users can search for products by name or filter them using a range slider based on the price. The list updates automatically according to the user's input.

### 3. **Cart**:
   A cart management system is implemented, allowing users to add products, view their details, and manage the cart's content.

### 4. **Authentication**:
   Firebase Authentication is used for email/password login, and Google Sign-In is integrated for an easier login process. Security and safe data handling practices are applied throughout the app.

### 5. **Notifications**:
   Using the `flutter_local_notifications` package, the app sends local reminders to users about special promotions and discounts.

---

## Architecture

The project follows Clean Architecture, keeping a clear separation of responsibilities:

1. **Data Layer**: 
   Responsible for accessing external data sources (e.g., APIs, local storage). Implements repositories to abstract data operations from other layers.

2. **Domain Layer**: 
   Contains business logic, including the use of repositories and entities. Acts as a bridge between the Data and Presentation layers.

3. **Presentation Layer**: 
   Contains UI logic and interacts with the Domain layer through BLoC. It includes screens and widgets organized by feature.

---

## Security & SOLID Principles

- **Secure Authentication**: Firebase Authentication is implemented to ensure safe user login and storage of sensitive information.
- **SOLID Principles**: The project is structured in a way that each class has a single responsibility. Abstraction is used to decouple dependencies, making the code more maintainable and testable.

---

## Usage Guide

1. **Clone the repository**.
2. **Install dependencies** by running `flutter pub get`.
3. **Set up Firebase**:
   - Configure Firebase for your Flutter app by following the Firebase documentation.
   - Update `firebase_options.dart` with your project's Firebase configuration.
4. **Run the app** using `flutter run`.

Enjoy building and expanding the functionality!
