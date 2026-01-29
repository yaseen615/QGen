# QGen - Question Paper Generator

<div align="center">

![Flutter](https://img.shields.io/badge/Flutter-3.10+-02569B?style=for-the-badge&logo=flutter&logoColor=white)
![Dart](https://img.shields.io/badge/Dart-3.10+-0175C2?style=for-the-badge&logo=dart&logoColor=white)
![License](https://img.shields.io/badge/License-MIT-green?style=for-the-badge)
![Platform](https://img.shields.io/badge/Platform-Cross%20Platform-blueviolet?style=for-the-badge)

**A powerful cross-platform Flutter application for creating, managing, and generating professional question papers with LaTeX support.**

[Features](#-features) • [Installation](#-installation) • [Usage](#-usage) • [Screenshots](#-screenshots) • [Tech Stack](#-tech-stack) • [Contributing](#-contributing)

</div>

---

## 📋 Overview

QGen (Question Generator) is a comprehensive desktop application designed for educators, teachers, and educational institutions to streamline the process of creating question papers. Built with Flutter, it offers a modern, intuitive interface with support for mathematical equations using LaTeX notation.

Whether you're a teacher preparing weekly tests or an institution generating standardized examinations, QGen provides all the tools you need to create professional-quality question papers in minutes.

---

## ✨ Features

### 📝 Question Management

- **Create Questions** - Add questions with full LaTeX support for mathematical expressions
- **Multiple Question Types** - Support for MCQ, Short Answer, Long Answer, and Fill in the Blanks
- **Difficulty Levels** - Categorize questions as Easy, Medium, or Hard
- **Marks Assignment** - Assign marks to each question for accurate paper totaling
- **Edit & Delete** - Full CRUD operations on your question bank

### 📚 Subject & Chapter Organization

- **Subject Management** - Create and manage multiple subjects
- **Chapter-wise Organization** - Organize questions by chapters within each subject
- **Pre-configured Subjects** - Comes with default subjects (Mathematics, Physics, Chemistry, Biology) with standard chapters
- **Custom Subjects** - Add your own subjects and chapters as needed

### 📄 Paper Generation

- **Automatic Selection** - Auto-select questions based on total marks requirement
- **Manual Selection** - Hand-pick specific questions for your paper
- **Customizable Headers** - Set institution name, exam title, date, and duration
- **Section-wise Organization** - Questions are automatically organized by type
- **PDF Export** - Generate professional PDF papers with proper formatting

### 🎨 Modern User Interface

- **Dark Theme** - Eye-friendly dark theme for extended usage
- **Sidebar Navigation** - Quick access to all features via collapsible sidebar
- **Dashboard Statistics** - View question counts, subject distribution at a glance
- **Responsive Design** - Works seamlessly on different screen sizes

### 💾 Local Storage

- **Offline First** - All data stored locally using Hive database
- **No Internet Required** - Full functionality without network connectivity
- **Fast Performance** - Lightning-fast local database operations

---

## 🚀 Installation

### Prerequisites

- [Flutter SDK](https://flutter.dev/docs/get-started/install) (3.10 or higher)
- [Dart SDK](https://dart.dev/get-dart) (3.10 or higher)
- A code editor (VS Code, Android Studio, or IntelliJ)

### Setup Instructions

1. **Clone the repository**

   ```bash
   git clone https://github.com/yaseen615/QGen.git
   cd QGen
   ```

2. **Install dependencies**

   ```bash
   flutter pub get
   ```

3. **Generate Hive adapters** (required for local storage)

   ```bash
   dart run build_runner build --delete-conflicting-outputs
   ```

4. **Run the application**
   ```bash
   flutter run
   ```

### Platform-Specific Builds

```bash
# Linux Desktop
flutter run -d linux

# Windows Desktop
flutter run -d windows

# macOS Desktop
flutter run -d macos

# Web
flutter run -d chrome
```

---

## 📖 Usage

### 1. Adding Questions

1. Navigate to **Create Question** from the sidebar
2. Select the subject and chapter
3. Choose the question type (MCQ, Short Answer, Long Answer, Fill in Blanks)
4. Enter the question content (supports LaTeX for math expressions)
5. Set difficulty level and marks
6. For MCQ: Add options and select the correct answer
7. Click **Save Question**

### 2. Managing Question Bank

1. Go to **Question Bank** from the sidebar
2. Use filters to find specific questions by subject, chapter, or type
3. Click on any question to view, edit, or delete it
4. Use the search functionality for quick access

### 3. Generating Question Papers

1. Navigate to **Generate Paper** from the sidebar
2. Configure paper settings:
   - Institution name
   - Exam title and date
   - Duration and total marks
3. Choose selection mode:
   - **Auto Select**: System picks questions to match total marks
   - **Manual Select**: Hand-pick questions from your bank
4. Preview the paper layout
5. Click **Generate PDF** to create the final document

### 4. Managing Subjects

1. Go to **Subjects** from the sidebar
2. View all configured subjects and their chapters
3. Add new subjects or chapters as needed
4. Edit or delete existing entries

---

## 🛠 Tech Stack

| Technology            | Purpose                      |
| --------------------- | ---------------------------- |
| **Flutter**           | Cross-platform UI framework  |
| **Dart**              | Programming language         |
| **Hive**              | Local NoSQL database         |
| **Provider**          | State management             |
| **flutter_math_fork** | LaTeX rendering              |
| **pdf**               | PDF document generation      |
| **printing**          | PDF preview and printing     |
| **google_fonts**      | Typography enhancement       |
| **uuid**              | Unique identifier generation |

---

## 📁 Project Structure

```
lib/
├── main.dart                 # App entry point
├── models/
│   ├── question.dart         # Question data model
│   ├── question.g.dart       # Hive adapter (generated)
│   ├── subject.dart          # Subject data model
│   ├── subject.g.dart        # Hive adapter (generated)
│   └── paper.dart            # Paper configuration model
├── screens/
│   ├── home_screen.dart      # Dashboard with statistics
│   ├── create_question_screen.dart  # Question creation
│   ├── question_bank_screen.dart    # Question management
│   ├── generate_paper_screen.dart   # Paper generation
│   └── subjects_screen.dart         # Subject management
├── services/
│   ├── storage_service.dart  # Hive database operations
│   └── pdf_service.dart      # PDF generation logic
├── utils/
│   ├── app_theme.dart        # Theme configuration
│   └── constants.dart        # App-wide constants
└── widgets/
    ├── sidebar_nav.dart      # Navigation sidebar
    ├── question_card.dart    # Question display widget
    └── latex_input.dart      # LaTeX input component
```

---

## 🎯 Default Subjects & Chapters

The application comes pre-configured with the following subjects:

| Subject         | Chapters                                                                                                                                                     |
| --------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| **Mathematics** | Real Numbers, Polynomials, Linear Equations, Quadratic Equations, Arithmetic Progressions, Triangles, Coordinate Geometry, Trigonometry, Circles, Statistics |
| **Physics**     | Physical World, Units and Measurements, Motion in a Straight Line, Motion in a Plane, Laws of Motion, Work Energy Power, Gravitation, Mechanical Properties  |
| **Chemistry**   | Chemical Reactions, Acids Bases and Salts, Metals and Non-metals, Carbon Compounds, Periodic Classification                                                  |
| **Biology**     | Life Processes, Control and Coordination, Reproduction, Heredity and Evolution, Environment                                                                  |

---

## 🔧 Configuration

### LaTeX Support

QGen supports LaTeX notation for mathematical expressions. Use `$...$` for inline math:

```
What is the value of $x$ in the equation $x^2 + 5x + 6 = 0$?
```

### Question Types

| Type             | Description                                |
| ---------------- | ------------------------------------------ |
| `MCQ`            | Multiple Choice Questions with 2-6 options |
| `Short Answer`   | Brief answers (2-3 lines)                  |
| `Long Answer`    | Detailed explanations                      |
| `Fill in Blanks` | Complete the sentence questions            |

### Difficulty Levels

| Level  | Recommended Marks |
| ------ | ----------------- |
| Easy   | 1-2 marks         |
| Medium | 3-4 marks         |
| Hard   | 5+ marks          |

---

## 🤝 Contributing

Contributions are welcome! Here's how you can help:

1. **Fork** the repository
2. **Create** a feature branch (`git checkout -b feature/AmazingFeature`)
3. **Commit** your changes (`git commit -m 'Add some AmazingFeature'`)
4. **Push** to the branch (`git push origin feature/AmazingFeature`)
5. **Open** a Pull Request

### Development Guidelines

- Follow Flutter/Dart style guidelines
- Write meaningful commit messages
- Update documentation for new features
- Test on multiple platforms before submitting

---

## 📝 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---

## 👨‍💻 Author

**Yaseen**

- GitHub: [@yaseen615](https://github.com/yaseen615)

---

## 🙏 Acknowledgments

- Flutter team for the amazing framework
- Contributors to the open-source packages used in this project
- All educators who inspired the creation of this tool

---

<div align="center">

**Made with ❤️ for Educators**

If you find this project helpful, please consider giving it a ⭐

</div>
