# Due Backend SQL

Ce projet automatise le processus d'importation de données à partir de fichiers Excel dans une base de données PostgreSQL en utilisant Ruby. Le script lit les données de plusieurs feuilles de calcul dans un fichier Excel et les insère dans les tables correspondantes de la base de données.

## Prérequis

- Ruby
- PostgreSQL
- Bundler (`gem install bundler`)
- Gems nécessaires : `rubyXL`, `activerecord`, `pg`, `dotenv`

## Installation

1. **Cloner le dépôt :**
    ```sh
    git clone git@github.com:Mohamedcodings/due-backend-SQL.git
    cd due-backend-SQL
    ```

2. **Installer les dépendances :**
    ```sh
    bundle install
    ```

3. **Créer un fichier `.env` pour vos identifiants de base de données :**
    ```sh
    touch .env
    ```

    Ajouter votre mot de passe de base de données dans le fichier `.env` :
    ```sh
    DB_PASSWORD=your_database_password
    ```

## Utilisation

1. **Assurez-vous que votre serveur PostgreSQL est en cours d'exécution.**

2. **Mettez à jour le script `import_data.rb` si nécessaire (par exemple, les détails de connexion à la base de données).**

3. **Exécuter le script :**
    ```sh
    ruby import_data.rb
    ```

## Structure du projet

- `import_data.rb` : Script principal pour l'importation des données.
- `Orders.xlsx` : Exemple de fichier Excel contenant les données à importer.

