#!/bin/bash

# Variables
REPO_NAME="synch_github_gitlab"
GITHUB_USER="<VotreNomUtilisateurGitHub>"
GITHUB_URL="git@github.com:$GITHUB_USER/$REPO_NAME.git"
GITLAB_USER="<VotreNomUtilisateurGitLab>"
GITLAB_URL="git@gitlab.com:$GITLAB_USER/$REPO_NAME.git"
BRANCH="main"  # Changez par le nom de votre branche si ce n'est pas 'main'

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
  # Vérifie s'il y a des fichiers non suivis ou dans l'index
  if [ -n "$(git status --porcelain)" ]; then
    echo "📂 Des fichiers non suivis ou des modifications détectées."
    echo "💬 Souhaitez-vous les ajouter et effectuer un commit ? (yes/no)"
    read -r response
    if [ "$response" == "yes" ]; then
      git add .
      echo "💬 Entrez un message pour le commit :"
      read -r commit_message
      git commit -m "$commit_message"
      echo "✅ Les modifications ont été ajoutées et commités."
    else
      echo "⚠️ Aucun commit effectué. Le script s'arrête."
      exit 1
    fi
  fi
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
  glab repo create "$REPO_NAME" --public --group "$GITLAB_USER" --description "Dépôt synchronisé entre GitHub et GitLab"
fi

# Pousser sur GitHub
echo "🚀 Poussée des modifications sur GitHub..."
if git push github "$BRANCH"; then
  echo "✅ Poussée réussie sur GitHub."
else
  echo "⚠️ Échec de la poussée sur GitHub."
fi

# Pousser sur GitLab
echo "🚀 Poussée des modifications sur GitLab..."
if git push gitlab "$BRANCH"; then
  echo "✅ Poussée réussie sur GitLab."
else
  echo "⚠️ Échec de la poussée sur GitLab."
fi

echo "🎉 Synchronisation terminée avec succès."

