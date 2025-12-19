CWD=$(echo $(realpath "${0}") | xargs dirname)
source "${CWD}"/_env-loader.sh

#List(
# (2025-12-19,2024-12-18),
# (2024-12-17,2023-12-18),
# (2023-12-17,2022-12-17),
# (2022-12-16,2021-12-16),
# (2021-12-15,2020-12-15))


function jsonPayload() {

  local DATA_START="2020-12-15"
  local DATE_END="2021-12-15"

  cat << EOF
  {
      "start_date": "${DATA_START}",
      "end_date": "${DATE_END}",
      "page_size": 100000,

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
