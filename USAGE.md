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
>                   "attributes":{"name":"1. Sint confero absorbeo tepesco chirographum",
>                                 "ordinal":1}},
>                  {"id":"2",
>                   "type":"lesson-parts",
>                   "attributes":{"name":"2. Aequus taceo voluptatum celebrer surgo",
>                                 "ordinal":2}},
>                  {"id":"3",
>                   "type":"lesson-parts",
>                   "attributes":{"name":"3. Textus ciminatio surculus vorago sordeo",
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

Observe that _Bart Simpson_ has not completed any lesson parts:

    curl "${URL_BASE}/students/1/completed_lesson_parts"

Result:

>     {"data":[]}

### Students::CompletedLessonParts#create

Have _Bart Simpson_ complete _1. Sint confero absorbeo tepesco chirographum_:

    curl \
      -H "Content-Type: application/vnd.api+json" \
      -H "Accept: application/vnd.api+json" \
      -w '\nstatus: %{http_code}\n' \
      -X POST \
      -d '{"data":{"type":"completions","attributes":{"lesson_part_id":1}}}' \
      "${URL_BASE}/students/1/completed_lesson_parts"

Result:

>     status: 204

Observe that _Bart Simpson_ has now completed _1. Sint confero absorbeo tepesco chirographum_:

    curl "${URL_BASE}/students/1/completed_lesson_parts"

Result:

>     {"data":[{"id":"1",
>               "type":"lesson-parts",
>               "attributes":{"name":"1. Sint confero absorbeo tepesco chirographum",
>                             "ordinal":1}}]}

#### Complete more lesson parts

Complete  and _3. Textus ciminatio surculus vorago sordeo_:

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

Observe that _Bart Simpson_ has now completed all three lesson parts:

    curl "${URL_BASE}/students/1/completed_lesson_parts"

Result:

>     {"data":[{"id":"1",
>               "type":"lesson-parts",
>               "attributes":{"name":"1. Sint confero absorbeo tepesco chirographum",
>                             "ordinal":1}},
>              {"id":"2",
>               "type":"lesson-parts",
>               "attributes":{"name":"2. Aequus taceo voluptatum celebrer surgo",
>                             "ordinal":2}},
>              {"id":"3",
>               "type":"lesson-parts",
>               "attributes":{"name":"3. Textus ciminatio surculus vorago sordeo",
>                             "ordinal":3}}]}

### Students::CompletedLessonParts#destroy

Remove the completion for the _3. Textus ciminatio surculus vorago sordeo_:

    curl \
      -w '\nstatus: %{http_code}\n' \
      -X DELETE \
      "${URL_BASE}/students/1/completed_lesson_parts/3"

Result:

>     status: 204

Observe that _Bart Simpson_ now has only completed two lesson parts:

    curl "${URL_BASE}/students/1/completed_lesson_parts"

Result:

>     {"data":[{"id":"1",
>               "type":"lesson-parts",
>               "attributes":{"name":"1. Sint confero absorbeo tepesco chirographum",
>                             "ordinal":1}},
>               {"id":"2",
>               "type":"lesson-parts",
>               "attributes":{"name":"2. Aequus taceo voluptatum celebrer surgo",
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

Observe that _Bart Simpson_ has no completed lesson parts now:

    curl "${URL_BASE}/students/1/completed_lesson_parts"

Result:

>     {"data":[]}

## Part 2

### Teachers#show

Observe the first teacher:

    curl "${URL_BASE}/teachers/1"

Result:

>     {"data":{"id":"1",
>              "type":"teachers",
>              "attributes":{"name":"Edna Krabappel",
>                            "email":"edna_krabappel@example.org"}}}

### Teachers::TeachesStudents#index

Observe a list of students taught by _Edna Krabappel_:

    curl "${URL_BASE}/teachers/1/teaches_students"

Result: (suppressed in the middle for brevity):

>     {"data":[{"id":"33",
>               "type":"students",
>               "attributes":{"name":"Abe Braun",
>                             "email":"abe_braun@example.com"}},
>              {"id":"37",
>               "type":"students",
>               "attributes":{"name":"Amya Flatley",
>                             "email":"amya_flatley@example.org"}},
>              {"id":"36",
>               "type":"students",
>               "attributes":{"name":"Ana Metz",
>                             "email":"ana_metz@example.org"}},
>              …
>              {"id":"39",
>               "type":"students",
>               "attributes":{"name":"Xzavier Schmitt",
>                             "email":"xzavier_schmitt@example.net"}},
>              {"id":"38",
>               "type":"students",
>               "attributes":{"name":"Yasmine Wolff",
>                             "email":"yasmine_wolff@example.net"}}]}

### Teachers::ProgressOfStudents#index

Observe the progress of all the students taught by _Edna Krabappel_:

    curl "${URL_BASE}/teachers/1/progress_of_students"

Result: (suppressed in the middle for brevity):

>     {"data":[{"id":"33-461",
>               "type":"progress-of-students",
>               "relationships":{"student":{"data":{"id":"33",
>                                           "type":"students"}},
>                                "lesson-part":{"data":{"id":"461",
>                                                       "type":"lesson-parts"}}}},
>              {"id":"37-329",
>               "type":"progress-of-students",
>               "relationships":{"student":{"data":{"id":"37",
>                                                   "type":"students"}},
>                                "lesson-part":{"data":{"id":"329",
>                                               "type":"lesson-parts"}}}},
>              …
>              {"id":"38-552",
>               "type":"progress-of-students",
>               "relationships":{"student":{"data":{"id":"38",
>                                           "type":"students"}},
>                                "lesson-part":{"data":{"id":"552",
>                                                       "type":"lesson-parts"}}}}],
>      "included":[{"id":"33",
>                   "type":"students",
>                   "attributes":{"name":"Abe Braun",
>                                 "email":"abe_braun@example.com"}},
>                  {"id":"461",
>                   "type":"lesson-parts",
>                   "attributes":{"name":"2. Accipio commemoro bos ulciscor laudantium",
>                                 "ordinal":2},
>                   "relationships":{"lesson":{"data":{"id":"154",
>                                                      "type":"lessons"}}}},
>                  {"id":"154",
>                   "type":"lessons",
>                   "attributes":{"name":"54. Possimus copiose collum",
>                                 "ordinal":54}},
>                  {"id":"37",
>                   "type":"students",
>                   "attributes":{"name":"Amya Flatley",
>                                 "email":"amya_flatley@example.org"}},
>                  {"id":"329",
>                   "type":"lesson-parts",
>                   "attributes":{"name":"2. Nemo virtus termes delicate vilis",
>                                 "ordinal":2},
>                   "relationships":{"lesson":{"data":{"id":"110",
>                                                      "type":"lessons"}}}},
>                  {"id":"110",
>                   "type":"lessons",
>                   "attributes":{"name":"10. Admoveo sit coepi",
>                                 "ordinal":10}},
>                  …
>                  {"id":"38",
>                   "type":"students",
>                   "attributes":{"name":"Yasmine Wolff",
>                                 "email":"yasmine_wolff@example.net"}},
>
>                  {"id":"552",
>                   "type":"lesson-parts",
>                   "attributes":{"name":"3. Consuasor despirmatio depulso terebro demulceo",
>                                 "ordinal":3},
>                   "relationships":{"lesson":{"data":{"id":"184",
>                                                      "type":"lessons"}}}},
>                  {"id":"184",
>                   "type":"lessons",
>                   "attributes":{"name":"84. Timidus fuga varietas",
>                                 "ordinal":84}}]}

## Part 3

### Students::CompletedLessonParts#create

Attempt to have _Bart Simpson_ complete _2. Aequus taceo voluptatum celebrer surgo_ before completing the first
lesson part:

    curl \
      -H "Content-Type: application/vnd.api+json" \
      -H "Accept: application/vnd.api+json" \
      -w '\nstatus: %{http_code}\n' \
      -X POST \
      -d '{"data":{"type":"completions","attributes":{"lesson_part_id":1}}}' \
      "${URL_BASE}/students/2/completed_lesson_parts"

Response:

>     {"errors":[{"source":{"pointer":"/data/attributes/lesson-part"},
>                 "detail":"must have completed preceding lesson part"}]}
>      status: 422
