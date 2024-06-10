TENANT1=tenant1
TENANT2=tenant2

while getopts "p:" opt; do
  case $opt in
    p) ARGOCD_ADMIN_PASSWORD="$OPTARG"
    ;;
    \?) echo "Invalid option -$OPTARG" >&2
    exit 1
    ;;
  esac

  case $OPTARG in
    -*) echo "Option $opt needs a valid argument"
    exit 1
    ;;
  esac
done

echo "Creating Subscription: argocd"
oc apply -f argocd-subs.yaml
oc apply -f tenant1-namespace.yaml
oc apply -f tenant2-namespace.yaml

echo "Waiting for operator to be installed..."
sleep 30
oc apply -f tenant1-argocd.yaml
oc apply -f tenant2-argocd.yaml

echo "Patching... ${TENANT1}"

while [[ argoSecret=$(oc -n ${TENANT1} get secret ${TENANT1}-gitops-cluster 2>&1 > /dev/null) == *"Error"* ]]
do
echo "Waiting until ArgoCD CR is ready..."
sleep 5
done
oc -n $TENANT1 patch secret $TENANT1-gitops-cluster --patch "{\"stringData\": {\"admin.password\": \"$ARGOCD_ADMIN_PASSWORD\"}}"
oc -n $TENANT1 patch secret argocd-secret --patch "{\"data\": {\"admin.password\": null}}"

echo "Patching... ${TENANT2}"

while [[ argoSecret=$(oc -n ${TENANT2} get secret ${TENANT2}-gitops-cluster 2>&1 > /dev/null) == *"Error"* ]]
do
echo "Waiting until ArgoCD CR is ready..."
sleep 5
done
oc -n $TENANT2 patch secret $TENANT2-gitops-cluster --patch "{\"stringData\": {\"admin.password\": \"$ARGOCD_ADMIN_PASSWORD\"}}"
oc -n $TENANT2 patch secret argocd-secret --patch "{\"data\": {\"admin.password\": null}}"

oc apply -f tenant1-project.yaml
oc apply -f tenant2-project.yaml


oc patch configmaps argocd-rbac-cm  -p '{"data":{"policy.default":" "}}' -n $TENANT1
oc patch configmaps argocd-rbac-cm  -p '{"data":{"policy.default":" "}}' -n $TENANT2

oc apply -f tenant1-app-of-apps.yaml
oc apply -f tenant2-app-of-apps.yaml


echo "Installation complete!" 
