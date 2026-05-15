# Nex-Edu: AI-Powered Educational Platform
## Complete Implementation Plan

---

## PROJECT ARCHITECTURE OVERVIEW

### Tech Stack
- **Frontend**: Flutter (mobile & web)
- **Backend**: FastAPI (Python)
- **Authentication**: Firebase Auth
- **Database**: Firestore
- **AI Service**: Groq (Llama-3.1, free-tier) primary, with OpenAI fallback
- **File Processing**: PyMuPDF (PDFs), python-docx (Word docs)
- **Web Scraping**: BeautifulSoup + Selenium
- **Caching**: Redis (production) / In-memory (development)
- **Charts**: fl_chart (Flutter)
- **Notifications**: Firebase Cloud Messaging
- **Payments**: Stripe (subscription)
- **Deployment**: Docker + Railway/Vercel for FastAPI, Firebase Hosting for Flutter

---

## MODULE BREAKDOWN & FOLDER STRUCTURE

### A. FLUTTER FRONTEND (`/flutter`)
```
flutter/
├── pubspec.yaml
├── android/
├── ios/
├── lib/
│   ├── main.dart
│   ├── config/
│   │   ├── firebase_config.dart
│   │   ├── theme.dart (Euphoria design system)
│   │   └── constants.dart
│   ├── models/
│   │   ├── user_model.dart
│   │   ├── goal_model.dart
│   │   ├── syllabus_model.dart
│   │   ├── quiz_model.dart
│   │   ├── question_model.dart
│   │   └── progress_model.dart
│   ├── services/
│   │   ├── auth_service.dart
│   │   ├── firestore_service.dart
│   │   ├── api_service.dart
│   │   └── local_storage_service.dart
│   ├── screens/
│   │   ├── auth/
│   │   │   ├── login_screen.dart
│   │   │   ├── register_screen.dart
│   │   │   └── email_verification_screen.dart
│   │   ├── onboarding/
│   │   │   ├── goal_selection_screen.dart
│   │   │   ├── learning_preference_screen.dart
│   │   │   └── university_selection_screen.dart
│   │   ├── syllabus/
│   │   │   ├── syllabus_upload_screen.dart
│   │   │   ├── syllabus_preview_screen.dart
│   │   │   └── web_extraction_screen.dart
│   │   ├── quiz/
│   │   │   ├── starter_quiz_screen.dart
│   │   │   ├── custom_quiz_screen.dart
│   │   │   ├── quiz_question_screen.dart
│   │   │   └── quiz_results_screen.dart
│   │   ├── content/
│   │   │   ├── content_viewer_screen.dart
│   │   │   └── topic_selection_screen.dart
│   │   ├── study/
│   │   │   ├── study_timer_screen.dart
│   │   │   └── pomodoro_session_screen.dart
│   │   ├── progress/
│   │   │   ├── progress_dashboard_screen.dart
│   │   │   └── tough_topics_screen.dart
│   │   ├── account/
│   │   │   ├── profile_screen.dart
│   │   │   ├── settings_screen.dart
│   │   │   └── subscription_screen.dart
│   │   └── home/
│   │       └── home_screen.dart
│   ├── widgets/
│   │   ├── euphoria_button.dart
│   │   ├── euphoria_card.dart
│   │   ├── euphoria_input_field.dart
│   │   ├── loading_overlay.dart
│   │   ├── error_banner.dart
│   │   ├── progress_indicator.dart
│   │   └── quiz_animations.dart
│   ├── utils/
│   │   ├── validators.dart
│   │   ├── extensions.dart
│   │   └── logger.dart
│   └── navigation/
│       └── app_router.dart
├── test/
│   ├── auth_test.dart
│   ├── quiz_test.dart
│   └── integration_tests/

```

### B. FASTAPI BACKEND (`/backend`)
```
backend/
├── requirements.txt
├── Dockerfile
├── .env.example
├── .gitignore
├── main.py
├── config/
│   ├── firebase_config.py
│   ├── ai_service_config.py
│   └── settings.py
├── models/
│   ├── user_model.py
│   ├── syllabus_model.py
│   ├── quiz_model.py
│   ├── content_model.py
│   └── analytics_model.py
├── services/
│   ├── auth_service.py
│   ├── ai_service.py (Groq integration)
│   ├── syllabus_service.py
│   ├── quiz_generation_service.py
│   ├── content_generation_service.py
│   ├── scraping_service.py
│   ├── file_processing_service.py
│   ├── analytics_service.py
│   └── cache_service.py
├── routers/
│   ├── auth.py
│   ├── syllabus.py
│   ├── quiz.py
│   ├── content.py
│   ├── user.py
│   ├── analytics.py
│   └── health.py
├── schemas/
│   ├── user_schema.py
│   ├── syllabus_schema.py
│   ├── quiz_schema.py
│   └── analytics_schema.py
├── utils/
│   ├── validators.py
│   ├── logger.py
│   └── exceptions.py
├── middleware/
│   ├── auth_middleware.py
│   └── rate_limit_middleware.py
├── tests/
│   ├── test_auth.py
│   ├── test_quiz_generation.py
│   ├── test_syllabus_extraction.py
│   └── conftest.py
└── scripts/
    └── deploy.sh
```

### C. CONFIGURATION & DEPLOYMENT
```
root/
├── .github/
│   └── workflows/
│       ├── flutter_tests.yml
│       └── backend_tests.yml
├── docker-compose.yml
└── README.md
```

---

## MODULE RESPONSIBILITIES & CONNECTIONS

### 1. Authentication Module
**Files**: `auth_service.dart`, `auth_service.py`, `login_screen.dart`, `register_screen.dart`
- **Flutter**: Email/password login, Google sign-in, form validation, email verification
- **FastAPI**: Verify Firebase ID token, user record creation in Firestore
- **Firestore Schema**:
  ```
  users/{userId}
    ├── email
    ├── displayName
    ├── profilePicture
    ├── createdAt
    ├── emailVerified
    └── goal (set in next module)
  ```

### 2. Goal & Learning Preferences Module
**Files**: `goal_selection_screen.dart`, `learning_preference_screen.dart`
- **Flutter**: Radio buttons (Learn/Understand/Teach/Refer), toggles for reminders, dropdown for chapter/marks/custom
- **Firestore Schema**:
  ```
  users/{userId}/preferences
    ├── goal: "learn|understand|teach|refer"
    ├── learningType: "chapter|marks|custom"
    ├── remindersEnabled: boolean
    ├── reminderFrequency: "daily|weekly"
    └── updatedAt
  ```

### 3. University/Course/Semester Selection
**Files**: `university_selection_screen.dart`, `/routers/syllabus.py`
- **Flutter**: Searchable cascading dropdowns, Firestore persistence
- **FastAPI Endpoints**:
  - `GET /universities` → mock list of Indian universities
  - `GET /courses?university_id=...` → filtered courses
  - `GET /semesters?course_id=...` → filtered semesters
- **Firestore Schema**:
  ```
  users/{userId}/enrollment
    ├── universityId
    ├── universityName
    ├── courseId
    ├── courseName
    ├── semesterId
    ├── semesterNumber
    └── enrollmentDate
  ```

### 4. Syllabus Management Module
**Files**: `syllabus_service.py`, `syllabus_upload_screen.dart`, `syllabus_preview_screen.dart`
- **FastAPI**:
  - `POST /syllabus/extract_from_url` → BeautifulSoup scraping
  - `POST /syllabus/upload` → PDF/DOC processing + AI parsing + validation
  - Result merged and stored in Firestore
- **Firestore Schema**:
  ```
  syllabuses/{syllabusId}
    ├── universityId
    ├── courseId
    ├── semesterId
    ├── chapters[
    │   ├── id
    │   ├── name
    │   ├── marksWeight
    │   ├── topics[
    │   │   ├── id
    │   │   ├── name
    │   │   ├── subtopics[]
    │   │   └── difficulty: "easy|medium|hard"
    │   ]
    │   └── estimatedHours
    ]
    ├── totalMarks
    ├── source: "web|upload|hybrid"
    └── createdAt
  ```

### 5. Starter Quiz Module
**Files**: `starter_quiz_screen.dart`, `/services/quiz_generation_service.py`, `/routers/quiz.py`
- **Flutter**: Single-question UI, confidence slider (1-5), timer (60s), animations
- **FastAPI**: 
  - `GET /quiz/starter?syllabus_id=...&n=10` → calls Groq to generate 10 baseline questions
  - Caches results
- **Firestore**:
  ```
  quizzes/{quizId}
    ├── userId
    ├── syllabusId
    ├── type: "starter|custom|comprehension"
    ├── questions[
    │   ├── id
    │   ├── text
    │   ├── type: "mcq|true_false|fill_blank"
    │   ├── options[]
    │   ├── userAnswer
    │   ├── correctAnswer
    │   ├── confidence: 1-5
    │   ├── timeSpent: seconds
    │   └── isCorrect
    ]
    ├── score
    ├── accuracy%
    ├── completedAt
    └── difficulty
  ```

### 6. AI Service Integration (Groq)
**File**: `/services/ai_service.py`
- **Why Groq?**: Free tier, fast inference (Llama-3.1), good for educational content
- **Endpoints Called**:
  - Quiz generation: `/quiz/generate`
  - Content generation: `/content/generate`
  - Tough topic recommendations
- **Fallback**: OpenAI GPT-4 (paid, for premium users)

### 7. Dynamic Content Generation
**File**: `/services/content_generation_service.py`, `content_viewer_screen.dart`
- **FastAPI**: `POST /content/generate` → Groq generates explanations, summaries, diagrams
- **Flutter**: Markdown viewer, copy-protection (text selection disabled), speech synthesis
- **Response Schema**:
  ```
  {
    "topicId": "...",
    "content": "markdown explanation",
    "summary": "bullet points",
    "diagramSuggestion": "SVG or Markdown",
    "examples": ["example1", "example2"],
    "analogies": ["analogy1"]
  }
  ```

### 8. Timed Study Sessions (Pomodoro)
**Files**: `study_timer_screen.dart`, `/routers/quiz.py`
- **Flutter**: 25-min timer, circular progress, auto-quiz after
- **FastAPI**: `GET /quiz/for_topic?topic_id=...&n=5` → generates 5-question comprehension quiz
- **Firestore**: Track time spent per topic

### 9. Tough Topics Tracking
**Files**: `tough_topics_screen.dart`, `/services/analytics_service.py`
- **Logic**: After each quiz, user marks questions as "tough". System auto-removes after 4 non-tough appearances.
- **Firestore**:
  ```
  users/{userId}/toughTopics
    ├── topicId
    ├── markedCount
    ├── lastMarkedAt
    ├── revisitCount
    └── explanation (simplified)
  ```

### 10. Quiz Customization & Analytics
**Files**: `custom_quiz_screen.dart`, `/routers/analytics.py`, quiz results
- **Flutter**: Multi-select chapters, question count, difficulty, types
- **FastAPI**: `POST /quiz/customize` + `GET /analytics/user/{userId}`
- **Charts**: fl_chart for accuracy trends, speed vs understanding

### 11. Progress Tracking & Visualizations
**Files**: `progress_dashboard_screen.dart`, `/services/analytics_service.py`
- **Flutter**: Line chart (accuracy over time), bar chart (time per topic), circular progress per chapter
- **FastAPI**: `GET /progress/user/{userId}` → aggregated stats

### 12. Content Protection & Subscription
**Files**: Various screens, `/middleware/auth_middleware.py`
- **Flutter**: Text selection disabled, watermarks for free tier, paywall screens
- **FastAPI**: Check subscription status before premium endpoints
- **Stripe Integration**: Webhook handlers for payment events

### 13. Euphoria Design System
**File**: `theme.dart`
- **Colors**: 
  - Primary purple: #6B4E9A, #A8B5E8
  - Primary blue: #4A6FA5
  - Grays: #F5F5F5, #E0E0E0, #757575
  - Accents: #FF6B9D (pink), #00D4FF (cyan)
- **Components**: Custom buttons, cards, input fields with consistent styling
- **Animations**: Hero, Lottie (confetti/shake), page transitions

### 14. Learning Pattern Analysis
**File**: `/services/analytics_service.py`
- **Logic**: Cluster weak topics, detect speed vs accuracy correlation, suggest spaced-repetition
- **Endpoint**: `GET /recommendations/{userId}` → tailored based on user goal

### 15. Notifications & Reminders
**Files**: Various screens, `/services/notification_service.py`
- **Flutter**: Local notifications for timers, settings page for toggles
- **FastAPI**: Firebase Cloud Messaging setup, scheduled reminders

### 16. Account & Credits Page
**File**: `profile_screen.dart`, `settings_screen.dart`
- Fixed credits section with creator info

### 17. Error Handling & Offline Support
**Files**: `/utils/exceptions.py`, `local_storage_service.dart`
- **Flutter**: Hive caching, offline indicators, auto-sync
- **FastAPI**: Structured logging, error middleware

### 18. Testing & CI/CD
**Files**: `/tests/`, `.github/workflows/`
- **Flutter**: Widget + integration tests
- **FastAPI**: pytest with mock AI services
- **GitHub Actions**: Auto-run on PR

---

## KEY AI INTEGRATION POINTS

1. **Quiz Generation**: Groq → structured JSON questions with options, correct answers, explanations
2. **Content Generation**: Groq → markdown explanations, summaries, SVG diagram suggestions
3. **Syllabus Parsing**: Groq → understand OCR/HTML text → structure into chapters/topics/weightage
4. **Recommendation Engine**: Statistical analysis (no AI needed initially, can add later)

---

## FIRESTORE SECURITY RULES OUTLINE

```
- Users can only read/write their own documents
- Public: universities, courses, semesters (read-only)
- Shared syllabuses accessible based on enrollment
- Analytics restricted to owner user only
```

---

## DEPLOYMENT STRATEGY

- **Backend**: Docker container → Railway/DigitalOcean
- **Flutter**: Firebase Hosting (web), Play Store (Android), App Store (iOS)
- **CI/CD**: GitHub Actions for tests before merge
- **Environment**: `.env` for API keys, Firebase config, Groq API key

---

## NEXT STEPS

1. ✅ Create repo structure
2. ✅ Implement Piece 1: Project Setup & Dependencies
3. ✅ Implement Piece 2: Firebase Authentication
4. ✅ Implement Piece 3: Goal Setting & Learning Preferences
5. ✅ Implement Piece 4: University/Course/Semester Selection
6. ✅ Implement Piece 5: Backend Syllabus Web Extraction
7. ✅ Implement Piece 6: Syllabus Upload & Validation
8. ✅ Implement Piece 7: Starter Quiz UI & Animations

(Continue through all 20 pieces...)
