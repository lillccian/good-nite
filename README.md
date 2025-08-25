We want to know how do you structure the code and design the API
Please use Rails for this project
==========================================

We would like you to implement a "good night" application to let users track when do they go to bed and when do they wake up.

We require some restful APIS to achieve the following:

1. Clock In operation, and return all clocked-in times, ordered by created time.
2. Users can follow and unfollow other users.
3. See the sleep records of a user's All following users' sleep records. from the previous week, which are sorted based on the duration of All friends sleep length.
This is 3rd requiremnet response example
{
  record 1 from user A,
  record 2 from user B,
  record 3 from user A,
  ...
}

Please implement the model, db migrations, and JSON API.
Consider that the system will need to handle a high volume of data and concurrent requests as the user base grows.
You can assume that there are only two fields on the users "id" and "name".

You do not need to implement any user registration API.

You can use any gems you like.
============================

After you finish the project, please send me your GitHub project link.

We want to see all of your development commits.
- It is important to have separate commits with clear descriptions for each change.
- In Tripla, it is not a good practice to have one commit with a lot of changes.

Please ensure that you have granted permission for Google Meet to share your screen, as we may need you to do so during the meeting

## Api Endpoint

|method|path|desc|
|---|---|---|
|    GET  |  /api/v1/ping                      |  test server health  |
|   POST  |  /api/v1/sleep_records             |  create sleep record, return all sleep records  |
|    GET  |  /api/v1/sleep_records             |  get sleep records  |
|    GET  |  /api/v1/sleep_records/:id         |  get sleep record  |
|    PUT  |  /api/v1/sleep_records/:id         |  update sleep record  |
| DELETE  |  /api/v1/sleep_records/:id         |  delete sleep record  |
|   POST  |  /api/v1/users/:id/follow          |  follow user  |
|   POST  |  /api/v1/users/:id/unfollow        |  unfollow user  |
|    GET  |  /api/v1/followings/sleeping_time  |  get followings sleep time  |