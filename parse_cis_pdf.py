# ================================
# CIS PDF Parser
# ================================

import pdfplumber
import json
import sys
import os
from datetime import date

def extract_cis_settings(pdf_path):
    settings = []
    keywords = ["Set ", "Ensure ", "Disable ", "Enable ", "Configure ", "Turn "]

    with pdfplumber.open(pdf_path) as pdf:
        for i, page in enumerate(pdf.pages):
            text = page.extract_text()
            if not text:
                continue
            for line in text.split('\n'):
                line = line.strip()
                if any(line.startswith(kw) for kw in keywords) and len(line) > 15:
                    settings.append({
                        "settingId": f"CIS-{i+1}-{len(settings)+1}",
                        "category":   detect_category(line),
                        "description": line,
                        "recommendedValue": "As per CIS Benchmark",
                        "currentValue": "Unknown",
                        "status": "UNKNOWN"
                    })
    return settings

def detect_category(line):
    line_lower = line.lower()
    if any(w in line_lower for w in ["password", "lockout"]):
        return "Password Policy"
    elif any(w in line_lower for w in ["firewall", "network"]):
        return "Firewall"
    elif any(w in line_lower for w in ["usb", "removable", "storage"]):
        return "USB Storage"
    elif any(w in line_lower for w in ["guest", "account", "user"]):
        return "Account Management"
    elif any(w in line_lower for w in ["audit", "log", "event"]):
        return "Audit Policy"
    elif any(w in line_lower for w in ["encrypt", "bitlocker"]):
        return "Encryption"
    else:
        return "General"

def save_as_profile(settings, profile_name, output_dir="Profiles"):
    os.makedirs(output_dir, exist_ok=True)
    profile = {
        "ProfileName": profile_name,
        "Version": "1.0",
        "CreatedDate": str(date.today()),
        "Source": "CIS PDF Import",
        "Settings": settings
    }
    output_path = os.path.join(output_dir, f"{profile_name}.json")
    with open(output_path, 'w') as f:
        json.dump(profile, f, indent=2)
    print(f"Profile saved: {output_path}")
    return output_path

if __name__ == "__main__":
    if len(sys.argv) < 3:
        print("Usage: python parse_cis_pdf.py <pdf_path> <profile_name>")
        print("Example: python parse_cis_pdf.py CIS_Windows11.pdf Win11-CIS-L1")
        sys.exit(1)

    pdf_path     = sys.argv[1]
    profile_name = sys.argv[2]

    print(f"Parsing: {pdf_path}")
    settings = extract_cis_settings(pdf_path)
    print(f"Found {len(settings)} settings")

    path = save_as_profile(settings, profile_name)
    print(f"Done! Profile saved at: {path}")