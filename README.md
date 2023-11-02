# README

My Rails API-only application is one that allows the user to sign up with a username and password, log in, access their snippets through providing a token, then log out when they feel like it.

Currently, my application allows for internal users to sign up with a POST request to /signup using the JSON format {user: {email, password, name}}. They can then do a POST request to /login with the JSON format {user:{email, password}} - if the email and password match the ones stored in the database after a user signs up, they are logged in and given a JWT. Then, they can do a GET or POST request to /snippets with the JWT they received in the header, which allows them to access their snippets. It does not work if a JWT is not provided. Finally, they can do a DELETE request to /logout with the JWT, after which it is revoked and the user is logged out.

I am currently trying to add support for Google users. The way I want this to work is as follows - login through a POST request to http://localhost:3000/auth/google_oauth2, where they are redirected to the google login page. They can then log in with their Google account after which they are redirected back and are given an OAuth 2.0 token, which is exchanged for a JWT. The internal database will generate a new user based on the email that has been provided, if the email doesn't already exist in the database. They should now be able to do a GET or POST request to /snippets with the JWT in the header in order to access their snippets. They can then do a DELETE request to /logout with the JWT which revokes the token and logs the user out. From now on, the Google user should also be able to login through /login, but they can also do it through Google if they so wish.

This README would normally document whatever steps are necessary to get the
application up and running.

Things you may want to cover:

- Ruby version

- System dependencies

- Configuration

- Database creation

- Database initialization

- How to run the test suite

- Services (job queues, cache servers, search engines, etc.)

- Deployment instructions

- ...
