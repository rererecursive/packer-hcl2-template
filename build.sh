#!/bin/bash
set -e

# cat <<EOF > variables.json
# {
#     "application": "web",
#     "build_date": "$(date +%Y-%m-%d"T"%H-%M-%S)",
#     "git_branch": "$(git rev-parse --abbrev-ref HEAD)",
#     "git_commit": "$(git rev-parse --short HEAD)"
# }
# EOF

export APPLICATION="web"
export BUILD_DATE=$(date +%Y-%m-%d"T"%H-%M-%S)
export GIT_BRANCH=$(git rev-parse --abbrev-ref HEAD)
export GIT_COMMIT=$(git rev-parse --short HEAD)
export TEMPLATE_IN="template.pkr.hcl"
export TEMPLATE_OUT="template_out.pkr.hcl"

envsubst < $TEMPLATE_IN > $TEMPLATE_OUT
packer build -color=false $TEMPLATE_OUT | tee output.log
