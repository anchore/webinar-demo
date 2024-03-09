#!/bin/bash

namespace="anchore-demo"

echo "Using k8s namespace ${namespace}"
echo "Pre-flight checks..."
echo "Verifying kubectl installed..."
echo "Verifying helm installed..."
echo "Adding Anchore chart repository..."

echo "Verifying you have the image and license information from signup at: https://forms.gle/NMhpVU19SuXRnLhC9"
if ! test ./demo-secrets.yaml
then
  echo "No ./demo-secret.yaml file found to apply. Please go to: <insert url here> to sign up and get the license and pull secrets for the demo images"
  exit 1
fi

echo "Creating a k8s namespace for the demo: ${namespace}"
kubectl create ns ${namespace}

echo "Installing configuration/secrets for the demo"
kubectl -n ${namespace} apply -f ./demo-secrets.yaml

echo "Installing Anchore Enterprise to namespace ${namespace}"
helm install -n ${namespace} anchore-demo anchore/enterprise -f values.yaml