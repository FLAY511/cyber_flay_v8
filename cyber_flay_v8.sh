#!/bin/bash
# CYBER FLAY V8 - OSINT & Utilities (Termux-ready)
# White-hat only. For educational & authorized security testing.
# Dependencies: curl jq bc nmap whois openssl wget figlet coreutils util-linux toybox (builtin on Termux)

# ===== Colors =====
RED='\033[0;31m'; GRN='\033[0;32m'; YLW='\033[1;33m'; CYN='\033[0;36m'; WHT='\033[1;37m'; RST='\033[0m'

# ===== ASCII Hacker =====
HACKER='
       .-"      "-.
      /            \
     |,  .-.  .-.  ,|
     | )(_o/  \o_)( |
     |/     /\     \|
     (_     ^^     _)
      \__|IIIIII|__/
       | \IIIIII/ |
       \          /
        `--------`'

# ===== Safety Trap =====
trap 'echo -e "\n${RED}[!] Dihentikan oleh user${RST}"; exit 1' INT

# ===== Helpers =====
need() {
  for p in "$@"; do
    if ! command -v "$p" >/dev/null 2>&1; then
      echo -e "${YLW}[!] Menginstall dependency: $p${RST}"
      pkg install -y "$p" >/dev/null 2>&1 || apt install -y "$p" >/dev/null 2>&1
    fi
  done
}

pause() { read -p "Tekan ENTER untuk lanjut..."; }

banner() {
  clear
  echo -e "${GRN}${HACKER}${RST}"
  echo -e "${RED}==============================================${RST}"
  echo -e "${GRN}        TOOLS INI DIBUAT OLEH CYBER FLAY      ${RST}"
  echo -e "${RED}==============================================${RST}"
  echo -e "${YLW}        [*] HACKER WITH HAT OSINT TOOLS       ${RST}"
  echo -e "${RED}==============================================${RST}"
}

ua="Mozilla/5.0 (X11; Linux x86_64) CYBER-FLAY/8"

# ========= OSINT FUNCTIONS (15) =========
whois_lookup() {
  need whois
  read -p "Masukkan domain: " d
  whois "$d"
  pause
}
geoip_lookup() {
  need curl jq
  read -p "Masukkan IP/domain: " ip
  curl -s -A "$ua" "https://ipinfo.io/${ip}" | jq .
  pause
}
extract_links() {
  need curl
  read -p "Masukkan URL (https://...): " u
  curl -s -A "$ua" "$u" | grep -Eo '(http|https)://[^"'"'"'<> ]+' | sort -u
  pause
}
http_headers() {
  need curl
  read -p "Masukkan URL (https://...): " u
  curl -s -I -A "$ua" "$u"
  pause
}
ssl_info() {
  need openssl
  read -p "Masukkan domain: " d
  echo | openssl s_client -servername "$d" -connect "$d:443" 2>/dev/null | openssl x509 -noout -issuer -subject -dates -fingerprint -sha256
  pause
}
security_headers() {
  need curl
  read -p "Masukkan URL (https://...): " u
  curl -s -I -A "$ua" "$u" | grep -Ei 'strict-transport|x-frame|x-xss|content-security|referrer-policy|permissions-policy' || echo "Header keamanan tidak ditemukan"
  pause
}
threatfox_lookup() {
  need curl jq
  read -p "Masukkan IOC (IP/Domain/Hash): " ioc
  curl -s -A "$ua" "https://threatfox-api.abuse.ch/api/v1/" \
    -H "Content-Type: application/json" \
    -d "{\"query\":\"search_ioc\",\"search_term\":\"$ioc\"}" | jq .
  pause
}
dns_lookup() {
  need nslookup
  read -p "Masukkan domain: " d
  nslookup "$d"
  pause
}
reverse_dns() {
  need dig
  read -p "Masukkan IP: " ip
  dig -x "$ip" +short
  pause
}
subdomain_finder() {
  need curl jq
  read -p "Masukkan domain: " d
  curl -s -A "$ua" "https://crt.sh/?q=%25.$d&output=json" | jq -r '.[].name_value' | sed 's/\\*\\.//g' | sort -u
  pause
}
email_breach() {
  need curl jq
  read -p "Masukkan email: " e
  curl -s -A "$ua" "https://haveibeenpwned.com/unifiedsearch/$e" | jq .
  pause
}
port_scan() {
  need nmap
  read -p "Masukkan target (IP/host): " t
  nmap -F "$t"
  pause
}
asn_lookup() {
  need whois
  read -p "Masukkan IP: " ip
  whois "$ip" | grep -Ei 'origin|route|descr|AS'
  pause
}
crawl_website() {
  need wget grep
  read -p "Masukkan URL (https://...): " u
  wget -r --spider -e robots=off -nd -nH "$u" 2>&1 | grep '^--' | awk '{print $3}' | sed 's/(.*)//' | sort -u
  pause
}

username_check() {
  need curl
  read -p "Masukkan username: " user
  out="username_check_$(date +%Y%m%d_%H%M%S).txt"
  echo "Hasil cek username untuk: $user" > "$out"
  echo "================================" >> "$out"
  sites=(
    facebook.com instagram.com twitter.com github.com reddit.com tiktok.com linkedin.com youtube.com pinterest.com
    medium.com dev.to tumblr.com vimeo.com dailymotion.com soundcloud.com mixcloud.com last.fm
    stackoverflow.com quora.com about.me producthunt.com dribbble.com behance.net
    gitlab.com bitbucket.org sourceforge.net
    wordpress.com blogger.com weebly.com
    ok.ru vk.com flickr.com myspace.com
    500px.com patreon.com kickstarter.com indiegogo.com
    slack.com discord.com telegram.me
    snapchat.com mastodon.social
    goodreads.com wattpad.com
    tripadvisor.com couchsurfing.com airbnb.com
    etsy.com depop.com
    steamcommunity.com
    twitch.tv
    medium.com
    strava.com
    deviantart.com
    keybase.io
    tradingview.com
    hackaday.io
    gumroad.com
  )
  echo -e "${CYN}Cek username di ${#sites[@]} situs...${RST}"
  for site in "${sites[@]}"; do
    url="https://${site}/${user}"
    code=$(curl -A "$ua" -s -L -o /dev/null -w "%{http_code}" --max-time 7 "$url")
    if [[ "$code" == "200" || "$code" == "301" || "$code" == "302" ]]; then
      echo -e "Cek ${site} ... ${GRN}[+] Ada${RST}"
      echo "[+] ${site}" >> "$out"
    else
      echo -e "Cek ${site} ... ${RED}[-] Tidak ada${RST}"
      echo "[-] ${site}" >> "$out"
    fi
  done
  echo -e "${YLW}Hasil tersimpan: ${out}${RST}"
  pause
}

# ========= Deface Simulation =========
deface_sim() {
  read -p "Nama file (contoh: deface.html): " f
  read -p "Judul/Pesan: " m
  cat > "$f" <<EOF
<!doctype html>
<html lang="en"><meta charset="utf-8">
<title>DEFACE BY CYBER FLAY</title>
<style>body{{background:#000;color:#0f0;font-family:monospace;text-align:center;padding-top:10vh}}</style>
<h1>DEFACE BY CYBER FLAY</h1>
<h2>${{m}}</h2>
<pre>{hacker}</pre>
</html>
EOF
  sed -i "s/{hacker}/$HACKER/g" "$f"
  echo -e "${GRN}File dibuat: ${f}${RST} (lokal, simulasi legal)"
  pause
}

# ========= Utilities (Menu Lain) =========
cek_cuaca() { need curl; read -p "Kota: " k; curl -s -A "$ua" "https://wttr.in/${k}?format=3"; echo; pause; }
kalkulator() { need bc; read -p "Ekspresi (cth 5+7*2): " e; echo "$e" | bc; pause; }
gen_pass() { need openssl; read -p "Panjang password: " L; : "${L:=16}"; openssl rand -base64 48 | tr -dc 'A-Za-z0-9@#%^+=' | head -c "$L"; echo; pause; }
random_quote() { need curl jq; curl -s -A "$ua" https://api.quotable.io/random | jq -r '.content+" — "+.author'; pause; }
random_joke() { need curl jq; curl -s -H "Accept: application/json" -A "$ua" https://icanhazdadjoke.com/ | jq -r '.joke'; pause; }
translate_text() { need curl jq; read -p "Teks: " t; curl -s -A "$ua" -H "Content-Type: application/json" -d "{\"q\":\"$t\",\"source\":\"auto\",\"target\":\"en\"}" https://libretranslate.de/translate | jq -r '.translatedText'; pause; }
chat_ai() { need curl jq; read -p "Tanya: " q; curl -s -A "$ua" "https://api.duckduckgo.com/?q=${q}&format=json" | jq -r '.AbstractText // "Tidak ada jawaban ringkas"'; pause; }
nama_hacker() { need figlet; read -p "Nama: " n; figlet "$n"; pause; }
kalender() { cal; pause; }
stopwatch() { echo "Stopwatch: CTRL+C untuk stop"; start=$(date +%s); while :; do now=$(date +%s); diff=$((now-start)); echo -ne "Waktu: ${diff}s\r"; sleep 1; done; }

# ========= Menus =========
menu_osint() {
  while true; do
    banner
    echo -e "${CYN}--- OSINT MENU ---${RST}"
    echo "[01] WHOIS Lookup"
    echo "[02] GeoIP Lookup"
    echo "[03] Extract Links Website"
    echo "[04] HTTP Headers Check"
    echo "[05] SSL Certificate Info"
    echo "[06] Security Headers Scan"
    echo "[07] ThreatFox IOC Lookup"
    echo "[08] DNS Lookup"
    echo "[09] Reverse DNS Lookup"
    echo "[10] Subdomain Finder"
    echo "[11] Email Breach Check"
    echo "[12] IP Port Scan"
    echo "[13] ASN Lookup"
    echo "[14] Crawl Website"
    echo "[15] Username Check (50 sites)"
    echo "[00] Kembali"
    read -p "Pilih OSINT: " o
    case "$o" in
      1|01) whois_lookup ;;
      2|02) geoip_lookup ;;
      3|03) extract_links ;;
      4|04) http_headers ;;
      5|05) ssl_info ;;
      6|06) security_headers ;;
      7|07) threatfox_lookup ;;
      8|08) dns_lookup ;;
      9|09) reverse_dns ;;
      10) subdomain_finder ;;
      11) email_breach ;;
      12) port_scan ;;
      13) asn_lookup ;;
      14) crawl_website ;;
      15) username_check ;;
      0|00) break ;;
      *) echo "Pilihan tidak valid"; sleep 1 ;;
    esac
  done
}

menu_deface() { banner; echo -e "${CYN}--- DEFACE SIMULATION ---${RST}"; deface_sim; }

menu_utils() {
  while true; do
    banner
    echo -e "${CYN}--- MENU LAIN (UTILITIES) ---${RST}"
    echo "[01] Cek Cuaca"
    echo "[02] Kalkulator"
    echo "[03] Generator Password"
    echo "[04] Random Quote"
    echo "[05] Random Joke"
    echo "[06] Translate (auto -> EN)"
    echo "[07] Chat AI (Ringkas)"
    echo "[08] Nama Hacker Style"
    echo "[09] Kalender"
    echo "[10] Stopwatch/Timer"
    echo "[00] Kembali"
    read -p "Pilih Utilities: " u
    case "$u" in
      1|01) cek_cuaca ;;
      2|02) kalkulator ;;
      3|03) gen_pass ;;
      4|04) random_quote ;;
      5|05) random_joke ;;
      6|06) translate_text ;;
      7|07) chat_ai ;;
      8|08) nama_hacker ;;
      9|09) kalender ;;
      10) stopwatch ;;
      0|00) break ;;
      *) echo "Pilihan tidak valid"; sleep 1 ;;
    esac
  done
}

# ========= Main =========
main_menu() {
  while true; do
    banner
    echo -e "${CYN}[1] OSINT Tools"
    echo "[2] Deface Simulation"
    echo "[3] Menu Lain (Utilities)"
    echo "[0] Keluar${RST}"
    read -p "Pilih menu: " m
    case "$m" in
      1) menu_osint ;;
      2) menu_deface ;;
      3) menu_utils ;;
      0) echo "Keluar..."; exit 0 ;;
      *) echo "Pilihan tidak valid"; sleep 1 ;;
    esac
  done
}

# Ensure base tools
need curl jq figlet openssl whois nmap wget grep coreutils

# Run
main_menu
