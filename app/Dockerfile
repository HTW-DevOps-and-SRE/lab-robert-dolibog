#I choose a python base image because my app  uses flask/ virtualenv, a python framework. The image makes it easier to access those, with pip and virtualenv already being installed.
FROM python:3.8-slim-buster

#Im creating a working directory on the image to house the files
WORKDIR /app

#copying the requirements.txt file for use as a parameter for the following RUN command
COPY requirements.txt requirements.txt

#installing the required frameworks onto the image
RUN pip3 install -r requirements.txt

#copying the rest of the files
COPY . .


#running the flask app as a module (-m) to make it externally accessable 
CMD [ "python3", "-m" , "flask", "run", "--host=0.0.0.0"]