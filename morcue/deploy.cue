package morcue

#Schema: #Deployment | #Service
#Ports: [{
	name:          *"externalPort" | string
	containerPort: *31000 | int
},
	{
		name:          *"internalPort" | string
		containerPort: *8080 | int
	},
]
#Pod_spec: containers: [{
	name:  string | *"deploy-mor"
	image: string | *"nginx"
	ports: #Ports
},
	{
		name:  string | *"deploy-mor2"
		image: string | *"rancher"
		ports: #Ports
	},
	{
		name:  string | *"deploy-mor3"
		image: string | *"eventrouter"
		ports: #Ports & [{
			name:          "mor"
			containerPort: 32000
		}, ...]
	}]
#labels: [string]: string
#required_labels: #labels & {
	"env":     "prod"
	"created": "cuelang"
}
#Metadata: {
	name:      *"generated-pod" | string
	namespace: *"myns" | string
	labels:    #required_labels
}
_apps: ["deployment1", "deployment2", "deployment3", "deployment4", "deployment5", "deployment6", "deployment7"]

#Deployment: {
	apiVersion: "apps/v1"
	kind:      "deployment"
	metadata:   #Metadata
	spec: {
		selector: {
			matchLabels: metadata.labels
		}
		minReadySeconds: uint
		template: {
			metadata: {
				labels: selector.matchLabels
			}
			spec: #Pod_spec
		}
	}
}

#Service: {
	apiVersion: "v1"
	kind:       "Service"
	metadata: {
		name:       string
		namespace?: string
		labels: [string]:       string
		annotations?: [string]: string
	}
	spec: {
		selector: [string]: string
		type: string
		ports: [...{...}]
	}
}
_Deploy: {
	for i, app in _apps {
		"\(app)": {
			#Deployment & {
				metadata: {
					name:       "\(app)"
					namespace?: "\(app)"
					labels: "app": "dev"
				}
				spec: minReadySeconds: 10
			}
		}
	}
}

_Svc: {
	for i, app in _apps {
		"svc-\(app)": {
			#Service & {
				metadata: #Metadata & {
					name: "\(app)"
				}
				spec: {
					selector: metadata.labels
					type:     "ClusterIP"
					ports: [{
						name: "\(app)"
						port: 8080
					}]
				}
			}
		}
	}
}



