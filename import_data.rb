require 'active_record'
require 'pg'
require 'rubyXL'
require 'dotenv/load'

# Connexion à la base de données
ActiveRecord::Base.establish_connection(
  adapter: 'postgresql',
  host: 'localhost',
  username: 'due',
  password: ENV['DB_PASSWORD'],
  database: 'due'
)

# Modèles pour les tables de la base de données
class Order < ActiveRecord::Base
  self.primary_key = 'orderid'
  has_many :packages, foreign_key: 'orderid'
end

class Package < ActiveRecord::Base
  self.primary_key = 'packageid'
  belongs_to :order, foreign_key: 'orderid'
  has_many :items, foreign_key: 'packageid'
end

class Item < ActiveRecord::Base
  self.primary_key = 'itemid'
  belongs_to :package, foreign_key: 'packageid'
end

# Obtenir les IDs max pour éviter les doublons
def get_max_ids
  max_package_id = Package.maximum(:packageid) || 0
  max_item_id = Item.maximum(:itemid) || 0
  [max_package_id, max_item_id]
end

# Importer les données depuis le fichier Excel
def import_data_from_workbook
  # Charger le fichier Excel
  workbook = RubyXL::Parser.parse('Orders.xlsx')
  # Obtenir les IDs max actuels
  max_package_id, max_item_id = get_max_ids

  # Parcourir chaque feuille de calcul (chaque commande)
  workbook.worksheets.each_with_index do |worksheet, index|
    order_name = worksheet.sheet_name # Utiliser le nom de la feuille comme nom de la commande
    puts "Processing #{order_name}"
    # Traiter la feuille de calcul
    max_package_id, max_item_id = process_worksheet(worksheet, index + 1, order_name, max_package_id, max_item_id)
  end

  puts 'Data import complete!'
end

# Traiter une feuille de calcul spécifique
def process_worksheet(worksheet, order_id, order_name, max_package_id, max_item_id)
  # Trouver ou créer la commande
  order = Order.find_or_create_by!(orderid: order_id, ordername: order_name)
  current_package = nil
  last_item_index = nil # Track the last item index

  # Parcourir chaque ligne de la feuille de calcul
  worksheet.each_with_index do |row, index|
    next if index == 0 # Ignorer la ligne d'en-tête
    # Récupérer les valeurs des cellules
    package_index, item_index, label, value = row.cells.map { |cell| cell && cell.value.to_s.strip }
    next if value.nil? || value.empty?

    ActiveRecord::Base.transaction do
      # Créer un nouvel item à chaque changement de item_index
      if item_index != last_item_index
        if item_index.to_i == 0
          max_package_id += 1
          current_package = order.packages.create!(packageid: max_package_id)
        end
        max_item_id += 1
        current_package.items.create!(itemid: max_item_id, packageid: current_package.packageid)
        last_item_index = item_index
      end

      # Traiter les différentes étiquettes
      if current_package && current_package.items.any?
        current_item = current_package.items.last
        attribute = { label.downcase.to_sym => value }
        attribute[:warranty] = (value.downcase == 'yes') ? true : false if label.downcase == 'warranty'
        current_item.update!(attribute)
      else
        puts "No current item to update for label: #{label} with value: #{value}"
      end
    end
  end
  # Retourner les IDs max mis à jour
  [max_package_id, max_item_id]
rescue ActiveRecord::RecordInvalid => e
  puts "Failed to process row due to validation errors: #{e.message}"
rescue StandardError => e
  puts "An error occurred: #{e.message}"
end

# Lancer l'importation
import_data_from_workbook
