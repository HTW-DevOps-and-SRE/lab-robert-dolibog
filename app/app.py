#!/bin/python3


from flask import Flask, render_template, jsonify #i decided to use the flask framework for my webservice/ the framework appeared to be simple in understanding 
from flask_sqlalchemy import SQLAlchemy
import time
import os


app = Flask(__name__)  # creates a class for the app


app.config['SQLALCHEMY_DATABASE_URI'] = os.environ.get('DATABASE_URL', 'postgresql://robert:987654321@db:5432/mydb')


db = SQLAlchemy(app)



class Timestamp(db.Model): # Define the Timestamp model for the database
    id = db.Column(db.Integer, primary_key=True)
    timestamp = db.Column(db.Integer, default=int(time.time()) )
    


def create_tables(): # Create function to create the tables
    with app.app_context():
        db.create_all()


create_tables() # call the function to create tables





@app.route('/') #establishes a general overwrite for the / url 
def index():
  return render_template('app.html')# returns the html file to the local port




@app.route("/clicks", methods=["POST"])         #used to handle post requests on the /clicks url
def post():
    new_timestamp = Timestamp() 
    new_timestamp.timestamp = int(time.time())  # used to update the timestamp to the current time
    db.session.add(new_timestamp)               #adds the new_timestamp onto the database(db)
    db.session.commit()
    return jsonify({'timestamp': new_timestamp.timestamp})  




@app.route("/clicks", methods=["GET"])          #used to handle get requests on the /clicks url
def get():
    timestamps = Timestamp.query.all()          #puts the Timestamp table into the timestamps list
    return jsonify([{'id': timestamp.id, 'timestamp': timestamp.timestamp} for timestamp in timestamps])





if __name__ == '__main__': # handles errors / starts the debugger
    app.run(debug=True)   



