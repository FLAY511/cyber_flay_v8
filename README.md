# CYBER FLAY V8
OSINT + Utilities for Termux — **white-hat only**. All features work offline/online with free endpoints.

## ✨ Features
### OSINT (15)
1. WHOIS Lookup
2. GeoIP Lookup (ipinfo.io)
3. Extract Links (curl/grep)
4. HTTP Headers (curl -I)
5. SSL Certificate Info (openssl)
6. Security Headers Scan
7. ThreatFox IOC Lookup (abuse.ch)
8. DNS Lookup (nslookup)
9. Reverse DNS (dig)
10. Subdomain Finder (crt.sh)
11. Email Breach Check (haveibeenpwned unified)
12. IP Port Scan (nmap)
13. ASN Lookup (whois)
14. Crawl Website (wget --spider)
15. Username Check (50 sites, auto-save to file)

### Deface Simulation
Creates local HTML file only (legal & safe).

### Utilities (10)
Weather, Calculator, Password Generator, Quote, Joke, Translate, Simple AI Answer, Hacker Name (figlet), Calendar, Stopwatch.

## 🧰 Dependencies (Termux)
```bash
pkg update && pkg upgrade -y
pkg install -y curl jq bc nmap whois openssl wget figlet dnsutils coreutils grep
# (dnsutils provides dig/nslookup in many setups; if not available use: pkg install dnsutils)
```

## 🚀 Run
```bash
chmod +x cyber_flay_v8.sh
./cyber_flay_v8.sh
```

## ✅ Username Check — 50 Sites
Facebook, Instagram, Twitter/X, GitHub, Reddit, TikTok, LinkedIn, YouTube, Pinterest, Medium, Dev.to, Tumblr, Vimeo, Dailymotion, SoundCloud, Mixcloud, Last.fm, StackOverflow, Quora, About.me, ProductHunt, Dribbble, Behance, GitLab, Bitbucket, SourceForge, WordPress, Blogger, Weebly, OK.ru, VK, Flickr, MySpace, 500px, Patreon, Kickstarter, Indiegogo, Slack, Discord, Telegram, Snapchat, Mastodon, Goodreads, Wattpad, TripAdvisor, Couchsurfing, Airbnb, Etsy, Depop, Steamcommunity, Twitch, Strava, DeviantArt, Keybase, TradingView, Hackaday, Gumroad (subset used to ensure 50).

## ⚠️ Legal
Use responsibly on targets you own or have permission to test. You are responsible for compliance with all applicable laws and site Terms of Service.

— Built with ❤️ by **CYBER FLAY**.
