# Code Playground

A Flutter-based code editor application with auto-fix and help features, built using GetX for state management.

## Features

### 1. Code Editor + Run Button
- **Code Editor**: Built using `code_text_field` package with Dart syntax highlighting
- **Run Button**: Executes code and displays output in the console
- **Console Output**: Shows execution results, errors, and print statements at the bottom of the screen

### 2. Auto-Fix Button
Automatically fixes common code issues using line-by-line rules:

#### Auto-Fix Rules:
1. **Missing Semicolons**
   - Adds semicolons to statements that need them
   - Detects statements like `print()`, assignments (`=`), and `return` statements
   - Skips lines that already end with semicolons, braces, or parentheses

2. **Extra Spaces**
   - Removes multiple consecutive spaces
   - Preserves indentation (leading whitespace)
   - Converts multiple spaces to single space in content

3. **Indentation**
   - Fixes basic indentation using 2-space indentation
   - Increases indent level after opening braces `{`
   - Decreases indent level before closing braces `}`
   - Properly indents nested code blocks

4. **Brackets/Parentheses**
   - Detects missing closing braces `}`
   - Automatically adds missing closing braces at the end of code
   - Counts opening and closing braces to ensure balance

### 3. Help Panel
- **Help Button**: Located in the top-right corner of the app bar
- **Side Panel**: Opens a slide-in panel from the right side
- **Search Functionality**: Users can type questions in the search field
- **Keyword Matching**: System responds based on keyword detection

#### Help Keywords:
The help system recognizes the following keywords and provides relevant tips:

- **Semicolon** or `;` - Explains semicolon usage in Dart
- **Run** or **Execute** - Instructions on how to run code
- **Indent** or **Indentation** - Help with code formatting
- **Bracket**, **Brace**, `{`, or `}` - Information about brace usage
- **Auto** or **Fix** - Explains the auto-fix feature
- **Print** - Help with print statements
- **Default** - Shows available help topics if no keyword matches

## Tech Stack

- **Framework**: Flutter
- **State Management**: GetX (`get: ^4.6.6`)
- **Code Editor**: `code_text_field: ^1.1.0`
- **Syntax Highlighting**: `flutter_highlight: ^0.7.0` and `highlight: ^0.7.0`

## Project Structure

```
lib/
├── controllers/
│   └── code_controller.dart      # GetX controller for state management
├── services/
│   ├── auto_fix_service.dart     # Auto-fix logic implementation
│   └── help_service.dart         # Help system with keyword matching
├── views/
│   └── home_view.dart            # Main UI view
├── widgets/
│   └── code_editor_widget.dart   # Code editor widget component
└── main.dart                     # App entry point
```

## How to Run

### Prerequisites
- Flutter SDK (>=3.0.0)
- Dart SDK
- Android Studio / VS Code with Flutter extensions

### Installation Steps

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd code_playground
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Run the app**
   ```bash
   flutter run
   ```

   Or use your IDE:
   - **VS Code**: Press `F5` or use the Run button
   - **Android Studio**: Click the Run button

### Running on Different Platforms

- **Web**: `flutter run -d chrome`
- **Android**: `flutter run -d <device-id>`
- **iOS**: `flutter run -d <device-id>` (macOS only)
- **Windows**: `flutter run -d windows`
- **Linux**: `flutter run -d linux`
- **macOS**: `flutter run -d macos`

## Usage

1. **Writing Code**: Type your Dart code in the code editor
2. **Running Code**: Click the green "RUN CODE" button to execute
3. **Auto-Fix**: Click the orange "AUTO FIX" button to automatically fix common issues
4. **Getting Help**: Click the help icon (?) in the top-right corner, then type your question

## Example Code

```dart
void main() {
  print("Hello, World!")
}
```

After clicking "AUTO FIX", it becomes:
```dart
void main() {
  print("Hello, World!");
}
```

## Auto-Fix Examples

### Example 1: Missing Semicolon
**Before:**
```dart
print("Hello")
```
**After:**
```dart
print("Hello");
```

### Example 2: Indentation
**Before:**
```dart
void main() {
print("Hello");
}
```
**After:**
```dart
void main() {
  print("Hello");
}
```

### Example 3: Extra Spaces
**Before:**
```dart
int  x  =  5;
```
**After:**
```dart
int x = 5;
```

### Example 4: Missing Braces
**Before:**
```dart
void main() {
  print("Hello");
```
**After:**
```dart
void main() {
  print("Hello");
}
```

## Help System Examples

Try asking:
- "How do I use semicolons?"
- "What is indentation?"
- "How to run code?"
- "Help with brackets"
- "What does auto fix do?"
- "How to use print?"

## Requirements Checklist

✅ Code Editor with syntax highlighting  
✅ Run Button with console output  
✅ Auto-Fix Button with all required rules  
✅ Help Button in top-right corner  
✅ Help Panel with search functionality  
✅ Keyword matching system  
✅ GetX state management  
✅ Flutter project structure  

## Deliverables

- ✅ Full Flutter project using GetX
- ⏳ Source code on GitHub (to be uploaded)
- ✅ README with documentation
- ⏳ Screen recording (to be created)

## Notes

- The code execution is simulated - it extracts print statements and displays them in the console
- The auto-fix system uses simple rule-based fixes and may not catch all edge cases
- The help system uses basic keyword matching for predefined topics

## License

This project is created for internship assignment purposes.
