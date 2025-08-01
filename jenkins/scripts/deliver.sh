#!/usr/bin/env bash

echo '🔧 Installing the Maven-built Java application into the local repository...'
set -x
mvn clean package install
set +x

echo '📦 Extracting <name> from pom.xml...'
NAME=$(mvn help:evaluate -Dexpression=project.name -q -DforceStdout | sed -E 's/\x1B\[[0-9;]*[JKmsu]//g')

echo '📦 Extracting <version> from pom.xml...'
VERSION=$(mvn help:evaluate -Dexpression=project.version -q -DforceStdout | sed -E 's/\x1B\[[0-9;]*[JKmsu]//g')

JAR_FILE="target/${NAME}-${VERSION}.jar"

echo "🔍 Checking if JAR file exists: $JAR_FILE"
if [ -f "$JAR_FILE" ]; then
  echo "🚀 Running Java application: $JAR_FILE"
  set -x
  java -jar "$JAR_FILE"
  set +x
else
  echo "❌ ERROR: JAR file not found: $JAR_FILE"
  echo "📄 Try checking the actual files in 'target/' directory:"
  ls -lh target/
  exit 1
fi
