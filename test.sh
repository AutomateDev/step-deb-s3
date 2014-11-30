#!/bin/sh
set -e;

ADDITIONAL_ARGUMENTS=" "

init_wercker_environment_variables() {
  echo "Checking variables"
  if [ ! -n "$WERCKER_DEB_S3_KEY" ]
  then
    echo 'missing or empty option key, please check wercker.yml';
  fi

  if [ ! -n "$WERCKER_DEB_S3_SECRET" ]
  then
    echo 'missing or empty option secret, please check wercker.yml';
  fi

  if [ ! -n "$WERCKER_DEB_S3_BUCKET" ]
  then
    echo 'missing or empty option bucket, please check wercker.yml';
  fi

  if [ ! -n "$WERCKER_DEB_S3_PACKAGE" ]
  then
    echo 'missing or empty option package, please check wercker.yml';
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

echo 'setup step';

init_wercker_environment_variables;

echo 'starting synchronisation';

echo deb-s3 upload --bucket ${WERCKER_DEB_S3_BUCKET} --use-ssl --access-key-id=${WERCKER_DEB_S3_KEY} --secret-access-key=${WERCKER_DEB_S3_SECRET}${ADDITIONAL_ARGUMENTS} ${WERCKER_DEB_S3_PACKAGE}