# frozen_string_literal: true

all
rule 'MD013', line_length: 120

# Allow CHANGELOG.md like nesting
rule 'MD024', allow_different_nesting: true

# Disable rule because github wiki uses filename
# as the initial H1
exclude_rule 'MD041'
