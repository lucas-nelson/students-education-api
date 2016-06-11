# students-education-api

A coding challenge to model students, teachers, lessons and students completing lessons in parts.

## The challenge

### Coding Project

_Company X_ is developing a new app for student education. Students complete lessons and their progress is recorded.
Each lesson has 3 parts - 1, 2 and 3. There are 100 lessons in total.

### PART 1

Generate a rails app that persists students and their progress.

Define routes for:
1.  setting a student's progress - progress should consist of a lesson and part number.
2.  returning a JSON representation of a student and their associated progress.

### PART 2

Teachers have classes containing number of students.

1.  Add a teacher model that is related to students
2.  Create a reports page for a teacher to view progress all of their students.

### PART 3

Calculating progress

1. add a method for updating student progress - this should verify that the student is only able to complete the next
   part number in sequence e.g.
   L1 P1, L1 P2, L1 P3, L2 P1, L2 P2 etc

## Environment

### Ruby

2.3.1

### Rails

5.0.0.rc1

## Installation

Clone the repository, then install the gems it depends on:

    cd students-education-api
    bundle install

## Setup

This application is configured to use a _PostgreSQL_ database, ensure you have one running, then create and seed the
database:

    bundle exec rails db:setup

## Operation

### Running the app

    bundle exec rails s

### Testing the app

    bundle exec rails test

## Interpretation of the problem

From the problem description, it would seem obvious to model resources / tables for:
* Student
* Teacher
* SchoolClass (don't want trouble conflicting with Ruby's Class class, so prefix with _School_)
* Lesson
* LessonPart

And some relationships:
* `Teacher` has many `SchoolClass`
* `SchoolClass` has many `Student`
* `SchoolClass` has many `Lesson`
* `Lesson` has many `LessonPart`

To track student's progress there will be a join table between `Student` and `LessonPart` (called
`CompletedLessonPart`).

The usual restful-style actions for each of those resources should be supported.

Completing the next part of a lesson can be done by creating a CompletedLessonPart model/record. Validation can be
added there to check for the completion of all 'prior' parts.
