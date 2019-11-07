git_rev = $(shell git rev-parse HEAD)
git_branch = $(shell if [ -z $$TRAVIS_BRANCH ]; then git rev-parse --abbrev-ref HEAD; else echo $$TRAVIS_BRANCH; fi)
repo =  448312246740.dkr.ecr.us-west-2.amazonaws.com/google-lti-connector

build:
	docker build . -t $(repo):$(git_rev)

push:
	docker push $(repo):$(git_rev)
	echo "Pushed web"
 

