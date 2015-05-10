#!/bin/bash
# Colors and decorations

function colorizer {

    # Text Reset
    local Reset_Color='\x1b[0m'

    # Regular
    local Black='\x1b[0;30m'
    local Red='\x1b[0;31m'
    local Green='\x1b[0;32m'
    local Yellow='\x1b[0;33m'
    local Blue='\x1b[0;34m'
    local Purple='\x1b[0;35m'
    local Cyan='\x1b[0;36m'
    local White='\x1b[0;37m'

    # Bold
    local Bold_Black='\x1b[1;30m'
    local Bold_Red='\x1b[1;31m'
    local Bold_Green='\x1b[1;32m'
    local Bold_Yellow='\x1b[1;33m'
    local Bold_Blue='\x1b[1;34m'
    local Bold_Purple='\x1b[1;35m'
    local Bold_Cyan='\x1b[1;36m'
    local Bold_White='\x1b[1;37m'

    # Underline
    local Underline_Black='\x1b[4;30m'
    local Underline_Red='\x1b[4;31m'
    local Underline_Green='\x1b[4;32m'
    local Underline_Yellow='\x1b[4;33m'
    local Underline_Blue='\x1b[4;34m'
    local Underline_Purple='\x1b[1;35m'
    local Underline_Cyan='\x1b[4;36m'
    local Underline_White='\x1b[4;37m'

    # Background
    local On_Black='\x1b[40m'
    local On_Blue='\x1b[44m'
    local On_White='\x1b[47m'

    # Color codes
    CError=$Red
    CStatus=$Bold_Purple
    CInfo=$Bold_Yellow
    CProcess=$Bold_Blue
    CData=$Bold_Cyan
    CMissing=$Bold_Red
    CReset=$Reset_Color
}
colorizer
unset colorizer
