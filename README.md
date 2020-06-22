# Survey Web Application

Survey Web Application used for cathcing surveys.You can acces the page login/registrate and start answering questions on surveys that are administrator created.Administrator's services are included in the project.

## Getting Started

The projcet includes :
- Login
- Registration/Change Password Request
-Preferences of Registration Validation are also managed by the Survey's settings.
-------
CLIENTS :

-Home page is questions with a sidenav bar to display all the question for the survey and given types of answer's inputs.
-The type of inputs are also created when a question is created.There are 3 types Yes/No,Multiple Answer (radio),Multiple Choices (checkboxes).
-A quesiton can have a comment input below the answer input as well which is also given as a setting tweak when creating it.
-Preview for inputed answers
-Download Answered Survey as a PDF file for copy.(PDF files are stored outside the web accessible power)
-Clients can login and edit/see answers if the survey is active (Survey's Period).

-------
ADMINISTRATOR :

- Administrator services (Creating Surveys,Editing Surveys,Creating Periods for Surveys,Editing Periods for given Surveys,Creating Question for Surveys and etc.)
-Administrator can create,edit a given survey,and while creating a survey he can create certain general and specific questions and apply them to the survey.
The created general question will remain for other surveys and later use.
-There are settings for Show Previos Answers and Edit Previous Answers for a given survey.They are also tweakable.
-Surveys are managed by time periods.One Survey can have Multiple Periods or just one.
In case a survey has Multiple Periods, those can be created or deleted (overlaping validatio added).
-Administrators can request for a PDF,Excel,Word report of an expired answered survey and such will be provided for them to be downloaded.


### Prerequisites

To get access for this project and test it, the requirments are :
- Coldfusion
- MSSQL Server
- IDE Edtior (recommend : Eclipse CF Lint version)

### Installing

1.Instal MSSQL(ver. Developer) and Coldfusion(ver. Developer) on your machine
2.Instal MS SQL Managment Studio for Database integration and manipulation
3.Use the IDE editor to load files and test them
4.Finally test the web application in the browser

## Deployment

For deployment on live system you'll need the full version of Coldfusion and MSSQL services.

## Built With

* [Coldfusion](https://www.adobe.com/products/coldfusion-family.html) - The web framework used
* [MSSQL](https://www.microsoft.com/en-us/sql-server/sql-server-2019) - Server Deployment and Managment

## Authors

* **Stamencho Bogdanovski** - *Initial work* - [StamenchoB](https://github.com/StamenchoB)


