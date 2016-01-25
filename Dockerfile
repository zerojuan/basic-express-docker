FROM node:argon

# create app directory
RUN mkdir -p /usr/src/app
WORKDIR /usr/src/app

#install app dependencies
COPY package.json /usr/src/app
RUN npm install

# Bundle app source
COPY . /usr/src/app

EXPOSE 8080
CMD [ "npm", "start" ]
