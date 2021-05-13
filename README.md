# Add New User Prisma Cloud Enterprise Edition API SCRIPT

## Assumptions

* You're using the ENTERPRISE EDITION OF PRISMA CLOUD
* You're using ubuntu 20.04
* You're able to reach your Prisma Cloud Enterprise Edition console from your ubuntu 20.04 machine
* You would know how to harden this process if working in a production environment.

## Instructions

* Step 1: `git clone https://github.com/Kyle9021/pcee_add_user_api_script`
* Step 2: `cd pcee_add_user_api_script/`
* Step 3: `nano add_user.bash` and assign variables according to comment documentation
* Step 4: Install jq if you dont have it `sudo apt update && upgrade -y` then `sudo apt-get install jq` 
* Step 5: `bash rql_api.bash`


# Links to reference

* [Official JQ Documentation](https://stedolan.github.io/jq/manual/)
* [Grep Documentation](https://www.gnu.org/software/grep/manual/grep.html)
* [Exporting variables for API Calls and why I choose bash](https://apiacademy.co/2019/10/devops-rest-api-execution-through-bash-shell-scripting/)
* [Why Bash](https://www.redhat.com/sysadmin/favorite-shell)# pcee_add_user_api_script

