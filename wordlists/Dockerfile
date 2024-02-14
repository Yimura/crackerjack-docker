FROM alpine/git

ARG ADD_WORDLIST_N_RULES=false

WORKDIR /opt/wordlists
RUN if [[ "$ADD_WORDLIST_N_RULES" == "true" ]] ; then git clone https://github.com/danielmiessler/SecLists.git --depth 1 &&\
    find . -type f -iname '*.tar.gz' -exec tar -xf {} ; fi

WORKDIR /opt/rules
RUN if [[ "$ADD_WORDLIST_N_RULES" == "true" ]] ; then git clone https://github.com/NotSoSecure/password_cracking_rules.git --depth=1; fi
