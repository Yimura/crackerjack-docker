FROM alpine/git

ARG ADD_WORDLIST_N_RULES=false

USER root

WORKDIR /opt/wordlists
RUN [[ "$ADD_WORDLIST_N_RULES" == "true" ]] && git clone https://github.com/danielmiessler/SecLists.git --depth 1

WORKDIR /opt/rules
RUN [[ "$ADD_WORDLIST_N_RULES" == "true" ]] && git clone https://github.com/NotSoSecure/password_cracking_rules.git --depth=1

WORKDIR /opt/wordlists
RUN find . -type f -iname '*.tar.gz' -exec tar -xf {} \; -exec rm -f {} \; &&\
    find ./SecLists -maxdepth 1 -type d ! -path './SecLists/Passwords' ! -path './SecLists' -exec rm -rf {} \;

WORKDIR /opt/rules
RUN find . -iname '*.rule' -exec mv {} . \; &&\
    find . -maxdepth 1 -type d ! -path '.' -exec rm -rf {} \;
