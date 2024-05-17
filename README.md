Ce projet automatise le processus d'importation de données à partir de fichiers Excel dans une base de données PostgreSQL en utilisant Ruby. Le script lit les données de plusieurs feuilles de calcul dans un fichier Excel et les insère dans les tables correspondantes de la base de données.

Prérequis
Ruby PostgreSQL Bundler (gem install bundler) Gems nécessaires : rubyXL, activerecord, pg, dotenv

Installation
Cloner le dépôt : git clone git@github.com:Mohamedcodings/due-backend-SQL.git cd due-backend-SQL

Installer les dépendances : bundle install

Créer un fichier .env pour vos identifiants de base de données : touch .env

Ajouter votre mot de passe de base de données dans le fichier .env : DB_PASSWORD=your_database_password

Utilisation
Assurez-vous que votre serveur PostgreSQL est en cours d'exécution.

Mettez à jour le script import_data.rb si nécessaire (par exemple, les détails de connexion à la base de données).

Exécuter le script : ruby import_data.rb

Structure du projet
import_data.rb : Script principal pour l'importation des données. Orders.xlsx : Exemple de fichier Excel contenant les données à importer.
