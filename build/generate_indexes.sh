#!/bin/bash

# Fichier template et output
TEMPLATE_FILE="index.template.html"
IMPORTMAP_FILE="importmap.json"
OUTPUT_FILE="index.html"

TEMPLATE=$(cat "$TEMPLATE_FILE")
IMPORTMAP=$(cat "$IMPORTMAP_FILE")
TEMPLATE=$(echo "$TEMPLATE" | awk -v pattern="${IMPORTMAP_FILE}" -v content="$IMPORTMAP" '{gsub("\\$\\${" pattern "}", content)}1')
echo $TEMPLATE



# Fonction pour remplacer les motifs ${nomDuFichier} par le contenu de nomDuFichier
replace_patterns() {
    local index=$TEMPLATE
    local dir=$1

    for file in "$dir"/*.html; do
        if [[ -f "$file" && "$file" != *"$OUTPUT_FILE" ]]; then
            filename=$(basename "$file")
            file_content=$(awk '{printf "%s", $0}' "$file" )
            index=$(echo "$index" | awk -v pattern="${filename}" -v content="$file_content" '{gsub("\\${" pattern "}", content)}1')
        fi
    done

    echo "$index" > "$dir/$OUTPUT_FILE"
}

# Appliquer la fonction à chaque répertoire contenant un fichier content.html
for dir in $(find . -type f -name 'content.html' -exec dirname {} \;); do
    replace_patterns "$dir"
    echo "Génération de $dir/$OUTPUT_FILE"
done
