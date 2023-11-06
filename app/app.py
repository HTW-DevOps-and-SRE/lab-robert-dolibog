#!/bin/python3


from flask import Flask, render_template, flash #i decided to use the flask framework for my webservice/ the framework appeared to be simple in understanding 
from flask_restful import Resource, Api
import time 


app = Flask(__name__)  # creates a class for the app

app.secret_key ="something_keyword" # needed for establishing a session

api = Api(app) # creates the api that communicates with the requests

timestamps = [] 

@app.route('/') #establishes a general overwrite for the / url 

def index():
  flash(" ") # flashes data over to the html textarea
  return render_template('app.html') # returns the html file to the local port



class Timestamps(Resource):         #used to handle get requests on the /clicks url
    def get(self):                      
        return {"clicks": timestamps}


class Timestamp(Resource):         #used to handle post requests on the /clicks url

    def post(self):
        
        time_now = int(time.time()) #gets the current time as an integer value
        timestamps.append(time_now)

        return {"timestamp": time_now}
    
    
   


api.add_resource(Timestamps, '/clicks') #adds the handler classes as a resource to the api
api.add_resource(Timestamp, '/clicks') # --


app.run(host="0.0.0.0", port=80) # configurable port

if __name__ == '__main__': # handles errors
    app.run(debug=True)