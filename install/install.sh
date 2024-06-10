GITOPS_NAMESPACE=openshift-gitops

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
oc apply -f ../argo-apps/cluster-scoped/subs.yaml


while [[ argoSecret=$(oc -n $GITOPS_NAMESPACE get secret $GITOPS_NAMESPACE-cluster 2>&1 > /dev/null) == *"Error"* ]]
do
echo "Waiting until ArgoCD CR is ready..."
sleep 5
done
oc -n $GITOPS_NAMESPACE patch secret $GITOPS_NAMESPACE-cluster --patch "{\"stringData\": {\"admin.password\": \"$ARGOCD_ADMIN_PASSWORD\"}}"
oc -n $GITOPS_NAMESPACE patch secret argocd-secret --patch "{\"data\": {\"admin.password\": null}}"



oc apply -f ../argo-apps/cluster-scoped/application-set.yaml -n $GITOPS_NAMESPACE

echo "Installation complete!" 
