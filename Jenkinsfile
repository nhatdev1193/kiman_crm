env.DB_HOST = "192.168.12.187"
node {

  checkout scm

  stage("Set up RVM Component") {
    sh '''#!/bin/bash -l

      rvm use 2.5.0'''
  }

  stage("Bundle Install") {
    sh '''#!/bin/bash -l

      gem install bundler

      bundle install'''
  }

  stage("Create DB") {
    sh '''#!/bin/bash -l

      rails db:create'''
  }

  stage("Migrate DB") {
    sh '''#!/bin/bash -l

      rails db:migrate'''
  }

  stage("Install node_modules") {
    sh '''#!/bin/bash -l

      yarn install'''
  }

  // stage("Testing") {
  //   sh '''#!/bin/bash -l

  //     rails db:migrate RAILS_ENV=test

  //     rspec'''
  // }

  stage("Build Staging") {
    try {
      if(env.BRANCH_NAME == 'develop') {
        sh "docker build --no-cache -t app ."
        sh "docker run -e DB_HOST=${DB_HOST} -d -p 3000:3000 app"
      }
    }
    catch(e) {
      error "Build Staging server failed"
    }
  }

  stage("Build Production") {
    try {
      if(env.BRANCH_NAME == 'master') {
        sh "docker-compose build"
      }
    }
    catch(e) {
      error "Build production server failed"
    }
  }
}
