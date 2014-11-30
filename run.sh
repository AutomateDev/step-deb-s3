#!/bin/sh
set -e;

ADDITIONAL_ARGUMENTS=" "

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

  if [ -n "$WERCKER_DEB_S3_CODENAME" ]
  then
    ADDITIONAL_ARGUMENTS="$ADDITIONAL_ARGUMENTS--codename=$WERCKER_DEB_S3_CODENAME "
  fi

  if [ -n "$WERCKER_DEB_S3_COMPONENT" ]
  then
    ADDITIONAL_ARGUMENTS="$ADDITIONAL_ARGUMENTS--component=$WERCKER_DEB_S3_COMPONENT "
  fi

}

# Testing correctly whether executables are available:
# http://stackoverflow.com/a/677212

install_build_tools() {
  if dpkg -s build-essential >/dev/null 2>&1; then
    info 'Build tools already installed';
  else
    info 'Installing build tools';
    sudo apt-get update;
    sudo apt-get install -y build-essential;
  fi
}

install_ruby() {
  if hash ruby 2>/dev/null; then
    info 'Ruby already installed'
  else
    info 'Installing ruby';
    sudo apt-get install -y ruby1.9.1 ruby1.9.1-dev;
  fi
}

install_deb_s3() {
  if hash deb-s3 2>/dev/null; then
    info 'deb-s3 already installed'
  else
    info 'Installing deb-s3'
    sudo gem install deb-s3  --no-rdoc --no-ri --version 0.6.2;
  fi
}

info 'setup step';

init_wercker_environment_variables;
install_build_tools;
install_ruby;
install_deb_s3;

info 'starting synchronisation';

deb-s3 upload --bucket ${WERCKER_DEB_S3_BUCKET} --use-ssl --access-key-id=${WERCKER_DEB_S3_KEY} --secret-access-key=${WERCKER_DEB_S3_SECRET}${ADDITIONAL_ARGUMENTS} ${WERCKER_DEB_S3_PACKAGE}