#!/bin/python3


from flask import Flask, render_template, flash #i decided to use the flask framework for my webservice/ the framework appeared to be simple in understanding 

import time 


app = Flask(__name__)  # creates a class for the app

app.secret_key ="something_keyword" # needed for establishing a session


timestamps = [] 

@app.route('/') #establishes a general overwrite for the / url 

def index():
  flash(" ") # flashes data over to the html textarea
  return render_template('app.html')# returns the html file to the local port




@app.route("/clicks", methods=["GET"])          #used to handle get requests on the /clicks url
def get():

    flashmessage = "clicks: " + '\n'.join(timestamps)     
    flash(flashmessage)                         #flashes the message over to html
    return render_template('app.html')


     
@app.route("/clicks", methods=["POST"])         #used to handle post requests on the /clicks url
def post():
    time_now = str(int(time.time()))                 #gets the current time as an integer value
    timestamps.append(time_now)
    flashmessage = "timestamp:" + time_now  
    flash(flashmessage)                         

    return render_template('app.html')
    
    

if __name__ == '__main__': # handles errors / starts the debugger
    app.run(debug=True)   

app.run(host="0.0.0.0", port=80) # configurable port

