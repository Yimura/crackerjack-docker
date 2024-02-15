FROM alpine/git

ARG ADD_WORDLIST_N_RULES=false

USER root

WORKDIR /opt/wordlists
RUN [[ "$ADD_WORDLIST_N_RULES" == "true" ]] && git clone https://github.com/danielmiessler/SecLists.git --depth 1 ||\
    echo "Skip pulling SecLists, ADD_WORDLIST_N_RULES build arg is not set to true"

WORKDIR /opt/rules
RUN [[ "$ADD_WORDLIST_N_RULES" == "true" ]] && git clone https://github.com/NotSoSecure/password_cracking_rules.git --depth=1 ||\
    echo "Skip pulling password_cracking_rules, ADD_WORDLIST_N_RULES build arg is not set to true"

WORKDIR /opt/wordlists
RUN [[ "$ADD_WORDLIST_N_RULES" == "true" ]] && find . -type f -iname '*.tar.gz' -exec tar -xf {} \; -exec rm -f {} \; &&\
    find ./SecLists -maxdepth 1 -type d ! -path './SecLists/Passwords' ! -path './SecLists' -exec rm -rf {} \; ||\
    echo "SecLists was not pulled, skipping optimisation step."

WORKDIR /opt/rules
RUN [[ "$ADD_WORDLIST_N_RULES" == "true" ]] && find . -iname '*.rule' -exec mv {} . \; &&\
    find . -maxdepth 1 -type d ! -path '.' -exec rm -rf {} \; ||\
    echo "password_cracking_rules was not pulled, skipping optimisation step."
