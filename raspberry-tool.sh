#!/bin/bash

# ============================================================
# RASPBERRY NETWORK TOOL - VERSIONE 3
# ============================================================

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m'

PORTE="22,23,53,80,81,135,139,443,445,500,515,631,1433,3306,3389,5000,5900,8000,8080,8443,8800,9002"

DATA=$(date +"%Y%m%d_%H%M%S")

# ============================================================
# FUNZIONI GENERALI
# ============================================================

pausa() {
    echo
    read -rp "Premi INVIO per continuare..."
}

titolo() {
    clear
    echo -e "${CYAN}"
    echo "============================================================"
    echo "                 RASPBERRY NETWORK TOOL"
    echo "============================================================"
    echo -e "${NC}"
}

controlla_nmap() {

    if ! command -v nmap >/dev/null 2>&1; then

        echo -e "${RED}Nmap non è installato.${NC}"
        echo
        echo "Installare con:"
        echo
        echo "sudo apt install nmap"
        echo

        pausa
        return 1
    fi

    return 0
}

rete_locale() {

    ip route | awk '/proto kernel/ && /src/ {print $1; exit}'
}

# ============================================================
# 1 - INFORMAZIONI RASPBERRY
# ============================================================

info_raspberry() {

    titolo

    echo -e "${YELLOW}MODELLO${NC}"
    echo "------------------------------------------------------------"

    if [ -f /proc/device-tree/model ]; then
        tr -d '\0' < /proc/device-tree/model
        echo
    fi

    echo
    echo -e "${YELLOW}SISTEMA OPERATIVO${NC}"
    echo "------------------------------------------------------------"

    grep -E '^(PRETTY_NAME|VERSION)=' /etc/os-release

    echo
    echo -e "${YELLOW}KERNEL${NC}"
    echo "------------------------------------------------------------"

    uname -a

    echo
    echo -e "${YELLOW}ARCHITETTURA${NC}"
    echo "------------------------------------------------------------"

    uname -m

    echo
    echo -e "${YELLOW}CPU${NC}"
    echo "------------------------------------------------------------"

    lscpu | grep -E 'Model name|Architecture|CPU\(s\)|Core|Thread'

    pausa
}

# ============================================================
# 2 - MEMORIA E DISCO
# ============================================================

info_memoria() {

    titolo

    echo -e "${YELLOW}MEMORIA RAM${NC}"
    echo "------------------------------------------------------------"

    free -h

    echo
    echo -e "${YELLOW}SPAZIO DISCO${NC}"
    echo "------------------------------------------------------------"

    df -h

    echo
    echo -e "${YELLOW}SWAP${NC}"
    echo "------------------------------------------------------------"

    swapon --show

    pausa
}

# ============================================================
# 3 - PROGRAMMI
# ============================================================

programmi() {

    titolo

    echo -e "${YELLOW}PROGRAMMI INSTALLATI${NC}"
    echo "------------------------------------------------------------"

    dpkg-query -W \
        -f='${binary:Package}\t${Version}\n' \
        2>/dev/null | sort

    pausa
}

# ============================================================
# 4 - SERVIZI
# ============================================================

servizi() {

    titolo

    echo -e "${YELLOW}SERVIZI ATTIVI${NC}"
    echo "------------------------------------------------------------"

    systemctl list-units \
        --type=service \
        --state=running \
        --no-pager

    pausa
}

# ============================================================
# 5 - INFORMAZIONI RETE
# ============================================================

info_rete() {

    titolo

    echo -e "${YELLOW}INTERFACCE${NC}"
    echo "------------------------------------------------------------"

    ip -br addr

    echo
    echo -e "${YELLOW}ROUTING${NC}"
    echo "------------------------------------------------------------"

    ip route

    echo
    echo -e "${YELLOW}GATEWAY${NC}"
    echo "------------------------------------------------------------"

    ip route | grep default

    echo
    echo -e "${YELLOW}DNS${NC}"
    echo "------------------------------------------------------------"

    if command -v resolvectl >/dev/null 2>&1; then
        resolvectl status | grep -E 'DNS Servers|Current DNS'
    else
        cat /etc/resolv.conf
    fi

    pausa
}

# ============================================================
# RETE - 1 HOST ATTIVI
# ============================================================

rete_host() {

    titolo

    controlla_nmap || return

    RETE=$(rete_locale)

    echo -e "${GREEN}Rete: $RETE${NC}"
    echo
    echo "Ricerca dispositivi attivi..."
    echo

    sudo nmap -sn "$RETE"

    pausa
}

# ============================================================
# RETE - 2 IP MAC PRODUTTORE
# ============================================================

rete_mac() {

    titolo

    controlla_nmap || return

    RETE=$(rete_locale)

    echo -e "${GREEN}Rete: $RETE${NC}"
    echo

    sudo nmap -sn "$RETE"

    pausa
}

# ============================================================
# RETE - 3 PORTE COMUNI
# ============================================================

rete_porte() {

    titolo

    controlla_nmap || return

    RETE=$(rete_locale)

    echo -e "${GREEN}Rete: $RETE${NC}"
    echo
    echo "Porte:"
    echo "$PORTE"
    echo
    echo "Scansione in corso..."
    echo

    sudo nmap \
        -sT \
        --open \
        -p "$PORTE" \
        "$RETE"

    pausa
}

# ============================================================
# RETE - 4 SERVIZI + VERSIONI
# ============================================================

rete_servizi() {

    titolo

    controlla_nmap || return

    RETE=$(rete_locale)

    echo -e "${GREEN}Rete: $RETE${NC}"
    echo
    echo "Scansione servizi..."
    echo

    sudo nmap \
        -sT \
        -sV \
        --open \
        -p "$PORTE" \
        "$RETE"

    pausa
}

# ============================================================
# RETE - 5 SINGOLO IP
# ============================================================

singolo_ip() {

    titolo

    controlla_nmap || return

    read -rp "Inserisci IP da analizzare: " IP

    if [[ ! "$IP" =~ ^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
        echo
        echo -e "${RED}Indirizzo IP non valido.${NC}"
        pausa
        return
    fi

    echo
    echo "Scansione di $IP..."
    echo

    sudo nmap \
        -sT \
        -sV \
        --open \
        -p "$PORTE" \
        "$IP"

    pausa
}

# ============================================================
# RETE - 6 INTERVALLO IP
# ============================================================

intervallo_ip() {

    titolo

    controlla_nmap || return

    read -rp "Inserisci intervallo (es. 192.168.1.1-50): " RANGE

    echo
    echo "Scansione di $RANGE..."
    echo

    sudo nmap \
        -sT \
        -sV \
        --open \
        -p "$PORTE" \
        "$RANGE"

    pausa
}

# ============================================================
# RETE - 7 REPORT
# ============================================================

ultimi_report() {

    titolo

    echo -e "${YELLOW}REPORT PRESENTI${NC}"
    echo "------------------------------------------------------------"

    ls -lh \
        report_*.txt \
        scansione_*.txt \
        2>/dev/null

    pausa
}

# ============================================================
# MENU RETE
# ============================================================

menu_rete() {

    while true
    do

        titolo

        echo "                  SCANSIONE RETE"
        echo
        echo "  1) Dispositivi attivi"
        echo "  2) IP + MAC + produttore"
        echo "  3) Scansione porte comuni"
        echo "  4) Servizi + versioni"
        echo "  5) Scansione singolo IP"
        echo "  6) Scansione intervallo IP"
        echo "  7) Visualizza report"
        echo
        echo "  0) Indietro"
        echo
        echo "------------------------------------------------------------"

        read -rp "Scelta: " SCELTA

        case "$SCELTA" in

            1)
                rete_host
                ;;

            2)
                rete_mac
                ;;

            3)
                rete_porte
                ;;

            4)
                rete_servizi
                ;;

            5)
                singolo_ip
                ;;

            6)
                intervallo_ip
                ;;

            7)
                ultimi_report
                ;;

            0)
                return
                ;;

            *)
                echo -e "${RED}Scelta non valida.${NC}"
                sleep 2
                ;;

        esac

    done
}

# ============================================================
# 7 - REPORT COMPLETO RASPBERRY
# ============================================================

report_completo() {

    titolo

    REPORT="report_raspberry_${DATA}.txt"

    echo "Generazione report..."
    echo

    {

        echo "============================================================"
        echo "              REPORT RASPBERRY"
        echo "============================================================"
        echo
        date

        echo
        echo "---------------- SISTEMA ----------------"

        cat /etc/os-release
        uname -a

        echo
        echo "---------------- MODELLO ----------------"

        tr -d '\0' < /proc/device-tree/model
        echo

        echo
        echo "---------------- CPU ----------------"

        lscpu

        echo
        echo "---------------- RAM ----------------"

        free -h

        echo
        echo "---------------- DISCO ----------------"

        df -h

        echo
        echo "---------------- SERVIZI ----------------"

        systemctl list-units \
            --type=service \
            --state=running \
            --no-pager

        echo
        echo "---------------- RETE ----------------"

        ip -br addr
        ip route

        echo
        echo "---------------- PROGRAMMI ----------------"

        dpkg-query -W \
            -f='${binary:Package}\t${Version}\n' \
            2>/dev/null | sort

    } > "$REPORT"

    echo -e "${GREEN}Report creato:${NC}"
    echo
    echo "$REPORT"

    pausa
}

# ============================================================
# MENU PRINCIPALE
# ============================================================

while true
do

    titolo

    echo "  1) Informazioni Raspberry"
    echo "  2) Memoria e disco"
    echo "  3) Programmi installati"
    echo "  4) Servizi attivi"
    echo "  5) Informazioni rete"
    echo "  6) Strumenti scansione rete"
    echo "  7) Genera report completo"
    echo
    echo "  0) Esci"
    echo
    echo "------------------------------------------------------------"

    read -rp "Scelta: " SCELTA

    case "$SCELTA" in

        1)
            info_raspberry
            ;;

        2)
            info_memoria
            ;;

        3)
            programmi
            ;;

        4)
            servizi
            ;;

        5)
            info_rete
            ;;

        6)
            menu_rete
            ;;

        7)
            report_completo
            ;;

        0)
            clear
            echo "Uscita."
            exit 0
            ;;

        *)
            echo -e "${RED}Scelta non valida.${NC}"
            sleep 2
            ;;

    esac

done
