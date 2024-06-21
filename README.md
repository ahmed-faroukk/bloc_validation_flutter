# Validation with BLoC

## Overview
The app uses the BLoC (Business Logic Component) pattern to manage state and handle validation logic. BLoC helps to separate the presentation layer from the business logic, making the app more modular and testable.

## Implementation

### BLoC Structure:
- **AuthBloc:** Handles authentication events and states.
- **AuthEvent:** Defines events like email changes, password changes, and form submission.
- **AuthState:** Defines states such as initial, loading, authenticated, and error.

### Validation Logic:
- Implement validation in the BLoC for input fields such as email and password.
- Use streams to manage validation errors and states.

## Unit Testing
To test this validation functionality works as expected.

# app flow 
![validation](https://github.com/ahmed-faroukk/bloc_validation_flutter/assets/72602749/2b0d9d4b-9c6d-442b-8905-8f624b1df4af)

# demo 
https://github.com/ahmed-faroukk/bloc_validation_flutter/assets/72602749/7ed9256c-c335-475d-a11b-5e3daf4fc8e5

