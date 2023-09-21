# README

## About the Project

  Tea Subscription Service is a RESTful Rails API designed to facilitate tea subscriptions for customers. This API provides a simple and efficient way for customers to manage their tea subscriptions, including subscription creation, cancellation, and retrieval of subscription details. The API follows the principles of RESTful design and is organized to ensure clarity and ease of use.

### Core Features

 - Subscription Creation: Customers can subscribe to various tea packages using a straightforward endpoint.

 - Subscription Cancellation: Customers have the ability to cancel or activcate their tea subscriptions with ease.

 - Subscription Retrieval: The API offers an endpoint to retrieve all of a customer's subscriptions, including both active and canceled ones.

 - Subscription Deletion: Customers have the ability to delete their tea subscriptions.


## Technology Stack

 - [Ruby on Rails](https://www.ruby-lang.org/en/downloads/) version 3.1.1
 - Database: [PostgreSQL](https://www.moncefbelyamani.com/how-to-install-postgresql-on-a-mac-with-homebrew-and-lunchy/)
 - Testing: [Rspec](https://github.com/rspec/rspec-rails), [SimpleCov](https://github.com/simplecov-ruby/simplecov)
 - Documentation: [Postman](https://learning.postman.com/docs/developer/postman-api/intro-api/)
 - Noteworthy gems:
    - "active_model_serializers"
    - "factory_bot_rails"
    - "faker"
    - "shoulda-matchers"
    - "simplecov"

## Setup
 - Clone [Repo](https://github.com/jgthomas-12/tea_subscription)
 - Navigate to root directory and run `bundle install`
  #### Database
  - Default: PostgreSQL
    - Install postgres [here](https://www.moncefbelyamani.com/how-to-install-postgresql-on-a-mac-with-homebrew-and-lunchy/)

  - In the terminal please run:
    - `rails db:create`
    - `rails db:migrate`
    - `rails db:seed`
  #### Server
  - running `rails server` in the terminal will allow access of the API on the localhost


## Endpoints

### GET /api/v1/customers/:id/subscriptions
<details>
<summary>Response</summary>
Fetches a list of subscriptions for a specific customer.

Status: 200 OK

```json
{
    "data": [
        {
            "id": "1",
            "type": "subscriptions",
            "attributes": {
                "title": "S.E.S",
                "price": 74.35,
                "status": true,
                "frequency": "weekly"
            }
        },
        {
            "id": "5",
            "type": "subscriptions",
            "attributes": {
                "title": "Chakra",
                "price": 93.29,
                "status": false,
                "frequency": "monthly"
            }
        },
        {
            "id": "23",
            "type": "subscriptions",
            "attributes": {
                "title": "Eve",
                "price": 59.01,
                "status": true,
                "frequency": "monthly"
            }
        },
        {
            "id": "40",
            "type": "subscriptions",
            "attributes": {
                "title": "As One",
                "price": 48.41,
                "status": false,
                "frequency": "weekly"
            }
        },
        {
            "id": "41",
            "type": "subscriptions",
            "attributes": {
                "title": "g.o.d",
                "price": 45.98,
                "status": true,
                "frequency": "weekly"
            }
        }
    ]
}
```
</details>

### POST /api/v1/customers/:id/subscriptions

<details>
<summary>Response</summary>
Creates a new subscription for a specific customer.

Status: 201 Created

```json
{
    "title": "Super Sayan Bombambadier",
    "price": 60.66,
    "status": false,
    "frequency": "annually",
    "tea_id": 4
}
```
</details>

### PATCH /api/v1/customers/:id/subscriptions/:id

<details>
<summary>Response</summary>
Updates the status of a sustomer's subscription.

Status: 202 Accepted

cancel
```json
{
    "status": false
}
```

activate
```json
{
    "status": true
}
```
</details>

### DELETE /api/v1/customers/:id/subscriptions/:id

<details>
<summary>Response</summary>
Deletes a customer's subscription by id.

Status: 200 OK
</details>


## Testing

 - Run `bundle exec rspec` in your terminal.

### Project Guidelines
The development process adheres to best practices in software development, including Test-Driven Development (TDD), clear and organized code and comprehensive documentation. The project aims to balance functionality and simplicity, creating an easy-to-understand and efficient API for both frontend and backend developers.

Tea Subscription Service is designed to deliver practical and well-structured APIs that cater to the needs of both customers and developers.

### Timeframe
This project is designed to be completed in approximately 8 hours. Prioritization has been given to the development of essential MVP features to showcase the developer's capabilities effectively. Future enhancements can be considered based on project requirements.

## It's (not) a Schema!
#### NOTE: It's best if you read the above header in the voice of Detective John Kimble from the 1990 blockbuster Kindegarten Cop, played by world-renowned actor and politician Arnold Schwarzenegger

![schema](/images/schema.png)

```ruby
ActiveRecord::Schema[7.0].define(version: 2023_09_19_191532) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "customers", force: :cascade do |t|
    t.string "first_name"
    t.string "last_name"
    t.string "email"
    t.string "address"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "subscriptions", force: :cascade do |t|
    t.string "title"
    t.decimal "price"
    t.boolean "status"
    t.integer "frequency"
    t.bigint "customer_id", null: false
    t.bigint "tea_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["customer_id"], name: "index_subscriptions_on_customer_id"
    t.index ["tea_id"], name: "index_subscriptions_on_tea_id"
  end

  create_table "teas", force: :cascade do |t|
    t.string "title"
    t.text "description"
    t.integer "temperature"
    t.integer "brew_time"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "subscriptions", "customers"
  add_foreign_key "subscriptions", "teas"
end
```

## The develepah

- Jesse Thomas

[![Github](https://img.shields.io/badge/GitHub-100000?style=for-the-badge&logo=github&logoColor=white)](https://www.linkedin.com/in/jesse-g-thomas/)[![LinkedIn](https://img.shields.io/badge/LinkedIn-0077B5?style=for-the-badge&logo=linkedin&logoColor=white)](https://github.com/jgthomas-12)