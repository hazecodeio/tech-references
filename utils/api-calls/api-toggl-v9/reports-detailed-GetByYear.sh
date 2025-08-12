CWD=$(echo $(realpath "${0}") | xargs dirname)
source "${CWD}"/_env-loader.sh


function jsonPayload() {

  local timestamp="$(date "+%Y-%m-%dT%T"-06:00)"

  cat << EOF
  {
      "start_date": "2024-01-01",
      "end_date": "2025-01-01",
      "page_size": 1,

      "order_by": "date",
      "order_dir": "ASC",
      "grouped": false,

      "duration_format": "classic",
      "date_format": "MM/DD/YYYY",
      "time_format": "h:mm A",
      "display_mode": "date_and_time",
      "duration_format": "improved",
      "enrich_response": true,

      "withInlineRates": false,
      "with_graph": false,
      "hide_amounts": true,
      "hide_rates": true

  }
EOF
}


curl -X POST 'https://api.track.toggl.com/reports/api/v3/workspace/'"${WORKSPACE_ID}"'/search/time_entries' \
  -v -u "${TOGGL_TOKEN}" \
  -H "Content-Type: application/json" \
  -d "$(jsonPayload)" | jq
