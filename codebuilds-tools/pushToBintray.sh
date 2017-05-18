#!/bin/bash
set -e;

#Sample Usage: pushToBintray.sh package

API=https://api.bintray.com;
PACKAGE_DESCRIPTOR=bintray-package.json;
BINTRAY_USER=headmelted;

# These variables are set below in the loop to cater for globbing.  DO NOT SET HERE!!!
PACKAGE="";
PACKAGE_LOCAL="";
PACKAGE_FORMAT="";
PCK_NAME="";
TARGET="";
PROJECT="";

main() {
  CURL="curl -u${BINTRAY_USER}:${BINTRAY_API_KEY} -H Content-Type:application/json -H Accept:application/json";
  if (check_package_exists); then
    echo "The package ${PCK_NAME} does not exist. It will be created";
    if (create_package); then
      echo "Create package failed.";
      exit 1;
    fi;
  fi;

  upload_content;
}

check_package_exists() {
  echo "Checking if package ${PCK_NAME} exists...";
  package_exists=`[ $(${CURL} --write-out %{http_code} --silent --output /dev/null -X GET  ${API}/packages/${BINTRAY_USER}/${BINTRAY_REPO}/${PCK_NAME})  -eq 200 ]`;
  echo "Package ${PCK_NAME} exists? y:1/N:0 ${package_exists}";
  return ${package_exists};
}

create_package() {
  echo "Creating package ${PCK_NAME}...";
  if [ -f "${PACKAGE_DESCRIPTOR}" ]; then
    echo "Package configuration ${PACKAGE_DESCRIPTOR} exists."
    data="@${PACKAGE_DESCRIPTOR}";
  else
    echo "Package configuration ${PACKAGE_DESCRIPTOR} is missing."
    return 0;
  fi;

  ${CURL} -X POST -d "${data}" ${API}/packages/${BINTRAY_USER}/${BINTRAY_REPO};
  return 1;
}

deploy_packages() {
  echo "Publishing ${PACKAGE}...";
  ${CURL} -X POST ${API}/content/${BINTRAY_USER}/${BINTRAY_REPO}/${PROJECT}/${PCK_NAME}/publish -d "{ \"discard\": \"false\" }";
}

upload_content() {
  bintray_endpoint="${API}/content/${BINTRAY_USER}/${BINTRAY_REPO}/${PROJECT}/${PCK_NAME}/${PACKAGE_LOCAL}";
  echo "Uploading to ${bintray_endpoint}...";
  if [[ ${PACKAGE_FORMAT} == "deb" ]]; then
    bintray_endpoint="${bintray_endpoint};deb_distribution=wheezy;deb_component=main;deb_architecture=${TARGET};"
  fi;
  bintray_return_code=$(${CURL} ${headers} --write-out %{http_code} -T ${PACKAGE} ${bintray_endpoint});
  echo $bintray_return_code;
  if [ "$bintray_return_code" == "{\"message\":\"success\"}201" ]; then
    echo "Package ${PACKAGE_LOCAL} uploaded successfully.";
  else
    echo "Package ${PACKAGE_LOCAL} failed to upload.";
    exit 1;
  fi;
}

for f in $@; do
  PACKAGE=$f;
  PACKAGE_LOCAL=$(basename $PACKAGE);
  PACKAGE_FORMAT=${PACKAGE_LOCAL:(-3)};
  PCK_NAME="";
  TARGET="";
  PROJECT="";

  if [[ $PACKAGE_FORMAT == "deb" ]]; then
    VERSION_PATTERN="code-oss_(.*)_(.*).deb";
  else
    VERSION_PATTERN="code-oss-(.*).el7.(.*).rpm";
  fi;

  if [[ $PACKAGE_LOCAL =~ $VERSION_PATTERN ]]; then
    PROJECT="code-oss";
    PCK_NAME=${BASH_REMATCH[1]};
    TARGET=${BASH_REMATCH[2]};
    echo "Extracted project ${PROJECT} version ${PCK_NAME} and type ${TARGET} from ${PACKAGE_LOCAL}.";
  else
    echo "Unable to extract package version or type from ${PACKAGE_LOCAL}.";
    exit 1;
  fi;

  BINTRAY_REPO="${PACKAGE_FORMAT}-${PROJECT}";

  echo "Pushing ${PACKAGE_LOCAL} to bintray...";
  main "${PACKAGE}";
done;

deploy_packages;
