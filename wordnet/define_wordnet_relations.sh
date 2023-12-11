#!/bin/bash

#
# Copyright (c) 2023. Bernard Bou
#

# WORDNET RELATIONS

export hierarchy="hypernym hyponym hypernym_instance hyponym_instance troponym holonym meronym holonym_member meronym_member holonym_part meronym_part holonym_substance meronym_substance"
export lex="antonym"
export verb="causes caused entails entailed verbgroup participle"
export adj="similar attribute"
export deriv="derivation derivation_adj"
export role="role_agent role_bodypart role_bymeansof role_destination role_event role_instrument role_location role_material role_property role_result role_state role_undergoer role_uses role_vehicle"
export misc="also pertainym"
export domain="domain hasdomain domain_topic hasdomain_topic domain_region hasdomain_region domain_usage hasdomain_usage"

obsoleted="synonym other domain_term hasdomain_term"

export all_relations="${hierarchy} ${lex} ${verb} ${adj} ${deriv} ${role} ${misc} ${domain}"
