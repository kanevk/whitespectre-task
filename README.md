# README

A task for Whitespectre


## Description
A group event will be created by an user. The group event should run for a whole number of days e.g.. 30 or 60.
There should be attributes to set and update the start, end and duration of the event and calculate the
missing value if 2 are given. The event also has a name, description (which supports formatting) and location.
The event should be draft or published. To publish all of the fields are required, it can be saved with only a
subset of fields before it’s published. When the event is deleted/remove it should be kept in the database and marked as such.

Write an AR model, spec and migration for a GroupEvent that would meet the needs of the description above.
Then write the api controller and spec to support JSON request/responses to manage these GroupEvents.
For the purposes of this exercise, ignore auth.


Please provide your solution as a rails app called exercise_YYMMDD_yourname, sent as a zip file.

## Assumptions

 - group event has:
   - user_id
   - name
   - description
   - description_type
   - location
   - start
   - end
   - duration
   - status

 - For group event for any given 2 from the fields (start, end, and duration) we need to calculate the third field
 - The API have to support the following:
   - creating an event(assuming it will be always draft)
   - fetching singe event
   - event update(cannot change publish status)
   - pubishing an event + validations
   - delete event

- The API has the following endpoints:
   - [X] GET /events
   - [X] POST /events
   - [ ] GET /events/:id
   - [X] PUT/PATCH /events/:id
   - [ ] DELETE /events/:id


