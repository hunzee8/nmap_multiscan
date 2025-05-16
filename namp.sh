#!/bin/bash

show_help() {
    echo "Usage: $0 <target> [-q | -f]"
    echo "  -q            Quick scan mode (fast scans only)"
    echo "  -f            Full scan mode (includes all scans)"
    echo "  -h            Show this help message"
    exit 1
}

mode="full"

if [[ $# -lt 1 ]]; then
    echo "Error: Target not specified." >&2
    show_help
fi

target="$1"
shift

while getopts ":qfh" opt; do
  case ${opt} in
    q ) mode="quick" ;;
    f ) mode="full" ;;
    h ) show_help ;;
    \? ) echo "Invalid option: -$OPTARG" >&2; show_help ;;
    : ) echo "Option -$OPTARG requires an argument." >&2; show_help ;;
  esac
done


if ! command -v nmap &> /dev/null; then
    echo "Error: nmap is not installed." >&2
    exit 1
fi

trap 'echo -e "\n[!] Scan interrupted by user. Exiting."; exit 1' INT

timestamp=$(date +%F_%H-%M-%S)
safe_target=$(echo "$target" | tr -cd '[:alnum:]._-')
output_file="nmap_scan_results_${safe_target}_${timestamp}.txt"
reason="--reason"
start_time=$(date)

echo "Starting Ultimate Nmap Scan on $target at $start_time"
echo "Scan mode: $mode"
echo "Results will be saved to: $output_file"
echo "=========================================" | tee "$output_file"

echo "[!] WARNING: Some scans may be intrusive and trigger IDS/IPS."
echo "[*] You have 5 seconds to cancel (Ctrl+C) if needed..."
sleep 5

run_scan() {
    local description="$1"
    local command="$2"
    echo "=========================================" | tee -a "$output_file"
    echo "[+] $description..." | tee -a "$output_file"
    eval "$command" | tee -a "$output_file"
}

declare -a scans=(
    "Aggressive Scan:nmap -A $reason $target"
    "Top 1000 Ports Scan:nmap --top-ports 1000 $reason $target"
    "OS Detection:nmap -O $reason $target"
    "Service Version Detection:nmap -sV $reason $target"
    "Default NSE Script Scan:nmap -sC $reason $target"
)

if [ "$mode" = "full" ]; then
    scans+=(
        "Full Port Scan (All 65535 Ports):nmap -p- $reason $target"
        "UDP Scan:nmap -sU $reason $target"
        "Traceroute:nmap --traceroute $reason $target"
        "NSE Vulnerability Scan:nmap --script vuln $reason $target"
        "NSE Authentication Scan:nmap --script auth $reason $target"
        "SYN Scan (Stealth):nmap -sS -T3 $reason $target"
        "FIN Scan:nmap -sF $reason $target"
        "NULL Scan:nmap -sN $reason $target"
        "XMAS Scan:nmap -sX $reason $target"
        "TCP Connect Scan:nmap -sT $reason $target"
        "ACK Scan:nmap -sA $reason $target"
        "Window Scan:nmap -sW $reason $target"
        "Maimon Scan:nmap -sM $reason $target"
    )
fi

echo "[*] Running scans sequentially..."
for scan in "${scans[@]}"; do
    IFS=":" read -r desc cmd <<< "$scan"
    run_scan "$desc" "$cmd"
done

end_time=$(date)
echo "=========================================" | tee -a "$output_file"
echo "[+] All scans completed!"
echo "[+] Started: $start_time" | tee -a "$output_file"
echo "[+] Ended: $end_time" | tee -a "$output_file"
echo "[+] Results saved to: $output_file"
