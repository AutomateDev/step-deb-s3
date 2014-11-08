#!/bin/sh
set -e;

init_wercker_environment_variables() {
  info "Checking variables"
  if [ ! -n "$WERCKER_DEB_S3_KEY" ]
  then
    fail 'missing or empty option key, please check wercker.yml';
  fi

  if [ ! -n "$WERCKER_DEB_S3_SECRET" ]
  then
    fail 'missing or empty option secret, please check wercker.yml';
  fi

  if [ ! -n "$WERCKER_DEB_S3_BUCKET" ]
  then
    fail 'missing or empty option bucket, please check wercker.yml';
  fi

  if [ ! -n "$WERCKER_DEB_S3_PACKAGE" ]
  then
    fail 'missing or empty option package, please check wercker.yml';
  fi
}

install_build_tools() {
  info 'Installing build tools';
  sudo apt-get update;
  sudo apt-get install -y build-essential;
}

install_ruby() {
  info 'Installing ruby';
  sudo apt-get install -y ruby;
}

install_deb_s3() {
  info 'Installing deb-s3'
  sudo gem install deb-s3  --no-rdoc --no-ri --version 0.6.2;
}

info 'setup step';

init_wercker_environment_variables;
install_build_tools;
install_ruby;
install_deb_s3;

info 'starting synchronisation';

deb-s3 upload --bucket ${WERCKER_DEB_S3_BUCKET} --use-ssl --access-key-id=${WERCKER_DEB_S3_KEY} --secret-access-key=${WERCKER_DEB_S3_SECRET} ${WERCKER_DEB_S3_PACKAGE}