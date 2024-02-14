FROM alpine/git

ARG ADD_WORDLIST_N_RULES=false

WORKDIR /opt/wordlists
RUN [[ "$ADD_WORDLIST_N_RULES" == "true" ]] && git clone https://github.com/danielmiessler/SecLists.git --depth 1 &&\
    find . -type f -iname '*.tar.gz' -exec tar -xf {} \;

WORKDIR /opt/rules
RUN [[ "$ADD_WORDLIST_N_RULES" == "true" ]] && git clone https://github.com/NotSoSecure/password_cracking_rules.git --depth=1
