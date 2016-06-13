# Usage

Below is a demonstration of how to use the API. It assumes a database that's been seeded with the fake data in
`seeds.rb`.

First set the endpoint. You can use the demonstration app running on Heroku:

    URL_BASE='https://students-education-api.herokuapp.com'

    # or to use a locally running application
    #   URL_BASE="http://localhost:3000"

## Part 1

### Lessons#show

Observe the first lesson and its (three) parts:

    curl "${URL_BASE}/lessons/1"

Result:

>     {"data":{"id":"1",
>              "type":"lessons",
>              "attributes":{"name":"1. Defluo quia audeo","ordinal":1},
>              "relationships":{"lesson-parts":{"data":[{"id":"1","type":"lesson-parts"},
>                                                       {"id":"2","type":"lesson-parts"},
>                                                       {"id":"3","type":"lesson-parts"}]}}},
>      "included":[{"id":"1",
>                   "type":"lesson-parts",
>                   "attributes":{"lesson-id":1,
>                                 "name":"1. Sint confero absorbeo tepesco chirographum",
>                                 "ordinal":1}},
>                  {"id":"2",
>                   "type":"lesson-parts",
>                   "attributes":{"lesson-id":1,
>                                 "name":"2. Aequus taceo voluptatum celebrer surgo",
>                                 "ordinal":2}},
>                  {"id":"3",
>                   "type":"lesson-parts",
>                   "attributes":{"lesson-id":1,
>                                 "name":"3. Textus ciminatio surculus vorago sordeo",
>                                 "ordinal":3}}]}

### Students#show

Observe the first student:

    curl "${URL_BASE}/students/1"

Result:

>     {"data":{"id":"1",
>              "type":"students",
>              "attributes":{"name":"Bart Simpson",
>                            "email":"bart_simpson@example.net"}}}

### Students::CompletedLessonParts#index

Observe that the student has not completed any lesson parts:

    curl "${URL_BASE}/students/1/completed_lesson_parts"

Result:

>     {"data":[]}

### Students::CompletedLessonParts#create

Have that student complete the first part of the first lesson:

    curl \
      -H "Content-Type: application/vnd.api+json" \
      -H "Accept: application/vnd.api+json" \
      -w '\nstatus: %{http_code}\n' \
      -X POST \
      -d '{"data":{"type":"completions","attributes":{"lesson_part_id":1}}}' \
      "${URL_BASE}/students/1/completed_lesson_parts"

Result:

>     status: 204

Observe that the student has now completed one lesson part:

    curl "${URL_BASE}/students/1/completed_lesson_parts"

Result:

>     {"data":[{"id":"1",
>               "type":"lesson-parts",
>               "attributes":{"lesson-id":1,
>                             "name":"1. Sint confero absorbeo tepesco chirographum",
>                             "ordinal":1}}]}

#### Complete more lesson parts

Complete the second and third parts of the first lesson:

    curl \
      -H "Content-Type: application/vnd.api+json" \
      -H "Accept: application/vnd.api+json" \
      -w '\nstatus: %{http_code}\n' \
      -X POST \
      -d '{"data":{"type":"completions","attributes":{"lesson_part_id":2}}}' \
      "${URL_BASE}/students/1/completed_lesson_parts" && \
    curl \
      -H "Content-Type: application/vnd.api+json" \
      -H "Accept: application/vnd.api+json" \
      -w '\nstatus: %{http_code}\n' \
      -X POST \
      -d '{"data":{"type":"completions","attributes":{"lesson_part_id":3}}}' \
      "${URL_BASE}/students/1/completed_lesson_parts"

Result:

>     status: 204
>
>     status: 204

Observe that the student has now completed three lesson parts:

    curl "${URL_BASE}/students/1/completed_lesson_parts"

Result:

>     {"data":[{"id":"1",
>               "type":"lesson-parts",
>               "attributes":{"lesson-id":1,
>                             "name":"1. Sint confero absorbeo tepesco chirographum",
>                             "ordinal":1}},
>              {"id":"2",
>               "type":"lesson-parts",
>               "attributes":{"lesson-id":1,
>                             "name":"2. Aequus taceo voluptatum celebrer surgo",
>                             "ordinal":2}},
>              {"id":"3",
>               "type":"lesson-parts",
>               "attributes":{"lesson-id":1,
>                             "name":"3. Textus ciminatio surculus vorago sordeo",
>                             "ordinal":3}}]}

### Students::CompletedLessonParts#destroy

Remove the completion for the third lesson:

    curl \
      -w '\nstatus: %{http_code}\n' \
      -X DELETE \
      "${URL_BASE}/students/1/completed_lesson_parts/3"

Result:

>     status: 204

Observe the student now has only completed two lesson parts:

    curl "${URL_BASE}/students/1/completed_lesson_parts"

Result:

>     {"data":[{"id":"1",
>               "type":"lesson-parts",
>               "attributes":{"lesson-id":1,
>                             "name":"1. Sint confero absorbeo tepesco chirographum",
>                             "ordinal":1}},
>               {"id":"2",
>               "type":"lesson-parts",
>               "attributes":{"lesson-id":1,
>                             "name":"2. Aequus taceo voluptatum celebrer surgo",
>                             "ordinal":2}}]}

Remove the other completions to return the database to it's initial state:

    curl \
      -w '\nstatus: %{http_code}\n' \
      -X DELETE \
      "${URL_BASE}/students/1/completed_lesson_parts/2" && \
    curl \
      -w '\nstatus: %{http_code}\n' \
      -X DELETE \
      "${URL_BASE}/students/1/completed_lesson_parts/1"

Result:

>     status: 204
>
>     status: 204

Observe the student has no completed lesson parts now:

    curl "${URL_BASE}/students/1/completed_lesson_parts"

Result:

>     {"data":[]}
