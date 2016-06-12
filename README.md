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
* `SchoolClass` has many `Lesson` (100 of them)
* `Lesson` has many `LessonPart` (3 of them)
* `Student` has many `LessonPart` (through `Completion`)
* `LessonPart` has many `Student` (through `Completion`)

To track student's progress there will be a join table between `Student` and `LessonPart` (called
`Completion`).

The usual restful-style actions for each of those resources should be supported.

Completing the next part of a lesson can be done by creating a Completion model/record. Validation can be
added there to check for the completion of all 'prior' parts.

### Considerations

#### Experience concerns at the start of this work

* short on using RSpec, first time using it for my own projects (have used MiniTest up till now)
* first time using Rails 5
* first time using the new API-style application
* first time dealing with the json-api spec
* first time writing an API to serve an EmberJS client

#### LessonPart

It may be overkill to model the `Completion` as a separate resource. The simpler solution would be to have an `integer`
column (values 1, 2, or 3 probably behind an enum) or three `boolean` columns on the `Lesson` resource that get set
as the lesson parts become completed. But:

1. I wanted to challenge myself to deal with a `has_many ... :through` relationship in RSpec, and
2. I like the `Completion` having a name and possibly some other attributes could be added if this were a real-world
   problem.

##### REST-ful controllers for many-to-many relations in an API world

The implementation of the many-to-many relationship (`Student` <-> `LessonPart`) does not follow the typical Rails
convention of using `accepts_nested_attributes_for` in the model and having the controller go through some jui-jitsu
to mutate the join table records. I don't want to overload the concept of 'updating a student' (or 'creating a
student') to also handle managing the `LessonPart` completions.

Given this is an API-only application it made sense to keep the API 'clean'. Separating out the association actions
into their own controllers was the solution. The routes model the concept of 'completing a lesson':

* `GET /students/101/completed_lesson_parts` - show all completions for student #101
* `POST /students/101/completed_lesson_parts` (providing a `lesson_part_id` in the post params) - complete a lesson
  part for student #101
* `GET /students/101/completed_lesson_parts/2` - at the moment, this returns the sames result as `/lesson_parts/2`,
  it's going to be low value, but it should 404 if the lesson part has not been completed by this student
* `DELETE /students/101/completed_lesson_parts/2` - un-complete the lesson part for the student

Should, one day, there be a need to work on the completions from the `LessonPart` side (e.g. in the context of a
`LessonPart` adding a `Student` completing it), the extra controller to do that (mimicking
`Students::StudentsCompletionsController`) would slot right into the design. For now, I'm sticking to a
`Student`-centric view of the actions.
