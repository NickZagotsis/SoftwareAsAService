# README

## Authors

---

- [Nick Zagotsis (p21032)](https://github.com/NickZagotsis)
- [Konstantinos Georgopoulos (p21017)](https://github.com/Gusssskiller)

## Versions used

---

- Ruby -> 3.4.1 (2024-12-25 revision 48d4efcb85) +PRISM [arm64-darwin24]
- Rails -> 8.0.1
- Gem -> 3.6.2
- Bundler -> version 2.6.2

## Table of contents

- [Application documentation](#application-documentation)
  - [Login page](#login-page)
  - [Sign-Up page](#sign-up-page)
  - [Main page](#the-main-page)
  - [Posts overview](#posts-overview)
  - [Friends functionality](#friends-functionality)
  - [Group chat functionality](#group-chats)
  - [Personal messaging & profiles](#personal-messaging-and-profiles)
- [Api documentation](#api-documentation)
  - [Getting started](#getting-started)
    - [Todo controller](#todo_controller)
    - [Todo item controller](#todo_item_controller)
    - [Sessions controller](#sessions_controller)
    - [Registrations controller](#registrations_controller)
    - [Final steps](#final-steps)
  - [Testing the APIs](#testing-the-apis)
    - [Custom made python script](#custom-python-script)
  - [How the API works](#how-the-api-works)
    - [Login](#login)
    - [Sign-Up](#sign-up)
    - [Logout](#logout)
    - [List all todos](#listing-all-todos)
    - [Create a new todo](#create-a-new-todo)
    - [Get a specific todo](#get-a-specific-todo-list-with-its-todo-items)
    - [Update a specific todo](#update-a-todo)
    - [Delete a specific todo](#deleting-a-todo-and-its-items)
    - [Create a new todo item](#creating-a-new-todo-item)
    - [Get a specific todo item](#get-a-specific-todo-item)
    - [Update a specific todo item](#updating-a-todo-item)
    - [Delete a specific todo item](#deleting-a-todo-item)
- [Technologies used](#technologies-used)

---

## Application documentation

---

### Login page

---

As seen in the screenshot bellow, the login page allows the user to connect to our application. Each user can either create a new account - by clicking the sign-up button, or reset his/her password. The password reset is not implemented because we chose that to implement a mailer with an actual mail is out of scope.

![Login page](/images/login.png)
*Login page*

### Sign-up page

---

To create a new user in the sign-up page, you must provide your email and password. Optionally, you can provide a short description to let others know what you are up to, but you can leave the field empty if you don't want to!

![Sign-up page](/images/sign_up.png)
*Sign-up page*

### The main page

---

When you login to our application, you first meet the main page - aka the INDEX page. The index page has a short overview of the functions our application offers. These include

- Posting
- Friends system
- Contacts
- Notifications
- Profiles
- Public or private rooms
  - Public rooms are available for everyone to join and can be created by anyone
  - Private rooms are available only to those who are participants, aka private messages

When it comes to catching up, the login page is a great place! You can access every single function immediately!

- You can access your private chats, group chats and even add a friend!
- You can search for a post or catch up with the latest 3!
- You can see your three (3) latest private chats

And more!

![Index page](/images/index1.png)
*Main page*

![Index page2](/images/index2.png)
*Main page*

### Posts overview

---

With the posts function, anyone can easily create, modify and delete their posts. To see all the posts available right now, you simply need to click the `posts` link in your hotbar or access them via the index page using the `view all posts` button.
Please note that you can only modify a post or even delete it *ONLY* if you are the owner of that post. The rest of the users, as seen in the images below, have no rights to modify or delete the posts made by another user as they can only view them.
You can also easily create a post if you want to by clicking on the `New posts` button.

![Image posts 1](/images/posts.png)
*Viewing all the posts*

![Image posts_2](/images/posts2.png)
*Viewing a specific post*

![Image posts_3](/images/posts3.png)
*Creating a new post*

### Friends functionality

---

As we mentioned above, the app offers a cool friend functionality! As seen in the images below, anyone can search for a friend - by looking up their email, or check their contacts and see any updates on their friend requests!
You can find friends by clicking the `add a friend` link in the hotbar or click the `add a friend` button in the main page.
Either way, you are redirected to the search a friend page, where you can easily type anything and relevant users will be loaded, thus giving you the option to spectate their profile - by clicking on their email - or to add them as a friend!

![Contacts image](/images/contacts.png)
*Contacts page*

![Friend search image](/images/search_friend.png)
*Search a friend page*

![send friend request image](/images/sent_friend_request.png)
*Friend request sent!*

![receive friend request image](/images/receive_friend_request.png)
*Receiving a friend request as another user!*

![notifications image](/images/notifications.png)
*Receiving a friend request notification!*

### Group chats

---

To access the currently available and open group chats, you can click on the `Rooms` button in your hotbar. Doing so, will redirect you to the group chats page. Here, anyone can join the available group chats or even create a new one!
Please note that the group chats support real time messaging - using action cable! Cool right? 😁
The messages that are sent by you will appear on the right side of the chat, whereas the messages that are sent by other users will appear on the left!

![Group chat 1](/images/public_room1.png)
*Empty group chat page*

![Group chat 2](/images/public_room2.png)
*Group chat page showing the available rooms!*

![Group chat 3](/images/public_room3.png)
*A random group chat*

### Personal messaging and profiles

---

The implementation of personal messaging is an extent of the public rooms feature. Personal chats are essentially public rooms that have a parameter `Private: True`. This enables the application to distinguish between these two and give access only to the required parties. For example, if you try to chat with a user for the first time, we create a new private chat - based on the aforementioned logic - and only you and the other user can join the chat.
To chat with someone you need to simply click on their email - wherever it appears, all messages all clickable - and you will be presented with their profile. Their profile contains information about them - their description and their friends - while also providing a `chat` button.
Clicking this creates the room - if not already created by the other user or in the past - and you are free to chat with the other user!

![Private chat 1](/images/private_chat.png)
*Freshly created private chat*

![Private chat 2](/images/private_chat2.png)
*Privately chatting with a friend*

![Profile](/images/profile.png)
*A user's profile*

## API documentation

### Getting started

---

1. We need to create the Todo & Todo_item models. Run this in your terminal

    ``` ruby
    rails g model Todos title:string description:text
    rails g model TodoItem todo:references content:text completed:boolean
    rails db:migrate
    ```

2. We also need to make a migration to add a user reference in TODO model

    ```ruby
    rails generate migration AddUserIdToTodo user:references
    rails db:migrate
    ```

3. Expose the necessary endpoints in config/routes.rb.

    ``` ruby
    Rails.application.routes.draw do
        post "/signup", to: "registrations#create"
        post "/auth.login", to: "sessions#create"
        get "/auth.logout", to: "sessions#destroy"

    resources :todo do
      resources :todo_item, only: [ :show, :create, :update, :destroy ]
        end
    end
    ```

    This will expose the endpoints as follows:

    - [x]  POST /signup -> Signup
    - [x]  POST /auth.login -> Login
    - [x]  GET /auth/logout -> Logout
    - [x]  GET /todos -> List all todos and todo items
    - [x]  POST /todos -> Create a new todo
    - [x]  GET /todos/:id -> Get a todo
    - [x]  PUT /todos/:id -> Update a todo
    - [x]  DELETE /todos/:id -> Delete a todo and its items
    - [x]  GET /todos/:id/items/:iid -> Get a todo item
    - [x]  POST /todos/:id/items -> Create a new todo item
    - [x]  PUT /todos/:id/items/:iid -> Update a todo item
    - [x]  Delete /todos/:id/items/:iid -> Delete a todo item

4. To handle the api requests we need to setup the necessary controllers for each action. Lets create them now 😁

    ``` ruby
        rails g controller Todos
        rails g controller TodoItem
        rails g controller Sessions
        rails g controller Registrations
    ```

    This will create 4 new controllers that will let us implement our nice functions.
5. Setting up the required functions for each controller

    Each of the following controllers may have the following functions that are associated with different HTTP requests.
    1. `index` function is the GET request
    2. `create` function is the post request
    3. `show` function is the GET request with a specific ID
    4. `update` function is the PUT request
    5. `destroy` function is the DELETE request.

#### todo_controller

---

This controller will provide functionality for everything that involves the creation, presentation, update and deletions of the todo lists.

```ruby
class TodoController < ApplicationController
    before_action :authenticate_user!
    def index
        @todo = current_user.todos
        render json: @todo
    end
    def create
        @todo = current_user.todos.create(todo_params)
        if @todo.save
        render json: @todo, status: :created
        else
        render json: @todo.errors, status: :unprocessable_entity
        end
    end

    def show
        @todo = current_user.todos.find(params[:id])
        render json: @todo.as_json(include: :todo_items)
    end

    def update
        @todo = current_user.todos.find(params[:id])
        if @todo.update(todo_params)
        render json: @todo
        else
        render json: @todo.errors, status: :unprocessable_entity
        end
    end

    def destroy
        @todo = current_user.todos.find(params[:id])
        @todo.destroy
        head :no_content
    end

    private

    def todo_params
        params.require(:todo).permit(:title, :description)
    end
end
```

#### todo_item_controller

---

This controller will provide functionality for everything that involves the creation, presentation, update and deletions of the TODO items that are present in each TODO list.

```ruby
class TodoItemController < ApplicationController
    before_action :authenticate_user!

    def show
        @todo_item = current_user.todos.find(params[:todo_id]).todo_items.find(params[:id])
        render json: @todo_item
    end

    def create
        @todo = current_user.todos.find(params[:todo_id])
        @todo_item = @todo.todo_items.create(todo_item_params)
        if @todo_item.save
        render json: @todo_item, status: :created
        else
        render json: @todo_item.errors, status: :unprocessable_entity
        end
    end

    def update
        @todo_item = current_user.todos.find(params[:todo_id]).todo_items.find(params[:id])
        if @todo_item.update(todo_item_params)
        render json: @todo_item
        else
        render json: @todo_item.errors, status: :unprocessable_entity
        end
    end

    def destroy
        @todo_item = current_user.todos.find(params[:todo_id]).todo_items.find(params[:id])
        @todo_item.destroy
        head :no_content
    end

    private

    def todo_item_params
        params.require(:todo_item).permit(:content, :completed)
    end
end

```

#### sessions_controller

---

This controller is responsible for handling the sessions of each user. This means that it is responsible for the creation and deletion of each session. It does so by utilizing the `devise's` User table and functions.

```ruby
class SessionsController < ApplicationController
    def create
        user = User.find_for_database_authentication(email: params[:email])
        if user&.valid_password?(params[:password])
        sign_in user
        render json: { message: "Logged in successfully" }
        else
        render json: { error: "Invalid email or password" }, status: :unauthorized
        end
    end

    def destroy
        sign_out current_user
        render json: { message: "Logged out successfully" }
    end
end
```

#### registrations_controller

This controller is responsible for the sign-ups of each user. This controller also utilizes `devise's` User table and functions.

``` ruby
    class RegistrationsController < ApplicationController
        def create
            user = User.new(user_params)
            if user.save
            render json: { message: "User created successfully" }, status: :created
            else
            render json: { error: "Error creating user" }, status: :unprocessable_entity
            end
        end

        private

        def user_params
            params.require(:user).permit(:email, :password, :password_confirmation)
        end
    end

```

#### Final steps

---

The final step before we are ready is to make sure our models are ok. Make sure that your models look like this.

1. User model

    ```ruby
        class User < ApplicationRecord
            has_many :todos
            #Other stuff ...
        end

    ```

2. Todo model

    ```ruby
        class Todo < ApplicationRecord
            has_many :todo_items
            belongs_to :user
        end
    ```

3. Todo item model

    ```ruby
    class TodoItem < ApplicationRecord
        belongs_to :todo
    end
    ```

### Testing the APIs

---

#### Custom python script

---

To test the `api` functions we used a script that we made that is named `api_script.py`

```python
import requests
from time import sleep
session_key = None

def create_todo():
    if session_key:
        title = input('Title:')
        Description = input('Description:')
        response = requests.post('http://localhost:3000/todo',cookies={'_app_session':session_key},data={
          "todo[title]":title,
          "todo[description]":Description
        })
        print(response.text)
    else:
        print("No session key found, please login first")

def show_todo_id():#this also gets todo_items
    if session_key:
        id = input('ID of the todo:')
        response = requests.get(f'http://localhost:3000/todo/{id}',cookies={'_app_session':session_key})
        print(response.text)
    else:
        print("No session key found, please login first")

def update_todo():
    if session_key:
        id = input("ID:")
        title = input('Title (blank for no change):')
        Description = input('Description (blank for no change):')
        data = {}
        if title:
            data["todo[title]"] = title
        if Description:
            data["todo[description]"] = Description
        response = requests.put(f'http://localhost:3000/todo/{id}',cookies={'_app_session':session_key},data=data)
        print(response.text)
    else:
        print("No session key found, please login first")

def delete_todo():
    if session_key:
        id = input('ID:')
        response = requests.delete(f'http://localhost:3000/todo/{id}',cookies={'_app_session':session_key})
        if response.status_code == 204:
            print('Deleted!')
        else:
            print(response.text)
    else:
        print("No session key found, please login first")


def get_todo_item():
    if session_key:
        id = input('ID of the todo:')
        id2 = input('ID of the todo_item:')
        response = requests.get(f'http://localhost:3000/todo/{id}/todo_item/{id2}',cookies={'_app_session':session_key})
        print(response.text)
    else:
        print("No session key found, please login first")

def create_todo_item():
    if session_key:
        id = input('TODO ID:')
        while True:
            content = input('Content:')
            completed = input('Completed? (y/n)')
            if completed == 'y' or completed == 'n':
                break
            else:
                print('completed must be y or n')
        if completed == 'y':
            completed = True
        else:
            completed = False
            
        data = { "todo_item[content]":content, "todo_item[completed]":completed }
        response = requests.post(f'http://localhost:3000/todo/{id}/todo_item',cookies={'_app_session':session_key},data=data)
        print(response.text)
    else:
        print("No session key found, please login first")

def update_todo_item():
    if session_key:
        data = {}
        id = input('TODO ID:')
        id2 = input('TODO_ITEM ID:')
        while True:
            content = input('Content: (blank to skip)')
            completed = input('Completed? (y/n) (blank to skip)')
            if completed == 'y' or completed == 'n' or completed == '':
                break
            else:
                print('completed must be y or n or blank')
        if completed == 'y':
            data['todo_item[completed]'] = True
        if completed == 'n':
            data['todo_item[completed]'] = False
        if content:
            data['todo_item[content]'] = content
        if data:
            response = requests.put(f'http://localhost:3000/todo/{id}/todo_item/{id2}',cookies={'_app_session':session_key},data=data)
            print(response.text)
        else:
            print('no change provided')
    else:
        print("No session key found, please login first")

def delete_todo_item():
    if session_key:
        id = input('TODO ID:')
        id2 = input('TODO_ITEM ID:')
        response = requests.delete(f'http://localhost:3000/todo/{id}/todo_item/{id2}',cookies={'_app_session':session_key})
        if response.status_code == 204:
            print('Deleted!')
        else:
            print(response.text)
    else:
        print("No session key found, please login first")

def signup():
    #http POST http://localhost:3000/signup 'user[email]=l@l.gr' 'user[password]=123456' 'user[password_confirmation]=123456'
    email = input('Email:')
    password = input('Password:')
    password_eval = input('Password confirmation:')
    response = requests.post("http://localhost:3000/signup",data = {
    "user[email]": email,
    "user[password]": password,
    "user[password_confirmation]": password_eval
})
    print(response.text)
    

def login():
    #http POST http://localhost:3000/auth.login email="n@n.gr" password="123456"
    global session_key
    email = input('Email:')
    password = input('Password:')
    response = requests.post("http://localhost:3000/auth.login",json={"email":email, "password":password})
    print(response.text)
    session_key = response.cookies.get_dict()['_app_session']

def logout():
    print(requests.get('http://localhost:3000/auth.logout').json())

def get_all_todo():
    #http get http://localhost:3000/todo Cookie=' _app_session=bYNcJ58EJWUHQY%2BftD9pPyP7mvrjB0OTmLbVYnE3dhq3Ln2fuR%2BPpYW26HZ3yEEfVg2FlwIhSprCPflGhFMyOAY5HVN33E4HdZ4wO1biRnuxqk6DOflCkN7Ppm5b41ZUW%2B%2B2F5IxFeMB%2FGqGparkQ6O94S1O9PGQ0yxozZGqwUjiPLaslUwoFkXRl6V%2BYKlSb8%2FR%2Bkj02eUOEbjswPKEHx0bzAnNmtSDL3cv8ATzwu5OfH%2BPLwXHrNQr%2FTsXcvo00vj3i8200mgyhfvyAX06MYgXJ8U%3D--RQ7qYoz7TPDJGUxn--jPqv3c1jLiSYgsS0NXK3nQ%3D%3D'
    if session_key:
        response = requests.get('http://localhost:3000/todo',cookies={'_app_session':session_key})
        print(response.text)
    else:
        print("No session key found, please login first")

try:
    while True:
        go = False
        go2 = False
        num = input('''1. Login\n2. Sign up\n3. Logout\n4. List all todos\n5. Create a new todo\n6. Get a todo\n7. Update a todo\n8. Delete a todo\n9. Get a todo item\n10. Create a todo item\n11. Update a todo item\n12. Delete a todo item\n13. Exit\n''')
        try:
            num = int(num)
            go = True
        except ValueError:
            print('Please provide a number!')
        try:
            if num < 1 or num > 13:
                raise Exception
            go2=True
        except Exception:
            print('Number must be from 1 to 12')
        
        if go and go2:
            match num:
                case 1:
                    login()
                case 2:
                    signup()
                case 3:
                    logout()
                case 4:
                    get_all_todo()
                case 5:
                    create_todo()
                case 6:
                    show_todo_id()
                case 7:
                    update_todo()
                case 8:
                    delete_todo()
                case 9:
                    get_todo_item()
                case 10:
                    create_todo_item()
                case 11:
                    update_todo_item()
                case 12:
                    delete_todo_item()
                case 13:
                    logout()
                    exit()
                case _:
                    print('Something went wrong')
            
            input('Continue?...')
except KeyboardInterrupt:
    exit()
```

This serves as a testing terminal application that allows the user to test all the functions of our `REST API`

### How the API works

For all the functions mentioned bellow you can use `HTTPie CLI` or our `python script`. We will demonstrate how to use the API with `HTTPie CLI` tool, because the use of our script is really easy.

#### Login

---

The first thing you must do is, of course, to login to receive a session.

```shell
http POST http://localhost:3000/auth.login email="demo@demo.gr" password="demoPass"
```

By doing so the request returns a response like this

```shell
HTTP/1.1 200 OK
Content-Length: 36
cache-control: max-age=0, private, must-revalidate
content-type: application/json; charset=utf-8
etag: W/"d7798a9ef354a1fcb018db70449e0f38"
referrer-policy: strict-origin-when-cross-origin
server-timing: sql.active_record;dur=12.87, start_processing.action_controller;dur=0.01, instantiation.active_record;dur=1.77, process_action.action_controller;dur=304.81
set-cookie: _app_session=DaAOzKatEfTuFIDuBVKCdVmF1YbQfZBhVTuh%2F%2BPpoLKwjwsQHpHeFFxHk%2F3%2B5KTbjFs2oVOTKjA%2FCEJTvrPvGPprkcN9fy3YLLJ1xmK0xypuBvN9XeWJdGsrV0uc2QTLIBRPGmqAWrRPQzTfh5f4Pzc1xArCkO2IfWSBHSMWKXVCAH4ijdyeIdqfjb2zRcf3qVP2TUORdkCJ7KcCe7YNY5L8LPlU9K5%2FOGLaUOhrcSCosCUuciq8pFFqF5UP24RYuHeNC8qxNoikx21qlVQ%2BZBGcx0k%3D--7LIoU88kdvdFQydS--GQYi11XNvEHUh5s%2FmfnOqw%3D%3D; path=/; httponly; samesite=lax
x-content-type-options: nosniff
x-frame-options: SAMEORIGIN
x-permitted-cross-domain-policies: none
x-request-id: 944f8ca0-84fe-4e79-9c69-bb4667300539
x-runtime: 0.418303
x-xss-protection: 0

{
    "message": "Logged in successfully"
}
```

Please notice the `set-cookie:` variable in the response. This is our session token. This token can be used to access the rest of the app - as it serves as our authentication. You must store this somewhere in order to proceed.

#### Sign-up

---

If you don't have an account, yet, you can create one like so

```shell
http POST http://localhost:3000/signup 'user[email]=demo@demo.gr' 'user[password]=demoPass' 'user[password_confirmation]=demoPass'
```

Please note that providing `user[attribute]` instead of `attribute` is really important. It won't work otherwise!

This will return a message like this, so you know it is successful

```shell
HTTP/1.1 201 Created
Content-Length: 39
cache-control: max-age=0, private, must-revalidate
content-type: application/json; charset=utf-8
etag: W/"8778e358444656690b5d998f57f47a99"
referrer-policy: strict-origin-when-cross-origin
server-timing: start_processing.action_controller;dur=0.01, sql.active_record;dur=3.22, start_transaction.active_record;dur=0.00, transaction.active_record;dur=4.45, process_action.action_controller;dur=271.51
x-content-type-options: nosniff
x-frame-options: SAMEORIGIN
x-permitted-cross-domain-policies: none
x-request-id: 73e44ba5-4e99-4b6c-a12e-84596188f984
x-runtime: 0.277723
x-xss-protection: 0

{
    "message": "User created successfully"
}

```

#### Logout

---

Logging-out is also crucial! To do so after you are done using the api, you can simply send a GET request to auth/logout to delete your session.

```shell
http GET http://localhost:3000/auth.logout
```

This should return something like this

```shell
HTTP/1.1 200 OK
Content-Length: 37
cache-control: max-age=0, private, must-revalidate
content-type: application/json; charset=utf-8
etag: W/"28b8f3fe95843547dbb631cb6c66aaff"
referrer-policy: strict-origin-when-cross-origin
server-timing: start_processing.action_controller;dur=0.01, process_action.action_controller;dur=30.66
set-cookie: _app_session=b5F12fxEKY1b1ggVua6NZhTnGsZD0OqcXivh8wd%2BqYnVQlU3FtNm1IP2gBRw9HqDHl%2F9UL6%2Bue%2BBvCZOm8ErowZ4sqfLS7jTkpS7O%2BkRy988OE30wipqn7wtdVutTSZRiScQ%2F6rqa8qmSV%2F9q0lZVBSbKIuXMpSGCFUNw5SxhvgHIK5u--FpgCgGIvh0Qz0eqh--XVuBBpWFjT9tTdMhRJ5DTg%3D%3D; path=/; httponly; samesite=lax
vary: Accept
x-content-type-options: nosniff
x-frame-options: SAMEORIGIN
x-permitted-cross-domain-policies: none
x-request-id: b29f94b9-f2db-48bf-99ef-566c8004bd1b
x-runtime: 0.048605
x-xss-protection: 0

{
    "message": "Logged out successfully"
}
```

#### Listing all TODOs

---

To list all of your current TODO lists you can make a get request to /todo like so

```shell
http GET http://localhost:3000/todo Cookie:'_app_session{Your app session}'
```

This will return a list containing your todo items like so

```shell
HTTP/1.1 200 OK
Content-Length: 269
cache-control: max-age=0, private, must-revalidate
content-type: application/json; charset=utf-8
etag: W/"16ed39b1c75aa7848f6f4ed7b080ce58"
referrer-policy: strict-origin-when-cross-origin
server-timing: start_processing.action_controller;dur=0.01, sql.active_record;dur=2.59, instantiation.active_record;dur=4.73, process_action.action_controller;dur=51.65
set-cookie: _app_session=K4frLgE9yrWhN0Paoery5ylruVcFo%2B7M4U2SKEnXYpWQKZe7levJB%2FNu0kiObXLPtpZ6df82Df5vNUciO1110C4GKC64l6GeFSV1pjJ%2BtR8CMH9FXkif0mC0YwbBm7ChP0Z6TavnHbJVsmkF3ycr5f3e4lApVGXBnhDT1aR5knFfhHDAeQfUQmM5fpNLeQFXFtxU74lesN5DS2s5v%2BFHXIojxH9p%2BLuWNyTBcYO4g%2FRyFiYFIoUIhD0v3WLQZb9clo4fnv%2FY5t5zfyGCGDChfwsx2ao%3D--2T%2BGsx4MZe8Ppuh5--MLPtTpO2a1HFUP8JVaT5BA%3D%3D; path=/; httponly; samesite=lax
vary: Accept
x-content-type-options: nosniff
x-frame-options: SAMEORIGIN
x-permitted-cross-domain-policies: none
x-request-id: e5f12fe9-4ec2-43f9-a453-dc7bb1f174db
x-runtime: 0.058747
x-xss-protection: 0

[
    {
        "created_at": "2025-01-23T21:37:02.687Z",
        "description": "t",
        "id": 4,
        "title": "t",
        "updated_at": "2025-01-23T21:37:02.687Z",
        "user_id": 3
    },
    {
        "created_at": "2025-01-23T22:14:26.897Z",
        "description": "1234",
        "id": 5,
        "title": "todo",
        "updated_at": "2025-01-23T22:14:26.897Z",
        "user_id": 3
    }
]
```

#### Create a new TODO

---

To create a new todo you must make a post request to `/todo` like so

```shell
http POST http://localhost:3000/todo 'todo[title]'='Demo' 'todo[description]'='DemoDescription' Cookie:"_app_session{Your session key}"
```

This will return something like this

```shell
HTTP/1.1 201 Created
Content-Length: 147
cache-control: max-age=0, private, must-revalidate
content-type: application/json; charset=utf-8
etag: W/"a3b78460d3cb523819a58ec04def9fcb"
referrer-policy: strict-origin-when-cross-origin
server-timing: start_processing.action_controller;dur=0.00, sql.active_record;dur=7.78, instantiation.active_record;dur=0.13, start_transaction.active_record;dur=0.00, transaction.active_record;dur=1.88, process_action.action_controller;dur=42.60
set-cookie: _app_session=l%2Fmf8ln%2BVPL9AO2ljMG39BgPrmfRd%2Bpmeu920vh%2BblX8EwD7%2FbdHVpI3wxKan3EJbHoKGYNk4ERB%2FMW4TtX9b3CjM957PWpcJBq35FCjS7MqSKSrZ5hE35Sf7AsqFe9hXFQRK3xV9algk358kpxGCeO1NMEvOaVHDbqHHK93lKotlp5ow%2BDNxRAM7%2F6lFjO7bEsAKEvpMh5lTHoibi26P8GGRaQZu6ELNI0bWLCoN1Eq7hJ8UgYxVWFKU1J3m5x2qs5636Jsu4IPlP5J0sxGWpqks8w%3D--C7b3AGyD1uXPOO%2BL--DUdrJj18RHheR%2FOMvdcreA%3D%3D; path=/; httponly; samesite=lax
x-content-type-options: nosniff
x-frame-options: SAMEORIGIN
x-permitted-cross-domain-policies: none
x-request-id: 47afa720-2765-4046-86ef-d14496353db8
x-runtime: 0.052266
x-xss-protection: 0

{
    "created_at": "2025-01-24T13:40:24.660Z",
    "description": "DemoDescription",
    "id": 6,
    "title": "Demo",
    "updated_at": "2025-01-24T13:40:24.660Z",
    "user_id": 3
}
```

#### Get a specific TODO list with its TODO items

---

You can access any of your TODO lists by using a get request in /todo/id like so

```shell
http get http://localhost:3000/todo{ID} Cookie:"_app_session{Your session key}'
```

This will return something like

```shell
HTTP/1.1 200 OK
Content-Length: 152
cache-control: max-age=0, private, must-revalidate
content-type: application/json; charset=utf-8
etag: W/"3bee32c6b65694be75e5f289e2915184"
referrer-policy: strict-origin-when-cross-origin
server-timing: start_processing.action_controller;dur=0.01, sql.active_record;dur=0.92, instantiation.active_record;dur=0.45, process_action.action_controller;dur=51.21
set-cookie: _app_session=BoAnhYvZz7IC4yu9ttz1km2D400OxdRcDqW6fnC%2FJev2KnsMcL4MIHgaDGjyp%2FbPYEGwLkayrBdH524LPi52MKv%2F5Rac8b9YJCiFQ7BtZUaLK2mwLtnWYFizvj2FBYRT09Lw0IMmsV2sBnISMdSvdRzsDi%2BqLTlpv8Foh3IHrVWHplMorRnOMVjQwduXMQpg1dChIURo097KnM1dYcAd6m%2FOHlg2oxnne%2Fhpp5v7jHyazHNky4EGsNZIy2hq8GXP8LZR7H52i9uaVlWW3D9%2BesX9Yt4%3D--4BkW8oPka4AAu2%2BU--pHkSJq1yX4foE8%2FdsDd8Uw%3D%3D; path=/; httponly; samesite=lax
vary: Accept
x-content-type-options: nosniff
x-frame-options: SAMEORIGIN
x-permitted-cross-domain-policies: none
x-request-id: dddcc658-783e-4b0d-8703-31c2938cdc10
x-runtime: 0.072019
x-xss-protection: 0

{
    "created_at": "2025-01-23T22:14:26.897Z",
    "description": "1234",
    "id": 5,
    "title": "todo",
    "todo_items": [],
    "updated_at": "2025-01-23T22:14:26.897Z",
    "user_id": 3
}
```

#### Update a TODO

---

To update a todo you can simply make a PUT request to /todo/id with the field you want to change like so

```shell
http PUT http://localhost:3000/todo{ID} 'todo[title]'='ChangedDemo' Cookie:"_app_session{Your session key}'
```

This will return something like this

```shell
HTTP/1.1 200 OK
Content-Length: 143
cache-control: max-age=0, private, must-revalidate
content-type: application/json; charset=utf-8
etag: W/"804fbce768e779921810dfcc5ac6b47d"
referrer-policy: strict-origin-when-cross-origin
server-timing: start_processing.action_controller;dur=0.03, sql.active_record;dur=2.59, instantiation.active_record;dur=0.24, start_transaction.active_record;dur=0.00, transaction.active_record;dur=1.91, process_action.action_controller;dur=43.67
set-cookie: _app_session=UmJuMBnQGucFt8LPSMW3UgaMvF4%2BJiKvcx5G0Z5an7QHhy7W05SNQME5GGTphmgdzq1fWWhWP3Gk%2Bs6uwG%2Fmoa5HCeqG%2BbFChu3%2Fl8c1QC02nqi8vlwTR2Ra%2Fttq8d7F3sgrnMgQA%2BZIL6WQ34MCUvKR90ai3WT8P01xvc0BrUzcAi4LTtTru%2FH4a49Y1%2FbAfyXCanD4M1oyxHR%2FKu%2BNCAo7uMpmbaiVtjdOTffe4mGrxOZSQVVripiys8Dzohs681wNjUFIWSII3Hlubc4CZKZtasA%3D--emgP7mIAEO3s39LJ--62UcWyynoRwV20D7zjJILw%3D%3D; path=/; httponly; samesite=lax
x-content-type-options: nosniff
x-frame-options: SAMEORIGIN
x-permitted-cross-domain-policies: none
x-request-id: 505689f2-3fd9-4a06-b46d-4005527d1021
x-runtime: 0.064931
x-xss-protection: 0

{
    "created_at": "2025-01-23T22:14:26.897Z",
    "description": "1234",
    "id": 5,
    "title": "ChangedDemo",
    "updated_at": "2025-01-24T13:45:41.851Z",
    "user_id": 3
}
```

Please keep in mind that you must only include the field you want to change. If you include a field it WILL get changed! For example if you type `'todo[title]'='ChangedDemo'`, it will only change the title of your TODO NOT the description and vice versa.

#### Deleting a todo and its items

---

To delete a todo and its items you can simply send a `DELETE` request to /todos/id.

```shell
http DELETE http://localhost:3000/todo{ID} Cookie:"_app_session{your session key}"
```

#### Creating a new todo item

---

To create a new TODO item you can do so by making a `POST` request in todo/{id}/todo_item.

```shell
http POST http://localhost:3000/todo/{ID}/todo_item "todo_item[content]"='content' "todo_item[completed]"=False Cookie:"_app_session={your session key}"
```

Note that you `todo_item[completed]` can only be True or False.
This will return something like this

```shell
HTTP/1.1 201 Created
Content-Length: 137
cache-control: max-age=0, private, must-revalidate
content-type: application/json; charset=utf-8
etag: W/"2f84c529cdb09d58745f9fa31088754e"
referrer-policy: strict-origin-when-cross-origin
server-timing: start_processing.action_controller;dur=0.01, sql.active_record;dur=1.67, instantiation.active_record;dur=0.07, start_transaction.active_record;dur=0.00, transaction.active_record;dur=1.61, process_action.action_controller;dur=33.89
set-cookie: _app_session=fpsgTBz6CteR6Y%2Fesadh6UZlX1eDZf5URgWbUNWmZzNZ7MOZTQQNpAlNuGIT009Kz4%2Fv7RjgWy7O2H65ylYVxfXDOcGJCsZCuCkCCNFPaKkRAvtTXgcGF1OtZ0mxKb13Yh0JexgH29TalvDNopbzqWfWjy54eQvY34Z1Ib5BIE3c9OomLQ%2BeZdoPdRPpMMdDAGLZ3O7rYHcixuYwW3H69weSIJgHgxK9W%2BgRytvp7ordVe4%2BUbByb7LDvQ26iIM%2B4j1nIQ1zQeGi%2BjwdTId%2Ff%2FeYRUo%3D--zdVmSJaMOssNSdb%2F--GKsv3wWBi6T62gDdzD3j7g%3D%3D; path=/; httponly; samesite=lax
x-content-type-options: nosniff
x-frame-options: SAMEORIGIN
x-permitted-cross-domain-policies: none
x-request-id: 26fcd662-b661-4f59-90e8-0a5e6dab251b
x-runtime: 0.040519
x-xss-protection: 0

{
    "completed": true,
    "content": "content",
    "created_at": "2025-01-24T13:55:59.178Z",
    "id": 3,
    "todo_id": 4,
    "updated_at": "2025-01-24T13:55:59.178Z"
}
```

#### Get a specific TODO item

---

To get a specific TODO item you must make a `GET` request to todo/{ID}/todo_item{ID2} where ID2 is the id of the TODO item.

```shell
http GET http://localhost:3000/todo/{ID}/todo_item/{ID2} Cookie:"_app_session={Your session key}"
```

This will return something like this

```shell
HTTP/1.1 200 OK
Content-Length: 137
cache-control: max-age=0, private, must-revalidate
content-type: application/json; charset=utf-8
etag: W/"2f84c529cdb09d58745f9fa31088754e"
referrer-policy: strict-origin-when-cross-origin
server-timing: start_processing.action_controller;dur=0.01, sql.active_record;dur=0.17, instantiation.active_record;dur=0.12, process_action.action_controller;dur=29.96
set-cookie: _app_session=o0v43%2FR%2BjNjaLaPqnsyArzNDG6HLtoQGd1TAa1TaoiwFZQKLsqzK7mLddEN76axfZRUB6nhgL6hFyDzhICPuJAyBULj7Z9BpzCz03eGLievUocEltPRREZ2%2FT8ctNSkaHs%2BESM%2FXUuLB%2F5GrW%2BqKM5qi74YLUGQGea348TIWfHGfzGqcRo02ZdAr7vjX3Y81P7g0hhj%2BFYZGDxR%2Fn%2FW7LRcVwNuZ7XfFxYarMPannIB0gfG2vi8sJIfQ%2FlNKtJWnoPmLQszF7rOGAEJ%2BM4Flggqw748%3D--poV1GJcJRM6YsSHP--RH%2FpQvNWTQAqLyqu88SwWg%3D%3D; path=/; httponly; samesite=lax
vary: Accept
x-content-type-options: nosniff
x-frame-options: SAMEORIGIN
x-permitted-cross-domain-policies: none
x-request-id: 7ad8ac64-9923-4298-9116-bb932ff2d1c5
x-runtime: 0.036748
x-xss-protection: 0

{
    "completed": true,
    "content": "content",
    "created_at": "2025-01-24T13:55:59.178Z",
    "id": 3,
    "todo_id": 4,
    "updated_at": "2025-01-24T13:55:59.178Z"
}
```

#### Updating a todo item

---

To update a todo item you must make a `PUT` request to /todo/{id}/todo_item/{id2}

```shell
http PUT http://localhost:3000/todo/{ID}/todo_item/{ID2} "todo_item[completed]"=True Cookie:"_app_session={Your session key}"
```

As we also saw in the other PUT request, include only the fields you want to be changed!
This will return something like this

```shell
HTTP/1.1 200 OK
Content-Length: 137
cache-control: max-age=0, private, must-revalidate
content-type: application/json; charset=utf-8
etag: W/"443231586ea9eee471804b76499dee45"
referrer-policy: strict-origin-when-cross-origin
server-timing: start_processing.action_controller;dur=0.01, sql.active_record;dur=0.46, instantiation.active_record;dur=0.25, process_action.action_controller;dur=35.97
set-cookie: _app_session=0%2FSKQwrXuN%2F8ZaV0YRcttJ4lFbXJ4XCTKhjzSAK0b9u%2B5BuE3H69FOfvtSoKgFAGPhfAqCoIutWKOU0eMpnHg6qQ6L4FZIhwVMKSkOP%2BRTYY%2B3o55%2B9cgC8y0RLH4Za1Cv%2BcyI1B0qreMGuthaO%2FDWTumZDFJnK57Ra9JdznqgjTg%2FzxymPJ1y6Pm2r6%2BCnIFuNVUu1ksQPz7xmJ%2Bek8jLUrsB%2FCl1EZlW66zq8Kcv%2F8fsV%2BtlQxOwZKJHBzVXpgsQXi8GATDnZ%2FquF3rIzz2CWSVaY%3D--fDg62OFLCB%2Bo9aD9--2J6OJiDj42fH4XVxinb6MA%3D%3D; path=/; httponly; samesite=lax
x-content-type-options: nosniff
x-frame-options: SAMEORIGIN
x-permitted-cross-domain-policies: none
x-request-id: 6adc4609-5656-4182-97fd-95bf8426117f
x-runtime: 0.057253
x-xss-protection: 0

{
    "completed": true,
    "content": "content",
    "created_at": "2025-01-24T13:55:59.178Z",
    "id": 3,
    "todo_id": 4,
    "updated_at": "2025-01-24T13:55:59.178Z"
}
```

#### Deleting a TODO item

---

To delete a TODO item from a todo list you must make a `DELETE` request to todo/{ID}/todo_item/{ID2}.

```shell
http DELETE http://localhost:3000/todo/{ID}/todo_item/{ID2} Cookie:"_app_session={Your session key}"
```

This will return something like this

```shell
HTTP/1.1 204 No Content
cache-control: no-cache
referrer-policy: strict-origin-when-cross-origin
server-timing: start_processing.action_controller;dur=0.02, sql.active_record;dur=1.46, instantiation.active_record;dur=0.24, start_transaction.active_record;dur=0.00, transaction.active_record;dur=0.95, process_action.action_controller;dur=46.68
set-cookie: _app_session=KxqSg6hu4zcotZisVYPWLsGRyjjUCkwFkOfnX8vBjig8cYYtOfC%2FZhpurzL3Us7XF9gwO0q%2BPEoEl2258ph7P78YO66OXmqJOa1DW6tZEdg2bBop4rK2Sz4wREilnHo4KL6q5%2BgR6TTjkEF3PviKBzG3UnqLWrg1DVy3bwl4bssogcBzKEK6SmPZlbDworObn0z9IpsmPVYa91eJ0IOnAFbD3bwLJlX56eDLUKU9z3%2B7GQ6ZsT6ZvfG%2BQo2lwLeLVKcyhVNeNzbY8XrRHycg%2BPnrKOM%3D--jriZctJ9Y44xHHla--Ux576Qd0bztbc%2F54dUTvgg%3D%3D; path=/; httponly; samesite=lax
x-content-type-options: nosniff
x-frame-options: SAMEORIGIN
x-permitted-cross-domain-policies: none
x-request-id: 750f46b9-7a8c-462b-bf13-2c81423c03c9
x-runtime: 0.066243
x-xss-protection: 0
```

If the HTTP/1.1 return code is 204 (No Content) it means you successfully deleted the TODO item.

## Technologies used

---

- Users -> [Device gem](https://rubygems.org/gems/devise)
- Realtime messaging -> [Action cable](https://guides.rubyonrails.org/action_cable_overview.html)
- Notifications -> [Noticed gem](https://rubygems.org/gems/noticed)
