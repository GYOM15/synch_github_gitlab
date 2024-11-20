# Git Automation: Synchronisation entre GitHub et GitLab

## Présentation

Ce projet propose une solution automatisée pour gérer et synchroniser vos dépôts Git entre **GitHub** et **GitLab**. Le script fourni s'assure que :
- Les dépôts locaux sont configurés correctement.
- Les dépôts distants (GitHub et GitLab) existent ou sont créés automatiquement.
- Les modifications locales sont poussées sur les deux plateformes en une seule commande.

---

## Fonctionnalités

1. Vérification ou Initialisation du Dépôt Git Local
2. Création Automatique des Dépôts GitHub et GitLab si Inexistants
3. Ajout ou Mise à Jour des Remotes pour GitHub et GitLab
4. Vérification de la présence d’au moins un commit avant de pousser les modifications sur les deux dépôts
5. Poussée des Modifications Locales sur les Deux Plateformes

---

## 🛠️ Prérequis

Avant d'utiliser ce script, assurez-vous d'avoir :
- **Git** installé sur votre système :
```bash
git --version
```
## Structure des dossiers afin d'executer le script

Rassurer vous d'avoir le script à la racine du projet 
   ```bash
   votre_projet/
   |── script_push.sh     # Script Bash d'automatisation
   ```
# Étapes pour Utiliser le Script Git Automation

## Étape 1 : Préparer l'Environnement

1. **Installer Git**
   - Linux : `sudo apt install git`
   - macOS : `brew install git`
   - Windows : Télécharger et installer depuis [Git for Windows](https://git-scm.com/downloads).

2. **Installer GitHub CLI (`gh`)**
   - Linux/macOS : `brew install gh` ou `sudo apt install gh`.
   - Windows : Télécharger depuis [GitHub CLI](https://cli.github.com/).

3. **Installer GitLab CLI (`glab`)**
   - Linux/macOS : `brew install glab` ou `sudo apt install glab`.
   - Windows : Télécharger depuis [GitLab CLI](https://github.com/profclems/glab#installation).

4. **Configurer les CLIs**
   - GitHub : `gh auth login`
   - GitLab : `glab auth login`

5. **Configurer les Clés SSH**
- Générer une clé SSH pour chacune des plateformes :  
   ```bash
   ssh-keygen -t ed25519 -C "votre.email@exemple.com" -f ~/.ssh/id_github
   ssh-keygen -t ed25519 -C "votre.email@exemple.com" -f ~/.ssh/id_gitlab
   eval "$(ssh-agent -s)"
   ssh-add ~/.ssh/id_github
   ssh-add ~/.ssh/id_gitlab
   ```
- Sans oublier d'ajouter les clé SSH publiques à vos comptes GitHub et GitLab.

---
## Étape 2 : Editer le fichier de configuration 
- ~/.ssh/config

   ```bash
   # Configuration pour GitHub
   Host github.com
   HostName github.com
   User git
   IdentityFile ~/.ssh/id_github
   IdentitiesOnly yes

   # Configuration pour GitLab
   Host gitlab.com
   HostName gitlab.com
   User git
   IdentityFile ~/.ssh/id_gitlab
   IdentitiesOnly yes
   ```

## Étape 3 : Préparer le Script

1. **Cloner le projet :**
2. **Copier le contenu du fichier**
3.	Modifiez les variables dans le fichier script_push.sh :

	- REPO_NAME, GITHUB_USER, GITLAB_USER.

4.	Rendez le script exécutable : 
      ```bash
      chmod +x script_push.sh
      ```
## Étape 4 : Exécuter le Script

1. Lancez le script :
   ```bash
   ./script_push.sh
   ```
## Étape 5 : Vérifier les Résultats

1. Accédez aux dépôts distants :
   - **GitHub** : `https://github.com/<VotreNomUtilisateur>/<NomDépôt>`
   - **GitLab** : `https://gitlab.com/<VotreNomUtilisateur>/<NomDépôt>`
