## **MovieQuiz**

![Swift](https://img.shields.io/badge/Swift-%23FA7343?logo=swift&logoColor=white)
![Xcode](https://img.shields.io/badge/Xcode-%23147EFB?logo=xcode&logoColor=white)
![iOS 15+](https://img.shields.io/badge/iOS-15%2B-%23000000?logo=apple&logoColor=white)
![UIKit](https://img.shields.io/badge/UIKit-%23007AFF?logo=apple&logoColor=white)
![MVP](https://img.shields.io/badge/Architecture-MVP-%23696cff)
![Tests](https://img.shields.io/badge/Unit%20Tests-yes-%234CAF50)
![User Defaults](https://img.shields.io/badge/Persistence-User%20Defaults-%234CAF50)
![URLSession](https://img.shields.io/badge/Networking-URLSession-%23007AFF)
![IMDb API](https://img.shields.io/badge/API-IMDb-%23FFC107)
![License](https://img.shields.io/badge/License-MIT-%23000000)


**MovieQuiz** - is an app featuring quizzes about films from the IMDb Top 250 and the most popular movies.

## **Preview**

<p align="center">
  <img src="Images/RightScreen.png" alt="Right" width="400">
  <img src="Images/Record.png" alt="Record" width="400">
</p>

---

## **Links**

[Figma Design](https://www.figma.com/file/l0IMG3Eys35fUrbvArtwsR/YP-Quiz?node-id=34%3A243)

[API IMDb](https://tv-api.com/api#Top250Movies-header)

[Fonts](https://code.s3.yandex.net/Mobile/iOS/Fonts/MovieQuizFonts.zip)

## **App Description**

A single-page application with quizzes about films from the IMDb Top 250 and the most popular movies. The user answers questions about movie ratings. After each round, the app displays statistics on the number of correct answers and the user's best results. The goal is to answer all 10 questions in a round correctly.

## **Functional Requirements**

- **Splash Screen:**  
  Displays when the app launches.

- **Question Screen:**  
  After the splash screen, a question screen appears with the question text, an image, and two answer options: "Yes" and "No" (only one is correct).

- **Question Format:**  
  Each quiz question is based on the IMDb rating of a movie on a 10-point scale. For example: "Is this movie's rating higher than 6?"

- **Answer Feedback:**  
  When the user selects an answer, feedback is given indicating whether it is correct. The image border changes color accordingly.

- **Automatic Transition:**  
  After selecting an answer, the next question automatically appears after 1 second.

- **Round Completion:**  
  After 10 questions, an alert displays user statistics and an option to play again.

- **Statistics Include:**
  - Current round results (number of correct answers out of 10)
  - Number of quizzes played
  - Best score (highest result during the session, including date and time)
  - Overall quiz accuracy (percentage of correct answers)

- **Replay Option:**  
  Users can start a new round by clicking the "Play Again" button in the alert.

- **Error Handling:**  
  If data cannot be loaded, an alert appears with a message that something went wrong and a button to retry the network request.


## **Technical Requirements**

- **Device Support:**  
  Supports iPhone devices running iOS 15; portrait mode only.

- **UI Adaptation:**  
  Interface elements are adapted for iPhone screen resolutions starting from iPhone X. Layouts for iPhone SE and iPad are not provided.

- **Design Consistency:**  
  Screens match the design specifications — correct fonts, sizes, positioning, button dimensions, and margins as specified in the Figma design.
