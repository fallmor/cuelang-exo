package morcue

import (
	"encoding/yaml"
	"tool/cli"
)

command: dump_deploy: {
	task: print: cli.Print & {
    text: yaml.MarshalStream([for x in _Deploy {x}])
	}
}
command: dump_service: {
	task: print: cli.Print & {
    text: yaml.MarshalStream([for x in _Svc {x}])
	}
}
