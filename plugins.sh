#!/usr/bin/env bash

set -e

REPOS=(
  # user    repo        install_file
  "sbaudoin sonar-yaml sonar-yaml-plugin"
  "sbaudoin sonar-ansible sonar-ansible-plugin"
  "sbaudoin sonar-shellcheck sonar-shellcheck-plugin"
  "QualInsight qualinsight-plugins-sonarqube-smell qualinsight-sonarqube-smell-plugin"
)

ghrelease() {
  curl -fL  "https://glare.now.sh/${1}/${2}/${3}" -o "${3}".jar
}

for i in "${REPOS[@]}"; do
  ghrelease $i
done
