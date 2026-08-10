# ---------------------------------------------------------------------------
# Ceph S3 context helper
#
# Ceph clusters speak the S3 API through RGW, but each cluster/bucket-set
# tends to live at its own --endpoint-url and use its own profile in
# ~/.aws/credentials (which the AWS CLI otherwise assumes is real AWS).
#
# This lets you register a short name for each Ceph target and flip between
# them with one command, then just use `aws s3 ...` / `s3 ...` normally.
#
# Add one entry below per Ceph target you use:
#   name  "profile endpoint-url"
#
# `profile` must match a section in ~/.aws/credentials or ~/.aws/config.
# `endpoint-url` is the Ceph RGW endpoint, e.g. https://ceph.example.org:8080
# ---------------------------------------------------------------------------

typeset -gA CEPH_S3_CONTEXTS
CEPH_S3_CONTEXTS=(
  isgs_wetlands   "isgs_wetlands https://taiga-dtn-s3.ncsa.illinois.edu:51016"
  odsc            "odsc https://taiga-dtn-s3.ncsa.illinois.edu:51016"
  remat           "remat https://taiga-dtn-s3.ncsa.illinois.edu:51016"
)

# Activate a Ceph S3 context by name: sets AWS_PROFILE + AWS_ENDPOINT_URL
# (the latter is honored by aws-cli >= 2.13 for every service call, which is
# exactly what we want since Ceph RGW only speaks S3/S3-compatible APIs).
s3ctx() {
  if [[ -z "$1" ]]; then
    echo "Usage: s3ctx <name>"
    echo
    s3ctxs
    return 1
  fi

  local entry="${CEPH_S3_CONTEXTS[$1]}"
  if [[ -z "$entry" ]]; then
    echo "s3ctx: unknown context '$1'" >&2
    echo "Known contexts: ${(k)CEPH_S3_CONTEXTS}" >&2
    return 1
  fi

  # Drop any stray static-credential env vars (e.g. left over from the MDF
  # awsenv/token helpers) so they can't shadow the profile we're selecting.
  unset AWS_ACCESS_KEY_ID AWS_SECRET_ACCESS_KEY AWS_SESSION_TOKEN AWS_SECURITY_TOKEN

  local profile="${entry%% *}"
  local endpoint="${entry#* }"

  export AWS_PROFILE="$profile"
  export AWS_ENDPOINT_URL="$endpoint"
  export CEPH_S3_CONTEXT="$1"

  echo "s3ctx: $1 -> profile=$profile endpoint=$endpoint"
}

# List all registered contexts, marking the active one with `*`.
s3ctxs() {
  local name
  for name in "${(@k)CEPH_S3_CONTEXTS}"; do
    if [[ "$name" == "$CEPH_S3_CONTEXT" ]]; then
      echo "* $name  (${CEPH_S3_CONTEXTS[$name]})"
    else
      echo "  $name  (${CEPH_S3_CONTEXTS[$name]})"
    fi
  done
}

# Clear the active Ceph S3 context, falling back to normal AWS config/creds.
s3ctx-clear() {
  unset AWS_PROFILE AWS_ENDPOINT_URL CEPH_S3_CONTEXT
  echo "s3ctx: cleared"
}

# Show the active context (handy to drop in your prompt too).
s3whoami() {
  if [[ -z "$CEPH_S3_CONTEXT" ]]; then
    echo "s3whoami: no ceph s3 context set"
  else
    echo "$CEPH_S3_CONTEXT -> profile=$AWS_PROFILE endpoint=$AWS_ENDPOINT_URL"
  fi
}

# Tab-complete context names for `s3ctx`.
_s3ctx_complete() {
  reply=("${(k)CEPH_S3_CONTEXTS[@]}")
}
compctl -K _s3ctx_complete s3ctx

alias s3='aws s3'
alias s3api='aws s3api'
