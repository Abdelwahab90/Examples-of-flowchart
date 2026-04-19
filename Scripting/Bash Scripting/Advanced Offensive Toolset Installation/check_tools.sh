#!/bin/bash

# =================================================================
# Project: Active Directory Attack & Detection Lab
# Script: Tool Readiness & Health Check
# Created by: Abdelwahab Ahmed Shandy
# =================================================================

# Colors for output
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

REPORT_FILE="tools_validation_report.txt"

echo -e "${BLUE}[*] Starting Tool Readiness Check...${NC}"
echo "AD Attack Lab - Tool Validation Report" > $REPORT_FILE
echo "Generated on: $(date)" >> $REPORT_FILE
echo "---------------------------------------" >> $REPORT_FILE

check_tool() {
    echo -n "Checking $1... "
    if command -v $1 &> /dev/null; then
        echo -e "${GREEN}[INSTALLED]${NC}"
        echo "$1: FOUND ($(which $1))" >> $REPORT_FILE
    else
        echo -e "${RED}[NOT FOUND]${NC}"
        echo "$1: MISSING" >> $REPORT_FILE
    fi
}

check_python_lib() {
    echo -n "Checking Python Lib $1... "
    python3 -c "import $1" &> /dev/null
    if [ $? -eq 0 ]; then
        echo -e "${GREEN}[INSTALLED]${NC}"
        echo "Python Lib $1: INSTALLED" >> $REPORT_FILE
    else
        echo -e "${RED}[NOT FOUND]${NC}"
        echo "Python Lib $1: MISSING" >> $REPORT_FILE
    fi
}

echo -e "\n${YELLOW}--- System Tools ---${NC}"
check_tool "nmap"
check_tool "smbclient"
check_tool "curl"
check_tool "nc"
check_tool "john"
check_tool "hashcat"

echo -e "\n${YELLOW}--- Offensive Frameworks ---${NC}"
check_tool "nxc"         # NetExec
check_tool "evil-winrm" # Evil-WinRM

echo -e "\n${YELLOW}--- Python Libraries ---${NC}"
check_python_lib "impacket"
check_python_lib "bloodhound"

echo -e "\n---------------------------------------" >> $REPORT_FILE
echo -e "${BLUE}[*] Validation Complete!${NC}"
echo -e "${BLUE}[*] A detailed report has been saved to: ${YELLOW}$REPORT_FILE${NC}"

echo -e "\n${BLUE}--- Final Summary ---${NC}"
cat $REPORT_FILE
