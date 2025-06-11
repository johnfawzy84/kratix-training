#!/bin/bash

set -e

echo "1. Checking if kratixuser is in docker group..."
if id kratixuser | grep -q 'docker'; then
  echo "kratixuser is in docker group."
else
  echo "kratixuser is NOT in docker group."
  exit 1
fi

echo "2. Checking required tools..."
for tool in kind kubectl yq mc k9s; do
  if ! command -v $tool &>/dev/null; then
    echo "$tool is NOT installed."
    exit 1
  else
    echo "$tool is installed."
  fi
done

echo "3. Checking kratix repo..."
if [ -d kratix ]; then
  echo "kratix repo exists."
else
  echo "kratix repo NOT found."
  exit 1
fi

echo "4. Checking kind clusters..."
for cluster in platform worker; do
  if kind get clusters | grep -q "$cluster"; then
    echo "Kind cluster '$cluster' exists."
  else
    echo "Kind cluster '$cluster' does NOT exist."
    exit 1
  fi
done

echo "5. Checking cert-manager pods in platform cluster..."
if kubectl --context kind-platform get pods -n cert-manager 2>/dev/null | grep -q Running; then
  echo "cert-manager pods are running."
else
  echo "cert-manager pods are NOT running."
  exit 1
fi

echo "6. Checking MinIO installation in platform cluster..."
if kubectl --context kind-platform get pods -n minio 2>/dev/null | grep -q Running; then
  echo "MinIO pods are running."
else
  echo "MinIO pods are NOT running."
  exit 1
fi

echo "7. Checking Flux in worker cluster..."
if kubectl --context kind-worker get deployments -n flux-system 2>/dev/null | grep -q flux; then
  echo "Flux deployments found."
else
  echo "Flux deployments NOT found."
  exit 1
fi

echo "All checks passed!"
