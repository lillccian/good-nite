# Todo

---

We would like you to implement a "good night" application to let users track when do they go to bed and when do they wake up.

We require some restful APIS to achieve the following:

1. Clock In operation, and return all clocked-in times, ordered by created time.
2. Users can follow and unfollow other users.
3. See the sleep records over the past week for their friends, ordered by the length of their sleep.

Please implement the model, db migrations, and JSON API.
You can assume that there are only two fields on the users "id" and "name".

You do not need to implement any user registration API.

You can use any gems you like.

---

## Model
---
#### User
```

# Table name: users
#
#  id         :integer          not null, primary key
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null

```

#### AccessToken
```

# Table name: access_tokens
#
#  id         :integer          not null, primary key
#  token      :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  user_id    :bigint

```

#### SleepRecord
```

# Table name: sleep_records
#
#  id            :integer          not null, primary key
#  end_at        :datetime         not null
#  sleeping_time :integer          default(0), not null
#  start_at      :datetime         not null
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  user_id       :bigint

```

#### Follow
```

# Table name: follows
#
#  id           :integer          not null, primary key
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  follower_id  :bigint           not null
#  following_id :bigint           not null
#
# Indexes
#
#  index_follows_on_follower_id_and_following_id  (follower_id,following_id) UNIQUE

```

## Api Endpoint

|method|path|desc|
|---|---|---|
|    GET  |  /api/v1/ping                      |  test server health  |
|    GET  |  /api/v1/sleep_records/ping        |  test server health  |
|   POST  |  /api/v1/sleep_records             |  create sleep record  |
|    GET  |  /api/v1/sleep_records             |  get sleep records  |
|    GET  |  /api/v1/sleep_records/:id         |  get sleep record  |
|    PUT  |  /api/v1/sleep_records/:id         |  update sleep record  |
| DELETE  |  /api/v1/sleep_records/:id         |  delete sleep record  |
|   POST  |  /api/v1/users/:id/follow          |  follow user  |
|   POST  |  /api/v1/users/:id/unfollow        |  unfollow user  |
|    GET  |  /api/v1/followings/sleeping_time  |  get followings sleep time  |


