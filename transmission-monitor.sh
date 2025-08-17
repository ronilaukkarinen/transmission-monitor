#!/bin/bash

# Check for required environment variables
if [[ -z "$TRANSMISSION_URL" || -z "$TRANSMISSION_USER" || -z "$TRANSMISSION_PASS" ]]; then
    echo "Error: Missing required environment variables."
    echo "Please set TRANSMISSION_URL, TRANSMISSION_USER, and TRANSMISSION_PASS"
    echo "Example:"
    echo "  export TRANSMISSION_URL='https://your-server.com:443/transmission/'"
    echo "  export TRANSMISSION_USER='your-username'"
    echo "  export TRANSMISSION_PASS='your-password'"
    exit 1
fi

watch --no-title --interval=.05 --color 'transmission-remote "$TRANSMISSION_URL" -n "$TRANSMISSION_USER:$TRANSMISSION_PASS" -l | \
grep -v "Stopped" | grep -v "Idle" | grep -v "Done" | \
awk "
BEGIN {
    # ANSI color codes
    RED=\"\\033[31m\"
    GREEN=\"\\033[92m\"
    YELLOW=\"\\033[33m\"
    BLUE=\"\\033[34m\"
    MAGENTA=\"\\033[35m\"
    CYAN=\"\\033[36m\"
    WHITE=\"\\033[37m\"
    GREY=\"\\033[37m\"
    BOLD=\"\\033[1m\"
    RESET=\"\\033[0m\"
}
NR==1 {printf \"%-21s  %-10s  %-8s  %-15s  %15s\\n\", BOLD GREY \"Progress\" RESET, BOLD GREY \"           Size\" RESET, BOLD GREY \"   ETA\" RESET, BOLD GREY \"   Name\" RESET, BOLD WHITE \"             Down\" RESET; next}
NF==0 {next}
/^Sum:/ {next}
{
    if (NF >= 9) {
        id = \$1
        percentage = \$2
        size = \$3 \" \" \$4
        eta = \$5 \" \" \$6
        up_speed = \$7
        down_speed = \$8
        ratio = \$9
        status = \$10

        # Extract filename (everything after status field)
        name = \"\"
        for (i=11; i<=NF; i++) {
            name = name \$i
            if (i < NF) name = name \" \"
        }
        
        # If name is still empty, try extracting from field 10 onwards
        if (name == \"\" && NF >= 9) {
            for (i=10; i<=NF; i++) {
                name = name \$i
                if (i < NF) name = name \" \"
            }
        }

        # Truncate name to 15 characters
        if (length(name) > 20) {
            name = substr(name, 1, 17) \"\"
        }

        # Create colorized progress bar with ASCII - fixed width percentage
        perc_num = int(percentage)
        bar_width = 15
        filled = int(perc_num * bar_width / 100)

        progress_bar = \"\"
        for (i=1; i<=bar_width; i++) {
            if (i <= filled) progress_bar = progress_bar WHITE \"▰\" RESET
            else progress_bar = progress_bar \"▱\"
        }
        progress_bar = progress_bar \" \" sprintf(\"%3s\", percentage)

        # Color speeds
        up_colored = (up_speed == \"0.0\") ? GREY up_speed RESET : GREY up_speed RESET
        down_colored = (down_speed == \"0.0\") ? GREEN down_speed \" KB/s\" RESET : GREEN down_speed \" kB/s\" RESET

        # Handle each possible size length individually with proper spacing
        size_len = length(size)
        
        if (size_len == 6) {
            # \"1.2 GB\" - 6 chars
            printf \"%-21s    %-10s   %-8s   %-15s   %15s\\n\", progress_bar, GREY size RESET, GREY eta RESET, GREY name RESET, down_colored
        } else if (size_len == 7) {
            # \"4.17 GB\" - 7 chars  
            printf \"%-21s   %-10s   %-8s   %-15s   %15s\\n\", progress_bar, GREY size RESET, GREY eta RESET, GREY name RESET, down_colored
        } else if (size_len == 8) {
            # \"105.5 MB\" - 8 chars
            printf \"%-21s  %-10s   %-8s   %-15s   %15s\\n\", progress_bar, GREY size RESET, GREY eta RESET, GREY name RESET, down_colored
        } else if (size_len == 9) {
            # \"1234.5 GB\" - 9 chars
            printf \"%-21s %-10s   %-8s   %-15s   %15s\\n\", progress_bar, GREY size RESET, GREY eta RESET, GREY name RESET, down_colored
        } else if (size_len == 10) {
            # \"12345.6 GB\" - 10 chars
            printf \"%-21s%-10s   %-8s   %-15s   %15s\\n\", progress_bar, GREY size RESET, GREY eta RESET, GREY name RESET, down_colored
        } else {
            # Default for other lengths
            printf \"%-21s  %-10s   %-8s   %-15s   %15s\\n\", progress_bar, GREY size RESET, GREY eta RESET, GREY name RESET, down_colored
        }
    }
}"'
