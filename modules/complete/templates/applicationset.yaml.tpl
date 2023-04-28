apiVersion: argoproj.io/v1alpha1
kind: ApplicationSet
metadata:
  name: ${app_name}
  namespace: argocd
spec:
  generators:
  - git:
      repoURL: ${app_repo_url}
      revision: HEAD
      directories:
      - path: ${app_repo_path}
  template:
    metadata:
      name: ${path_app_name}
      namespace: argocd
    spec:
      project: default
      source:
        repoURL: ${app_repo_url}
        targetRevision: HEAD
        path: ${path_app}
      destination:
        server: https://kubernetes.default.svc
        namespace: ${path_app_name}
      syncPolicy:
        automated: {}
        syncOptions:
          - CreateNamespace=true