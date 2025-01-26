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