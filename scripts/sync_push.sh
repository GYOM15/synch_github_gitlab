#!/bin/bash
#
# Variables à configurer par l'utilisateur
REPO_NAME="<VotreNomDeDepôt>"  # Nom du dépôt
GITHUB_USER="<VotreNomUtilisateurGitHub>"  # Nom d'utilisateur GitHub
GITLAB_USER="<VotreNomUtilisateurGitLab>"  # Nom d'utilisateur GitLab
BRANCH="dev"  # Changez par le nom de votre branche si ce n'est pas 'main'

# URL des dépôts distants
GITHUB_URL="git@github.com:$GITHUB_USER/$REPO_NAME.git"
GITLAB_URL="git@gitlab.com:$GITLAB_USER/$REPO_NAME.git"

# Vérifie si le répertoire est un dépôt Git
if [ ! -d .git ]; then
  echo "🔍 Ce répertoire n'est pas un dépôt Git. Initialisation en cours..."
  git init
  git checkout -b "$BRANCH"
  echo "📂 Ajout de fichiers au dépôt local..."
  git add .
  echo "💬 Entrez un message pour le premier commit :"
  read -r commit_message
  git commit -m "$commit_message"
  echo "✅ Dépôt Git local initialisé et premier commit créé."
else
  echo "📂 Vérification des fichiers modifiés..."
  if [ -n "$(git status --porcelain)" ]; then
    echo "📂 Des fichiers non suivis ou des modifications détectées."
    echo "Voici la liste des fichiers modifiés :"
    
    # Préparation de l'affichage des fichiers modifiés
    files=$(git status --porcelain | awk '{printf "%-10s %s\n", $1, $2}')
    files_array=($(git status --porcelain | awk '{print $2}'))

    echo -e "\n┌──────┬─────────────────────────────"
    echo -e " Index | Fichiers modifiés              "
    echo -e " ──────┼─────────────────────────────"

    index=1
    for file in "${files_array[@]}"; do
      printf "│ %-4d │ %-30s │\n" "$index" "$file"
      index=$((index + 1))
    done

    echo -e "└──────┴─────────────────────────────"

    selected_files=()
    while true; do
      echo "💬 Entrez les numéros des fichiers à ajouter au commit, séparés par des espaces (ou 'done' pour terminer) :"
      read -r input
      if [ "$input" == "done" ]; then
        break
      fi
      
      for index in $input; do
        if ((index > 0 && index <= ${#files_array[@]})); then
          selected_files+=("${files_array[index-1]}")
        else
          echo "⚠️ Le numéro $index est invalide. Ignoré."
        fi
      done
    done

    if [ ${#selected_files[@]} -gt 0 ]; then
      git add "${selected_files[@]}"
      echo "💬 Entrez un message pour le commit :"
      read -r commit_message
      git commit -m "$commit_message"
      echo "✅ Les fichiers sélectionnés ont été ajoutés et commités."
    else
      echo "⚠️ Aucun fichier sélectionné. Le script s'arrête."
      exit 1
    fi
  fi
fi

# Vérifiez si la branche existe localement
if ! git rev-parse --verify "$BRANCH" >/dev/null 2>&1; then
  echo "🌱 La branche '$BRANCH' n'existe pas localement. Création en cours..."
  git checkout -b "$BRANCH"
fi

# Ajouter les remotes si elles n'existent pas
echo "🔗 Configuration des remotes..."
git remote remove github 2>/dev/null
git remote remove gitlab 2>/dev/null
git remote add github "$GITHUB_URL"
git remote add gitlab "$GITLAB_URL"
git remote -v

# Vérifie et crée le dépôt GitHub s'il n'existe pas
echo "🔍 Vérification du dépôt GitHub..."
if gh repo view "$GITHUB_USER/$REPO_NAME" &>/dev/null; then
  echo "✅ Le dépôt GitHub existe déjà."
else
  echo "📦 Création du dépôt GitHub..."
  gh repo create "$GITHUB_USER/$REPO_NAME" --public --source=. --remote=github
fi

# Vérifie et crée le dépôt GitLab s'il n'existe pas
echo "🔍 Vérification du dépôt GitLab..."
if glab repo view "$REPO_NAME" &>/dev/null; then
  echo "✅ Le dépôt GitLab existe déjà."
else
  echo "📦 Création du dépôt GitLab..."
  glab repo create "$REPO_NAME" --public --description "Dépôt synchronisé entre GitHub et GitLab"
fi

# Vérifier et créer la branche distante si nécessaire
echo "🔍 Vérification de la branche '$BRANCH' sur GitHub..."
if ! git ls-remote --heads github "$BRANCH" | grep -q "$BRANCH"; then
  echo "❓ La branche '$BRANCH' n'existe pas sur GitHub. Voulez-vous la créer ? (yes/no)"
  read -r create_branch
  if [ "$create_branch" == "yes" ]; then
    git push github "$BRANCH" --set-upstream
  else
    echo "⚠️ La branche n'a pas été créée sur GitHub. Le script s'arrête."
    exit 1
  fi
fi

echo "🔍 Vérification de la branche '$BRANCH' sur GitLab..."
if ! git ls-remote --heads gitlab "$BRANCH" | grep -q "$BRANCH"; then
  echo "❓ La branche '$BRANCH' n'existe pas sur GitLab. Voulez-vous la créer ? (yes/no)"
  read -r create_branch
  if [ "$create_branch" == "yes" ]; then
    git push gitlab "$BRANCH" --set-upstream
  else
    echo "⚠️ La branche n'a pas été créée sur GitLab. Le script s'arrête."
    exit 1
  fi
fi

# Pousser sur GitHub
echo "🚀 Poussée des modifications sur GitHub..."
git push github "$BRANCH"

# Pousser sur GitLab
echo "🚀 Poussée des modifications sur GitLab..."
git push gitlab "$BRANCH"

echo "🎉 Synchronisation terminée avec succès. Merci!"