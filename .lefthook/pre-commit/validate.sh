#!/usr/bin/env bash
# https://github.com/rajasoun/gitops-experiments/blob/main/devops/v1/kustomize/app.sh
set -eo pipefail
IFS=$'\n\t'



GIT_BASE_PATH=$(git rev-parse --show-toplevel)
# shellcheck disable=SC2034
SCRIPT_LIB_DIR="$GIT_BASE_PATH/hack/"
# shellcheck disable=SC1091
source "${SCRIPT_LIB_DIR}/main.sh" "$@"


kustomize_flags=("--load-restrictor=LoadRestrictionsNone")
kustomize_config="kustomization.yaml"
kubeconform_config=(-summary "-schema-location" "default" "-schema-location" "https://raw.githubusercontent.com/datreeio/CRDs-catalog/main/{{.Group}}/{{.ResourceKind}}_{{.ResourceAPIVersion}}.json" "-schema-location" "https://raw.githubusercontent.com/diskmanti/kubernetes-json-schema/main/{{.Group}}/{{.ResourceKind}}_{{.ResourceAPIVersion}}.json" "-verbose")
pretty_print "\t${YELLOW}INFO - Validating kustomize overlays\n${NC}"
find "$GIT_BASE_PATH" -type f -name $kustomize_config -print0 | while IFS= read -r -d $'\0' file;
  do
    pretty_print "\t${BLUE}INFO - Validating kustomization ${file/%$kustomize_config}\n${NC}"
    kustomize build "${file/%$kustomize_config}" "${kustomize_flags[@]}" | kubeconform "${kubeconform_config[@]}"
    if [[ ${PIPESTATUS[0]} != 0 ]]; then
      exit 1
    fi
done
