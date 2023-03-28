
from bottle import run, route
import webbrowser

@route("/")
def index():
    return "<h1>Hello, world</h1>"

@route("/user/<username>")
def user(username):
    return f"<h1>Hello, {username}</h1>"

if __name__ == "__main__":
    webbrowser.open("http://localhost:8080/")
    run(host="localhost", port=8080)