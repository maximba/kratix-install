#!/bin/bash
set -e 
source .env

# Color codes and icons
GREEN='\033[1;32m'
NC='\033[0m'
INFO_ICON=$(echo -e "\xE2\x84\xB9")    # ℹ
CHECK_ICON=$(echo -e "\xE2\x9C\x94")   # ✔

# 1. Install cert-manager
echo -e "${GREEN}${INFO_ICON} Installing cert-manager...${NC}"
kubectl --context $PLATFORM apply -f \
https://github.com/cert-manager/cert-manager/releases/download/v1.15.0/cert-manager.yaml

# 2. Wait for cert-manager to be up
echo -e "${GREEN}Waiting for cert-manager ...${NC}"
kubectl --context $PLATFORM wait --for=condition=Available deployment/cert-manager \
  --namespace cert-manager --timeout=300s

# 3. Apply the Kratix manifest
echo -e "${GREEN}${INFO_ICON} Installing Kratix...${NC}"
kubectl --context "$PLATFORM" apply -f https://github.com/syntasso/kratix/releases/latest/download/kratix.yaml

# 4. Wait for the CRDs to be established (Kratix relies on these)
echo -e "${GREEN}${INFO_ICON} Waiting for Kratix CRDs...${NC}"
kubectl --context "$PLATFORM" wait --for=condition=established --timeout=60s crd/promises.platform.kratix.io

# 5. Wait for the Kratix Controller Deployment to be ready
echo -e "${GREEN}${INFO_ICON} Waiting for Kratix Controller to be available...${NC}"
kubectl --context "$PLATFORM" -n kratix-platform-system wait --for=condition=available --timeout=120s deployment/kratix-platform-controller-manager

# 6 Creating secret in github
echo -e "${GREEN}${INFO_ICON} Creating secret for Kratix with Github credentials ...${NC}"

kubectl --context "$PLATFORM" create secret generic git-credentials \
  --namespace kratix-platform-system \
  --from-literal=username="$GITHUB_USERNAME" \
  --from-literal=password="$GITHUB_TOKEN" \
  --dry-run=client -o yaml | kubectl --context "$PLATFORM" apply -f -

# 7 Create git state store
echo -e "${GREEN}${INFO_ICON} Creating git-state-store ...${NC}"
kubectl --context $PLATFORM apply -f k8s/git-state-store.yaml

# 8 Verify the state store is ready
echo -e "${GREEN}${INFO_ICON} Waiting the state store is ready ...${NC}"
kubectl --context $PLATFORM get gitstatestores

# 9 Registering the worker cluster
echo -e "${GREEN}${INFO_ICON} Registering the worker clsuter ...${NC}"
kubectl --context $PLATFORM apply -f k8s/worker-destination.yaml

# 10 Verify destionation is registered
echo -e "${GREEN}${INFO_ICON} Verify destinations ...${NC}"
kubectl --context $PLATFORM get destinations


# 11 Install Flux on the worker cluster
echo -e "${GREEN}${INFO_ICON} Install Flux on the worker cluster ...${NC}"
kubectl --context $WORKER apply -f \
  https://github.com/fluxcd/flux2/releases/latest/download/install.yaml

# 12 Wait for Flux to be ready
echo -e "${GREEN}${INFO_ICON} Wait for Flux to be ready ...${NC}"
kubectl --context $WORKER wait --for=condition=Ready pod \
  --all --namespace flux-system --timeout=300s


echo -e "${GREEN}${CHECK_ICON} Kratix is fully initialized! Proceeding to next step...${NC}"

