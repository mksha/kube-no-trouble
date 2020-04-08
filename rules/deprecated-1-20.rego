package deprecated120

main[return] {
  resource := input[_]
  old_api := deprecated_resource(resource)
  return := {"Name": resource.metadata.name, 
             "Namespace": resource.metadata.namespace,
	     "Kind": resource.kind,
	     "ApiVersion": old_api,
	     "RuleSet": "1.20 Deprecated APIs"}
}

deprecated_resource(r) = old_api {
  last_applied := json.unmarshal(r.metadata.annotations["kubectl.kubernetes.io/last-applied-configuration"])
  old_api := deprecated_api(r.kind, last_applied.apiVersion)
}

deprecated_resource(r) = old_api {
  old_api := deprecated_api(r.kind, r.apiVersion)
}

deprecated_api(kind, api_version) = old_api {
  deprecated_apis = { # -> networking.k8s.io/v1beta1
                      "Ingress":        ["extensions/v1beta1"],
                    }
  deprecated_apis[kind][_] == api_version
  old_api := api_version
}
