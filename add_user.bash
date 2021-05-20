#!/bin/bash
# Written By Kyle Butler Prisma SE
# Tested on 5.13.2021 on prisma_cloud_enterprise_edition using Ubuntu 20.04
# Requires jq to be installed

# Access key should be created in the Prisma Cloud Console under: Settings > Accesskeys
# I'm making a conc
# Place the access key and secret key between "<ACCESS_KEY>" marks, below. 

pcee_accesskey="<ACCESS_KEY>"
pcee_secretkey="<SECRET_KEY>"

# This is found  in the Prisma Cloud Console under: Compute > Manage/System on the downloads tab under Path to Console
pcee_console_url="<PUT_CORRECT_VALUE_HERE_WITH_HTTPS://>"

# Found on https://prisma.pan.dev/api/cloud/api-urls, replace value below if it doesn't fit your environment. 
pcee_console_api_url="api.prismacloud.io"

# Username information. The goal here is to pull this information and assign to a these variables using a different api call. 
pcee_new_user_first_name="<FIRSTNAME>"
pcee_new_user_last_name="<LASTNAME>"
pcee_user_role_name="<PUT_THE_NAME_OF_THE_USER_ROLE_HERE>"
pcee_new_user_email="<EMAIL_HERE>"
pcee_new_user_time_zone="America/New_York"

# Nothing needs to be altered below this line

# This variable formats everything correctly so that the next variable can be assigned.
pcee_auth_body="{\"username\":\"${pcee_accesskey}\", \"password\":\"${pcee_secretkey}\"}"

# This saves the auth token needed to access the CSPM side of the Prisma Cloud API to a variable I named $pcee_auth_token
pcee_auth_token=$(curl --request POST \
--url "https://${pcee_console_api_url}/login" \
--header 'Accept: application/json; charset=UTF-8' \
--header 'Content-Type: application/json; charset=UTF-8' \
--data "${pcee_auth_body}" | jq -r '.token')

# This variable formats everything correctly so that the next variable can be assigned.
pcee_compute_auth_body="{\"username\":\"${pcee_accesskey}\", \"password\":\"${pcee_secretkey}\"}"

# This saves the auth token needed to access the CWPP side of the Prisma Cloud API to a variable $pcee_compute_token
pcee_compute_token=$(curl \
-H "Content-Type: application/json" \
-d "${pcee_compute_auth_body}" \
"${pcee_console_url}/api/v1/authenticate" | jq -r '.token')

# This retrieves all the user roles. 
pcee_retrieve_user_roles=$(curl --request GET --url "https://${pcee_console_api_url}/user/role" \
--header "x-redlock-auth: ${pcee_auth_token}")

# This part finds the the user role as definied in the variable above and pulls the user role ID
pcee_user_role_id_api_for_payload=$(printf %s "${pcee_retrieve_user_roles}" | jq '.[] | {id: .id, name: .name}' | jq -r '.name, .id'| awk "/""${pcee_user_role_name}""/{getline;print}")

# This formats the JSON payload for bash for the next curl command
payload="{\"defaultRoleId\": \"${pcee_user_role_id_api_for_payload}\", \"email\": \"${pcee_new_user_email}\", \"firstName\": \"${pcee_new_user_first_name}\", \"lastName\": \"${pcee_new_user_last_name}\", \"roleIds\": [\"$(printf %s "${pcee_user_role_id_api_for_payload}")\"], \"roleLimit\": "5", \"timeZone\": \"${pcee_new_user_time_zone}\"}"

# This adds the new user
curl --request POST --url "https://${pcee_console_api_url}/v2/user" \
--header "Content-Type: application/json" \
--header "x-redlock-auth: ${pcee_auth_token}" \
--data-raw "${payload}"
