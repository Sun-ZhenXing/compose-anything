package app.authz

import rego.v1

default allow := false

allow if {
	input.user in data.allowed_users
}
