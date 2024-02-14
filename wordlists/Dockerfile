FROM alpine/git

ARG ADD_WORDLIST_N_RULES=false

WORKDIR /opt/wordlists
RUN set -x && [[ "$ADD_WORDLIST_N_RULES" == "true" ]] && git clone https://github.com/danielmiessler/SecLists.git --depth 1 &&\
    find . -type f -iname '*.tar.gz' -exec tar -xf {} \; -exec rm {} \; &&\
    find . ! -name 'Passwords' -type d -exec rm -rf {} \;;exit 0

WORKDIR /opt/rules
RUN [[ "$ADD_WORDLIST_N_RULES" == "true" ]] && git clone https://github.com/NotSoSecure/password_cracking_rules.git --depth=1 &&\
    find . -iname '*.rule' -exec mv {} . \; &&\
    find ./* -type d -exec rm -rf \;
