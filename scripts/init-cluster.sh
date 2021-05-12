#! /usr/bin/env bash

set -e

thisDir=$(dirname "$0")

switchNS() {
    verb="$1"
    ns="$2"

    printf "%s to '\e[33m%s\e[0m' namespace.\n" "$verb" "$ns"
    kubectl config set-context --current --namespace="$ns" 1> /dev/null
}

currentNS=$(kubectl config view --minify | awk '/namespace/ { print $NF }')

switchNS 'Switching' 'default'
echo

echo 'Applying manifests:'
echo
kubectl apply -f "$thisDir/../initialize/ServiceAccount.yml"
kubectl apply -f "$thisDir/../initialize/ClusterRoleBinding.yml"
echo

apiurl=$(TERM=dumb kubectl cluster-info | grep 'Kubernetes master' | awk '/http/ { print $NF }')

secretName=$(kubectl get secrets | awk '/gitlab/ { print $1 }')
# certData=$(kubectl get secret "$secretName" -o=jsonpath="{ ['data']['ca\.crt'] }" | base64 --decode)
serviceToken=$(kubectl get secret "$secretName" -o=jsonpath="{ ['data']['token'] }" | base64 --decode)

switchNS 'Returning' "$currentNS"

echo
printf 'API URL:           %s\n' "$apiurl"
printf 'Cert. secret name: %s\n' "$secretName"
printf 'Service token:     %s\n' "$serviceToken"
echo

echo "$serviceToken" | pbcopy

echo "Service token copied to clipboard"
