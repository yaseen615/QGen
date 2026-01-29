# QGen - NEET/JEE Question Bank

<div align="center">

![Flutter](https://img.shields.io/badge/Flutter-3.10+-02569B?style=for-the-badge&logo=flutter&logoColor=white)
![Dart](https://img.shields.io/badge/Dart-3.10+-0175C2?style=for-the-badge&logo=dart&logoColor=white)
![License](https://img.shields.io/badge/License-MIT-green?style=for-the-badge)
![Platform](https://img.shields.io/badge/Platform-Cross%20Platform-blueviolet?style=for-the-badge)

**A powerful cross-platform Flutter application for creating, managing, and generating professional question papers for NEET, JEE, and Class 11/12 examinations with LaTeX support.**

[Features](#-features) • [Installation](#-installation) • [Usage](#-usage) • [Syllabus](#-syllabus-coverage) • [Tech Stack](#-tech-stack) • [Contributing](#-contributing)

</div>

---

## 📋 Overview

QGen is a comprehensive question bank and paper generator specifically designed for **NEET**, **JEE (Main & Advanced)**, and **Class 11/12 (+1/+2)** competitive exam preparation. Built with Flutter, it offers a modern, intuitive interface with full support for mathematical equations using LaTeX notation.

Whether you're a coaching institute preparing mock tests, a teacher creating chapter-wise assessments, or a student organizing practice questions, QGen provides all the tools you need to create professional-quality question papers following the official NEET/JEE exam patterns.

### 🎯 Target Examinations

| Exam              | Subjects Covered                            |
| ----------------- | ------------------------------------------- |
| **NEET**          | Physics, Chemistry, Biology                 |
| **JEE Main**      | Physics, Chemistry, Mathematics             |
| **JEE Advanced**  | Physics, Chemistry, Mathematics             |
| **+1 (Class 11)** | All subjects with chapter-wise organization |
| **+2 (Class 12)** | All subjects with chapter-wise organization |

---

## ✨ Features

### 📝 Question Management

- **Create Questions** - Add questions with full LaTeX support for mathematical expressions, chemical equations, and scientific notation
- **Multiple Question Types** - MCQ, Numerical Value, Assertion-Reasoning, Short Answer, Long Answer, Fill in Blanks
- **Difficulty Levels** - Categorize questions as Easy, Medium, or Hard
- **NEET/JEE Marking Scheme** - Default 4 marks per MCQ with negative marking support
- **Edit & Delete** - Full CRUD operations on your question bank

### 📚 Complete Syllabus Coverage

- **Physics** - 29 chapters covering Class 11 & 12 (Mechanics to Modern Physics)
- **Chemistry** - 29 chapters covering Physical, Organic & Inorganic Chemistry
- **Biology** - 38 chapters covering Botany & Zoology (NEET specific)
- **Mathematics** - 27 chapters covering Algebra to Calculus (JEE specific)

### 📄 Paper Generation

- **NEET/JEE Pattern** - Generate papers following official exam patterns
- **Automatic Selection** - Auto-select questions based on total marks requirement
- **Manual Selection** - Hand-pick specific questions for your paper
- **Section-wise Organization** - Questions organized by Physics, Chemistry, Biology/Maths
- **PDF Export** - Generate professional PDF papers with proper formatting

### 🎨 Modern User Interface

- **Dark Theme** - Eye-friendly dark theme for extended study sessions
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
2. Select the subject (Physics/Chemistry/Biology/Mathematics)
3. Choose the chapter from the NEET/JEE syllabus
4. Select question type (MCQ, Numerical, Assertion-Reasoning, etc.)
5. Enter the question content (supports LaTeX for math/chemical equations)
6. Set difficulty level and marks (default: 4 marks for MCQ)
7. For MCQ: Add 4 options and select the correct answer
8. Click **Save Question**

### 2. Managing Question Bank

1. Go to **Question Bank** from the sidebar
2. Filter by subject, chapter, question type, or difficulty
3. Click on any question to view, edit, or delete it
4. Use the search functionality for quick access

### 3. Generating Question Papers

1. Navigate to **Generate Paper** from the sidebar
2. Configure paper settings:
   - Institution/Coaching name
   - Exam type (NEET/JEE Mock Test)
   - Date and duration
   - Total marks
3. Choose selection mode:
   - **Auto Select**: System picks questions to match total marks
   - **Manual Select**: Hand-pick questions from your bank
4. Preview the paper layout
5. Click **Generate PDF** to create the final document

### 4. Managing Subjects

1. Go to **Subjects** from the sidebar
2. View all 4 subjects with their complete chapter lists
3. Add custom chapters if needed
4. Edit or delete existing entries

---

## 📚 Syllabus Coverage

### Physics (29 Chapters)

<details>
<summary><b>Class 11 (Chapters 1-15)</b></summary>

| Ch. | Topic                                   |
| --- | --------------------------------------- |
| 1   | Physical World                          |
| 2   | Units and Measurements                  |
| 3   | Motion in a Straight Line               |
| 4   | Motion in a Plane                       |
| 5   | Laws of Motion                          |
| 6   | Work, Energy and Power                  |
| 7   | System of Particles & Rotational Motion |
| 8   | Gravitation                             |
| 9   | Mechanical Properties of Solids         |
| 10  | Mechanical Properties of Fluids         |
| 11  | Thermal Properties of Matter            |
| 12  | Thermodynamics                          |
| 13  | Kinetic Theory                          |
| 14  | Oscillations                            |
| 15  | Waves                                   |

</details>

<details>
<summary><b>Class 12 (Chapters 16-29)</b></summary>

| Ch. | Topic                                   |
| --- | --------------------------------------- |
| 16  | Electric Charges and Fields             |
| 17  | Electrostatic Potential and Capacitance |
| 18  | Current Electricity                     |
| 19  | Moving Charges and Magnetism            |
| 20  | Magnetism and Matter                    |
| 21  | Electromagnetic Induction               |
| 22  | Alternating Current                     |
| 23  | Electromagnetic Waves                   |
| 24  | Ray Optics and Optical Instruments      |
| 25  | Wave Optics                             |
| 26  | Dual Nature of Radiation and Matter     |
| 27  | Atoms                                   |
| 28  | Nuclei                                  |
| 29  | Semiconductor Electronics               |

</details>

---

### Chemistry (29 Chapters)

<details>
<summary><b>Class 11 (Chapters 1-14)</b></summary>

| Ch. | Topic                                    |
| --- | ---------------------------------------- |
| 1   | Some Basic Concepts of Chemistry         |
| 2   | Structure of Atom                        |
| 3   | Classification of Elements               |
| 4   | Chemical Bonding and Molecular Structure |
| 5   | States of Matter                         |
| 6   | Thermodynamics                           |
| 7   | Equilibrium                              |
| 8   | Redox Reactions                          |
| 9   | Hydrogen                                 |
| 10  | s-Block Elements                         |
| 11  | p-Block Elements (Group 13 & 14)         |
| 12  | Organic Chemistry - Basic Principles     |
| 13  | Hydrocarbons                             |
| 14  | Environmental Chemistry                  |

</details>

<details>
<summary><b>Class 12 (Chapters 15-29)</b></summary>

| Ch. | Topic                                   |
| --- | --------------------------------------- |
| 15  | Solid State                             |
| 16  | Solutions                               |
| 17  | Electrochemistry                        |
| 18  | Chemical Kinetics                       |
| 19  | Surface Chemistry                       |
| 20  | p-Block Elements (Group 15-18)          |
| 21  | d and f Block Elements                  |
| 22  | Coordination Compounds                  |
| 23  | Haloalkanes and Haloarenes              |
| 24  | Alcohols, Phenols and Ethers            |
| 25  | Aldehydes, Ketones and Carboxylic Acids |
| 26  | Amines                                  |
| 27  | Biomolecules                            |
| 28  | Polymers                                |
| 29  | Chemistry in Everyday Life              |

</details>

---

### Biology - NEET (38 Chapters)

<details>
<summary><b>Class 11 (Chapters 1-22)</b></summary>

| Ch. | Topic                                 |
| --- | ------------------------------------- |
| 1   | The Living World                      |
| 2   | Biological Classification             |
| 3   | Plant Kingdom                         |
| 4   | Animal Kingdom                        |
| 5   | Morphology of Flowering Plants        |
| 6   | Anatomy of Flowering Plants           |
| 7   | Structural Organisation in Animals    |
| 8   | Cell: The Unit of Life                |
| 9   | Biomolecules                          |
| 10  | Cell Cycle and Cell Division          |
| 11  | Transport in Plants                   |
| 12  | Mineral Nutrition                     |
| 13  | Photosynthesis in Higher Plants       |
| 14  | Respiration in Plants                 |
| 15  | Plant Growth and Development          |
| 16  | Digestion and Absorption              |
| 17  | Breathing and Exchange of Gases       |
| 18  | Body Fluids and Circulation           |
| 19  | Excretory Products and Elimination    |
| 20  | Locomotion and Movement               |
| 21  | Neural Control and Coordination       |
| 22  | Chemical Coordination and Integration |

</details>

<details>
<summary><b>Class 12 (Chapters 23-38)</b></summary>

| Ch. | Topic                                         |
| --- | --------------------------------------------- |
| 23  | Reproduction in Organisms                     |
| 24  | Sexual Reproduction in Flowering Plants       |
| 25  | Human Reproduction                            |
| 26  | Reproductive Health                           |
| 27  | Principles of Inheritance and Variation       |
| 28  | Molecular Basis of Inheritance                |
| 29  | Evolution                                     |
| 30  | Human Health and Disease                      |
| 31  | Strategies for Enhancement in Food Production |
| 32  | Microbes in Human Welfare                     |
| 33  | Biotechnology: Principles and Processes       |
| 34  | Biotechnology and its Applications            |
| 35  | Organisms and Populations                     |
| 36  | Ecosystem                                     |
| 37  | Biodiversity and Conservation                 |
| 38  | Environmental Issues                          |

</details>

---

### Mathematics - JEE (27 Chapters)

<details>
<summary><b>Class 11 (Chapters 1-14)</b></summary>

| Ch. | Topic                                   |
| --- | --------------------------------------- |
| 1   | Sets                                    |
| 2   | Relations and Functions                 |
| 3   | Trigonometric Functions                 |
| 4   | Complex Numbers and Quadratic Equations |
| 5   | Linear Inequalities                     |
| 6   | Permutations and Combinations           |
| 7   | Binomial Theorem                        |
| 8   | Sequences and Series                    |
| 9   | Straight Lines                          |
| 10  | Conic Sections                          |
| 11  | Introduction to 3D Geometry             |
| 12  | Limits and Derivatives                  |
| 13  | Statistics                              |
| 14  | Probability                             |

</details>

<details>
<summary><b>Class 12 (Chapters 15-27)</b></summary>

| Ch. | Topic                            |
| --- | -------------------------------- |
| 15  | Relations and Functions II       |
| 16  | Inverse Trigonometric Functions  |
| 17  | Matrices                         |
| 18  | Determinants                     |
| 19  | Continuity and Differentiability |
| 20  | Applications of Derivatives      |
| 21  | Integrals                        |
| 22  | Applications of Integrals        |
| 23  | Differential Equations           |
| 24  | Vector Algebra                   |
| 25  | Three Dimensional Geometry       |
| 26  | Linear Programming               |
| 27  | Probability II                   |

</details>

---

## 🛠 Tech Stack

| Technology            | Purpose                       |
| --------------------- | ----------------------------- |
| **Flutter**           | Cross-platform UI framework   |
| **Dart**              | Programming language          |
| **Hive**              | Local NoSQL database          |
| **Provider**          | State management              |
| **flutter_math_fork** | LaTeX rendering for equations |
| **pdf**               | PDF document generation       |
| **printing**          | PDF preview and printing      |
| **google_fonts**      | Typography enhancement        |
| **uuid**              | Unique identifier generation  |

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

## 🔧 Exam Patterns

### NEET Pattern

| Section   | Questions | Marks per Q | Negative Marking |
| --------- | --------- | ----------- | ---------------- |
| Physics   | 45        | 4           | -1               |
| Chemistry | 45        | 4           | -1               |
| Biology   | 90        | 4           | -1               |
| **Total** | **180**   |             | **720 marks**    |

### JEE Main Pattern

| Section                 | Questions | Marks per Q | Negative Marking |
| ----------------------- | --------- | ----------- | ---------------- |
| Physics (MCQ)           | 20        | 4           | -1               |
| Physics (Numerical)     | 5         | 4           | 0                |
| Chemistry (MCQ)         | 20        | 4           | -1               |
| Chemistry (Numerical)   | 5         | 4           | 0                |
| Mathematics (MCQ)       | 20        | 4           | -1               |
| Mathematics (Numerical) | 5         | 4           | 0                |
| **Total**               | **75**    |             | **300 marks**    |

---

## 🔧 LaTeX Support

QGen supports LaTeX notation for mathematical expressions and chemical equations:

### Examples

```latex
# Quadratic Formula
$x = \frac{-b \pm \sqrt{b^2 - 4ac}}{2a}$

# Chemical Equation
$2H_2 + O_2 \rightarrow 2H_2O$

# Integration
$\int_{0}^{\infty} e^{-x^2} dx = \frac{\sqrt{\pi}}{2}$

# Vector Notation
$\vec{F} = m\vec{a}$
```

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
- NCERT for the official syllabus structure
- All educators and students who inspired this tool

---

<div align="center">

**Made with ❤️ for NEET/JEE Aspirants**

If you find this project helpful, please consider giving it a ⭐

</div>
