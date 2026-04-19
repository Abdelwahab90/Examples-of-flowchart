#!/bin/bash

# =================================================================
# Project: Active Directory Attack & Detection Lab
# Script: Automated Attacker Machine Setup (Final Stable Version)
# Created by: Abdelwahab Ahmed Shandy
# =================================================================

# Colors for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${BLUE}[*] Starting Final Attacker Machine Preparation...${NC}"

# 0. Fix DNS issues (Ensuring Github and PyPI are reachable)
echo -e "${GREEN}[0] Configuring DNS to Google (8.8.8.8) for stability...${NC}"
echo "nameserver 8.8.8.8" | sudo tee /etc/resolv.conf > /dev/null

# 1. Update & Upgrade System
echo -e "${GREEN}[1] Updating system repositories...${NC}"
sudo apt update -y

# 2. Install Essential Tools & Dependencies
echo -e "${GREEN}[2] Installing core dependencies and Pipx...${NC}"
sudo apt install -y python3-pip python3-venv git ruby-full nmap smbclient \
curl wget netcat-openbsd build-essential libssl-dev libffi-dev python3-dev pipx

# 3. Add local bin to PATH (Critical for nxc and evil-winrm)
echo -e "${GREEN}[3] Configuring Environment Paths...${NC}"
pipx ensurepath
export PATH=$PATH:$HOME/.local/bin
if ! grep -q ".local/bin" ~/.bashrc; then
    echo 'export PATH=$PATH:$HOME/.local/bin' >> ~/.bashrc
fi

# 4. Install Impacket (The Core of AD Attacks)
echo -e "${GREEN}[4] Installing Impacket Toolkit...${NC}"
pip3 install impacket --break-system-packages --default-timeout=2000 --retries 10 --no-cache-dir

# 5. Install NetExec (using the correct official Repository)
echo -e "${GREEN}[5] Installing NetExec (nxc) from official Source...${NC}"

pip3 install git+https://github.com/Pennyw0rth/NetExec.git --break-system-packages --default-timeout=2000 --retries 10

# 6. Install Evil-WinRM (Shell access over WinRM)
echo -e "${GREEN}[6] Installing Evil-WinRM (Ruby Gem)...${NC}"
sudo gem install evil-winrm || sudo gem install evil-winrm --source http://rubygems.org

# 7. Install BloodHound Python (AD Enumeration)
echo -e "${GREEN}[7] Installing BloodHound.py...${NC}"
pip3 install bloodhound --break-system-packages --default-timeout=2000 --retries 10 --no-cache-dir

# 8. Install Password Cracking Tools
echo -e "${GREEN}[8] Installing John the Ripper & Hashcat...${NC}"
sudo apt install -y john hashcat

# 9. Final Validation
echo -e "\n${BLUE}[*] Validating Installations:${NC}"

# Function to check and display status
check_status() {
    if command -v $1 &> /dev/null || python3 -c "import $2" &> /dev/null 2>&1; then
        echo -e "$3: ${GREEN}[INSTALLED]${NC}"
    else
        echo -e "$3: ${RED}[FAILED]${NC}"
    fi
}

check_status "nmap" "nmap" "Nmap"
check_status "impacket-psexec" "impacket" "Impacket"
check_status "nxc" "nxc" "NetExec (nxc)"
check_status "evil-winrm" "evil_winrm" "Evil-WinRM"
check_status "bloodhound-python" "bloodhound" "BloodHound.py"

echo -e "\n${BLUE}[+] Setup Attempt Finished!${NC}"
echo -e "${YELLOW}[!] If all green, you are ready for Phase 2: Attack Scenarios.${NC}"
