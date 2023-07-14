# README

This app lets organizers set up in person and virtual events and "invite" their users to them. They can also set their events to "private" so that only the people they specifically invite can RSVP to them. Organizers can create an event, with or without attendees, and can update that event as needed. Attendees can RSVP to the event and update their name in our system. Organizers can also update their name in our account.

## Routes Available
This section will detail all of the actions available to users, as well as the params and URL structure for each of those actions.
### Events
#### Index (GET /events)
This route returns all public events in our database, paginated. 
Example response body: 
```
  [
    {
        "id": 8,
        "description": "Another event created through API!",
        "end_time": "2023-07-16 21:32:18 UTC",
        "event_type": "in_person",
        "private": false,
        "start_time": "2023-07-15 21:32:18 UTC",
        "title": "The BEST event ever",
        "location": "Nobu Malibu"
    },
    {
    ...
  ]
```

#### Show (GET /events/:id)
This route returns one event with it's organizer's data, as well as the list of invited attendees and their invitation status. 
Example response body:
```
{
    "id": 8,
    "description": "Another event created through API!",
    "end_time": "2023-07-16 21:32:18 UTC",
    "event_type": "in_person",
    "private": false,
    "start_time": "2023-07-15 21:32:18 UTC",
    "title": "The BEST event ever",
    "location": "Nobu Malibu"
    "invitations": [
      {
        "id": 1,
        "attendee": {
          "id": 1,
          "email_address": "jacob@happied.co",
          "first_name": null,
          "last_name": null
        },
        "invitation_status": "accepted"
      },
      ...
    ],
    "organizer": {
      "id": 1,
      "email_address": "jacob@secrenodes.co",
      "first_name": "Jacob",
      "last_name": "Jackson"
    },
},
```

#### Create (POST /events)
This route allows an organizer to create a new event. The endpoint will look for an organizer in our database and create one if it doesn't find a matching record. It also allows the organizer to pass in a list of potential attendees at the same time and create invitations for those attendees. Any attendees with invalid email addresses are filtered out and the organizer is notified that their invitation didn't get created.
Example Request Body:
```
{
    "start_time": "2023-07-15 21:32:18.698972000 +0000",
    "end_time": "2023-07-16 21:32:18.699597000 +0000",
    "title": "Birthday Party",
    "description": "Come celebrate my birthday in style!",
    "event_type": "in_person",
    "private": false,
    "organizer_email": "jacob@secretnodes.org",
    "attendees": ["jacob@happied.co", "jacob@secretnodes.org", "jacob@am"]
}
```
Example Response Body:
```
{
    "event": {
        "id": 8,
        "description": "Come celebrate my birthday in style!",
        "end_time": "2023-07-16 21:32:18 UTC",
        "event_type": "in_person",
        "invitations": [
            {
                "id": 19,
                "attendee": {
                    "id": 1,
                    "email_address": "jacob@happied.co",
                    "first_name": null,
                    "last_name": null
                },
                "invitation_status": "no_response"
            },
            {
                "id": 20,
                "attendee": {
                    "id": 2,
                    "email_address": "jacob@secretnodes.org",
                    "first_name": null,
                    "last_name": null
                },
                "invitation_status": "no_response"
            }
        ],
        "organizer": {
            "id": 3,
            "email_address": "jacob@secretnodes.org",
            "first_name": null,
            "last_name": null
        },
        "private": false,
        "start_time": "2023-07-15 21:32:18 UTC",
        "title": "Birthday Party",
    },
    "meta": {
        "invalid_invitations": [
            "jacob@am"
        ]
    }
}
```

#### Update (PUT /update/:id)
This route allows the organizer to update their event details, including start and end time, title, description, and whether or not the event is private. It returns a success message if successful. Fields can be omitted as necessary. 
Example Request Body:
```
{
    "start_time": "2023-07-14 21:32:18.698972000 +0000",
    "event_type": "in_person"
}
```
Success Message: 
`{ message: 'You successfully updated your event!' }`

#### Destroy (DELETE /events/:id)
This endpoint destroys an event and its associated invitations. The associated organizer and attendee records are unaffected by this action. It returns a `:no_content` status when successful. 

#### Update Invitations (PUT /events/:id/update_invitations)
This endpoint allows the organizer to invite additional attendees after it has been created. I considered adding this logic to the Update endpoint but thought it would be a good idea to break it out into it's own endpoint since it's technically not updating anything about the event itself. 
Example Request Body:
```
{
  "attendees": ["jacob@happied.co", "jacob@secretnodes.org", "jacob@am"]
}
```
Example Response Body:
```
{
    "event": {
        "id": 8,
        "description": "Come celebrate my birthday in style!",
        "end_time": "2023-07-16 21:32:18 UTC",
        "event_type": "in_person",
        "invitations": [
            {
                "id": 19,
                "attendee": {
                    "id": 1,
                    "email_address": "jacob@happied.co",
                    "first_name": null,
                    "last_name": null
                },
                "invitation_status": "no_response"
            },
            {
                "id": 20,
                "attendee": {
                    "id": 2,
                    "email_address": "jacob@secretnodes.org",
                    "first_name": null,
                    "last_name": null
                },
                "invitation_status": "no_response"
            }
        ],
        "organizer": {
            "id": 3,
            "email_address": "jacob@secretnodes.org",
            "first_name": null,
            "last_name": null
        },
        "private": false,
        "start_time": "2023-07-15 21:32:18 UTC",
        "title": "Birthday Party",
    },
    "meta": {
        "invalid_invitations": [
            "jacob@am"
        ]
    }
}
```
### Invitations
I omitted the index route for invitations because I didn't see a use case for showing all invitations, regardless of which event they belong to.
#### Show (GET /invitations/:id)
This route returns an individual invitation record.
Example Response Body:
```
{
    "id": 1,
    "attendee": {
        "id": 1,
        "email_address": "jacob@secretnodes.org",
        "first_name": null,
        "last_name": null
    },
    "event": {
        "id": 1,
        "description": "First event created through API!",
        "end_time": "2023-07-16 21:32:18 UTC",
        "event_type": "in_person",
        "private": false,
        "start_time": "2023-07-14 21:32:18 UTC",
        "title": "The FIRST event"
    },
    "invitation_status": "accepted"
}
```

 #### Create (POST /invitations)
 This route creates a new invitation for an event. It allows users to RSVP to public events that they haven't already been invited to and prevents them from RSVPing to private events they haven't been invited to. It returns a success message when no errors are detected.
 Example Request Body:
 ```
{
    "event_id": 1,
    "attendee_email": "jacob@snodes.org",
    "invitation_status": "declined"
}
```
Example Response Body:
```
{ message: "You have successfully RSVP'd to this event." }
```

#### Update (PUT /invitations/:id)
This route updates an existing invitation's status. It will be used to allow attendees to update their response to the invitation and returns a success message when no errors are detected.
Example Request Body:
```
{ "invitation_status": "declined" }
```
Example Response Body:
```
{ message: "You have successfully RSVP'd to this event." }
```

#### Destroy (DELETE /invitations/:id)
This route destroys an invitation. It does not affect the event or attendee records and returns a `:no_content` status code when successful.

### Attendees
I ommitted the index and create routes from this collection. I didn't see a use case for showing all attendees, and attendees are automatically created when a user RSVPs to an event or when an organizer sends out an invitation to them. These routes look up the attendee by email as opposed to ID, since most attendees won't remember their ID but will almost definitely remember their email. 
#### Show (GET /attendees/:email_address)
This route returns a single attendee record. 
Example Response Body:
```
{
    "id": 3,
    "email_address": "jacob@snodes.org",
    "events": [
            {
                "id": 1,
                "description": "First event created through API!",
                "end_time": "2023-07-16 21:32:18 UTC",
                "event_type": "in_person",
                "private": false,
                "start_time": "2023-07-14 21:32:18 UTC",
                "title": "The FIRST event"
            }
    ],
    "first_name": "Jacob",
    "last_name": "Jackson"
}
```
#### Update (PUT /attendees/:email_address)
This route updates an attendee's first and last name. More info can easily be added later as we need it. It returns a success message when no errors are encountered.
Example Request Body: 
```
{
    "first_name": "Nunya",
    "last_name": "Biznez"
}
```
Example Response Body:
```
{ "message": "You successfully updated your account!" }
```

#### Destroy (DELETE /attendees/:email_address)
This route deletes the attendee record from our database, as well as any invitations associated with that attendee. It returns a `:no_content` status code when successful.

### Organizers
Similar to attendees, I ommitted the index and create routes from this collection. I didn't see a use case for showing all organizers, and the organizer record is automatically created (or looked up) when the organizer creates a new event. These routes look up the organizer by email as opposed to ID, since most organizers won't remember their ID but will almost definitely remember their email. 
#### Show (GET /organizers/:email_address)
This route returns a single organizer record and it's associated events.
Example Response Body:
```
{
    "id": 3,
    "email_address": "jacob@secretnodes.org",
    "events": [
        {
            "id": 5,
            "description": "Another (stupid) event created through API!",
            "end_time": "2023-07-16 21:32:18 UTC",
            "event_type": "in_person",
            "private": false,
            "start_time": "2023-07-15 21:32:18 UTC",
            "title": "The WORST event"
        },
        ...
    ],
    "first_name": null,
    "last_name": null
}
```
#### Update (PUT /organizers/:email_address)
This route updates an organizer's first and last name. More info can easily be added later as we need it. It returns a success message when no errors are encountered.
Example Request Body: 
```
{
    "first_name": "Nunya",
    "last_name": "Biznez"
}
```
Example Response Body:
```
{ "message": "You successfully updated your account!" }
```

#### Destroy (DELETE /organizers/:email_address)
This route deletes the organizer's record from our database, as well as any events associated with the organizer and all of those events' invitations. It returns a `:no_content` status code when successful.

## Retrospective
This was a fun little project. Leaving out the authentication portion of the app made me think more about how users would access and update their information and was a little challenging to code around at first, since most of the apps I've worked on have involved auth in some way. There were a couple of ideas I had to add to this that I eventually decided were out of scope for the project. The one that immediately stood out to me is giving organizers the ability to send out invitations through email, text, etc. Most of the time, when you create an event, in my experience, you have a pretty good idea of who you want to invite. However, adding a mailer seemed to be a little overkill for what was asked of me. I also considered adding a many-to-many relationship between events and organizers, so that multiple people could act as admins for an event. Then it struck me that without authentication, it's already possible for multiple people to admin an event.

Although the instructions stated that I only need to add events and attendees, I decided it would be better to add an "invitations" table so that we can reuse the attendee records for multiple events if they're going to them. I also broke out the organizer email field into an organizer table so that we can collect info about the organizer and potentially use it as an auth table in the future. I also thought it would be logical to give organizers the ability to set their events as private if they so desire. I also added a "location" field to the events table to let organizers specify where an event would be. I would normally break out the location for physical events into multiple fields (location_name, address line 1, line 2, city, state, etc) and have a separate location field for virtual events, but I thought a text field would be sufficient for now. I also went back and forth on how to batch create event invitations to send out, and decided that validating them and then doing it within a single database transaction seemed like the best way to go about it. Without validation, most bulk insert methods will fail in Rails if even one record is invalid, and creating all of the records in one transaction saves us a little bit of overhead in the database.

Overall, I'm pretty happy with where the app is at this point but I'm always open to feedback. 
