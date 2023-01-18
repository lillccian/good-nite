# Todo

==========================================

We would like you to implement a "good night" application to let users track when do they go to bed and when do they wake up.

We require some restful APIS to achieve the following:

1. Clock In operation, and return all clocked-in times, ordered by created time.
2. Users can follow and unfollow other users.
3. See the sleep records over the past week for their friends, ordered by the length of their sleep.

Please implement the model, db migrations, and JSON API.
You can assume that there are only two fields on the users "id" and "name".

You do not need to implement any user registration API.

You can use any gems you like.

==========================================

## Model

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
```
    GET  |  /:version/ping(.json)                      |  v1  |
    GET  |  /:version/sleep_records/ping(.json)        |  v1  |
   POST  |  /:version/sleep_records(.json)             |  v1  |  create sleep record
    GET  |  /:version/sleep_records(.json)             |  v1  |  get sleep records
    GET  |  /:version/sleep_records/:id(.json)         |  v1  |  get sleep record
    PUT  |  /:version/sleep_records/:id(.json)         |  v1  |  update sleep record
 DELETE  |  /:version/sleep_records/:id(.json)         |  v1  |  delete sleep record
   POST  |  /:version/users/:id/follow(.json)          |  v1  |  follow user
   POST  |  /:version/users/:id/unfollow(.json)        |  v1  |  unfollow user
    GET  |  /:version/followings/sleeping_time(.json)  |  v1  |  get followings sleep time
```