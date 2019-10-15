[![Known Vulnerabilities](https://snyk.io/test/github/StrongMind/canvas-google-drive-connector/badge.svg?targetFile=Gemfile.lock)](https://snyk.io/test/github/StrongMind/canvas-google-drive-connector?targetFile=Gemfile.lock)

# Canvas LMS Google Drive Integration LTI

This project allows direct integration of an organization's Google Drive into their Canvas LMS Instance.

The current Instructure version of the LTI is only compatible with Enterprise hosted Canvas Instances and would not function properly (or at all in most cases) with self hosted instances (like ours).

This application is deployed to the [canvas-google-lti-connector](https://us-west-2.console.aws.amazon.com/elasticbeanstalk/home?region=us-west-2#/application/overview?applicationName=canvas-google-lti-connector) app on AWS Elastic Beanstalk app.

### Prerequisites

This project uses Ruby and [rack](https://rack.github.io/) to provide all of the functionality required for Google Drive integration. 


- [ruby-2.5.0](https://www.ruby-lang.org): `rvm install 2.5.0`
- [docker](https://docs.docker.com/)
- [docker-compose](https://docs.docker.com/compose/)

### Env Setup

This project uses docker-compose to configure and startup instances of the application, postgreSQL DB and redis (reeediss). All of these are required for the application to properly function.

#### Start the app

From the project root, issue the `docker-compose up -d` command to start all containers in a daemon. This will start all required services and make your application available at [http://localhost:5000](http://localhost:5000)

#### Prepare the DB

When you first start the application, you'll need to create the database and run the migrations. You can do this by executing the below command from the project root:

`docker exec google-lti-connector bundle exec rake db:create db:migrate`

If you create any migrations or need to run just the migrations and not create the DB, you can simply drop the `db:create` task:

`docker exec -it google-lti-connector bundle exec rake db:migrate`

## Deployment

When code changes are merged to master, they are automatically built and a container image is pushed to AWS ECR. The ID used is the commit hash so it's easier to keep versions separate. This can easily be modified in the future to use named versions, or any other type of labeling. 

After the image has been built and pushed to ECR, you can deploy using the [`deploy_gdrive_lti.sh`](https://github.com/StrongMind/canvas_deployment/blob/master/deploy_gdrive_lti.sh) script in the [canvas_deployment](https://github.com/StrongMind/canvas_deployment) repository.

Replace `COMMIT_HASH` wth the actual hash of the image you want to deploy


### To deploy production

```
./deploy_gdrive_lti.sh production COMMIT_HASH
```

### To deploy dev

```
./deploy_gdrive_lti.sh dev COMMIT_HASH
```

### To deploy to a new env

New environments can be created as necessary for the Elastic Beanstalk app. This can be done using ansible (or some other infrastructure provisioning) or manually from the AWS console.

### Areas for improvement

- On god, this needs CI/CD. Just come in one slow Monday morning and yeet it. 
- This LTI requires a couple manual steps to setup (copy config URL, generate key and secret) which takes time and requires the user to visit multiple pages. This *COULD* be accomplished via an API (tools can be configured this way) so this entire process could be automated.
- The app can be used with any Canvas instance, and isn't restricted by domain or anything to ensure that the instance is one of ours. We should do this fam. 
