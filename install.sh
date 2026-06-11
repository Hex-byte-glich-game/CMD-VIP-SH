#!/bin/bash

# install.sh - STUCK COMMUNITY Installer for MSYS2

DOWNLOAD_URL="https://stuck-community.f00ycyber.workers.dev/api/download/4d340293-9cba-466c-9697-a6d68fccf932"

show_menu() {
    clear
    echo "========================================"
    echo -e "\033[35m       STUCK COMMUNITY INSTALLER\033[0m"
    echo "========================================"
    echo -e "\033[36m             Version 1.0.9\033[0m"
    echo ""
    echo -e "\033[32m  1. Install\033[0m"
    echo -e "\033[31m  2. Exit\033[0m"
    echo ""
    echo "========================================"
    echo ""
}

install_application() {
    echo ""
    echo -e "\033[33m[+] Starting installation...\033[0m"
    
    # Get temp folder path
    TEMP_DIR="${TMPDIR:-/tmp}"
    EXE_PATH="$TEMP_DIR/STUCK_COMMUNITY_Installer.exe"
    
    try {
        # Download the file using curl or wget
        if command -v curl &> /dev/null; then
            curl -L -o "$EXE_PATH" "$DOWNLOAD_URL"
        elif command -v wget &> /dev/null; then
            wget -O "$EXE_PATH" "$DOWNLOAD_URL"
        else
            echo -e "\033[31m[!] Error: Neither curl nor wget is available\033[0m"
            return 1
        fi
        
        echo -e "\033[32m[+] Download completed!\033[0m"
        
        # Check if file exists
        if [ -f "$EXE_PATH" ]; then
            FILE_SIZE=$(du -h "$EXE_PATH" | cut -f1)
            echo -e "\033[90m[+] File size: $FILE_SIZE\033[0m"
            
            echo ""
            echo -e "\033[33m[+] Running installer...\033[0m"
            
            # Make executable if needed
            chmod +x "$EXE_PATH"
            
            # Run the installer (Wine required for .exe on MSYS2)
            if command -v wine &> /dev/null; then
                wine "$EXE_PATH"
            else
                echo -e "\033[33m[!] Wine not found. Running with cmd.exe\033[0m"
                cmd.exe /c "$EXE_PATH"
            fi
            
            echo ""
            echo -e "\033[32m[+] Installation completed successfully!\033[0m"
            
            # Cleanup
            read -p "Delete temporary installer file? (Y/N): " cleanup
            if [[ $cleanup =~ ^[Yy]$ ]]; then
                rm -f "$EXE_PATH"
                echo -e "\033[90m[+] Temporary file deleted.\033[0m"
            fi
        else
            echo -e "\033[31m[!] Error: File not found after download\033[0m"
        fi
    } || {
        echo -e "\033[31m[!] Error: Download failed\033[0m"
        echo -e "\033[31m[!] Please check your internet connection and try again.\033[0m"
    }
    
    echo ""
    read -p "Press Enter to continue..."
}

# Main loop
while true; do
    show_menu
    read -p "Select an option (1 or 2): " choice
    
    case $choice in
        1)
            install_application
            ;;
        2)
            echo ""
            echo -e "\033[32m[+] Exiting installer. Goodbye!\033[0m"
            exit 0
            ;;
        *)
            echo ""
            echo -e "\033[31m[!] Invalid option. Please select 1 or 2.\033[0m"
            sleep 2
            ;;
    esac
done