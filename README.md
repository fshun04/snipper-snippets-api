# README

To simulate the flow of this app in Postman, you must:

1. Start the Rails server with `rails server`

2. In Postman, set up a POST request to `http://localhost:3000/signup` and set a JSON body with the following structure:

{
    "user": {
        "email": "(the email that you want to sign up with)",
        "password": "(the password that you want to link with your account)",
        "name": "(your name)"
    }
}

If done correctly, you should be sent a JSON response that follows the JSON API standard. It should include the user, its links and its relationships (snippets).

3. In Postman, set up a POST request to `http://localhost:3000/login`, and set the body of the request to a JSON with the following structure:

{
    "user": {
        "email": "(the email that you signed up with)",
        "password": "(the password that you linked to your account)"
    }
}

If done correctly, you should be sent a JSON response that follows the JSON API standard. It should include the user, its links and its relationships (associated snippets).

You should also receive a JSON Web Token in the response's Headers > Authorization. It should have the prefix `Bearer` alongside a string of characters. Make sure to copy this entire value. Do bear in mind that the token will expire after 30 minutes, so if this happens you will have to log in again.

4. In Postman, set up a POST request to `http://localhost:3000/snippets`, create a new header `Authorization` with the JWT that you copied earlier as its value, and set the body of the request to a JSON with the following structure:

{
    "snippet": {
        "content": "(the snippet that you want to create)"
    }
}

Feel free to create as many snippets as you want.

4. In Postman, set up a GET request to `http://localhost:3000/snippets`, create a new header `Authorization` with the JWT that you copied earlier as its value, and set the body of the request to none.

If done correctly, you should be sent a JSON response that follows the JSON API standard. It should include your snippets, their links and their relationships (associated user).

DEBUGGING:

Go to the index action of the Snippets controller

Currently, I am having two issues - one where it states that SnippetResource has the wrong number of arguments, and (if this doesn't occur), I get one where it says that it cannot display the decoded snippets in JSON API format due to invalid UTF-8 encoding. Interestingly, when I don't use the SnippetResource to render this response (i.e. render json: snippets), things seem to work just fine.