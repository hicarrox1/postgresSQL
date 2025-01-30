-- Création du schéma\
CREATE SCHEMA e_commerce;
SET search_path TO e_commerce;

-- Modélisation UML en SQL avec PostgreSQL

-- Création des types ENUM pour PostgreSQL
CREATE TYPE categorie_produit AS ENUM ('electronique', 'textile', 'plastique', 'bois');
CREATE TYPE categorie_client AS ENUM ('ancien_client', 'moteur_de_recherche', 'reseaux_sociaux', 'partenariat');

-- Table des produits
CREATE TABLE produit (
    id SERIAL PRIMARY KEY,
    nom VARCHAR(255) NOT NULL,
    ian VARCHAR(13) UNIQUE NOT NULL,
    fabricant VARCHAR(255) NOT NULL,
    prix int NOT NULL,
    date_ajout DATE NOT NULL,
    categorie categorie_produit NOT NULL
);

-- Table des clients
CREATE TABLE client (
    id SERIAL PRIMARY KEY,
    nom VARCHAR(255) NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL,
    mot_de_passe VARCHAR(255) NOT NULL,
    adresse VARCHAR(255) NOT NULL,
    code_postal VARCHAR(10) NOT NULL,
    pays VARCHAR(100) NOT NULL,
    date_naissance DATE NOT NULL,
    date_inscription DATE NOT NULL,
    categorie categorie_client NOT NULL
);

-- Table des commandes
CREATE TABLE commande (
    id SERIAL PRIMARY KEY,
    client_id INT REFERENCES client(id) ON DELETE CASCADE,
    produit_id INT REFERENCES produit(id) ON DELETE CASCADE,
    quantite INT CHECK (quantite > 0) NOT NULL,
    remise INT DEFAULT 0,
    sous_total INT NOT NULL,
    taxes INT NOT NULL,
    montant_total INT NOT NULL,
    date_validation DATE NOT NULL
);

-- Table des avis
CREATE TABLE avis (
    id SERIAL PRIMARY KEY,
    client_id INT REFERENCES client(id) ON DELETE CASCADE,
    produit_id INT REFERENCES produit(id) ON DELETE CASCADE,
    note INT CHECK (note BETWEEN 0 AND 5) NOT NULL,
    commentaire VARCHAR(255),
    date_redaction DATE NOT NULL
);

-- Insertion de données factices dans la base de données e_commerce

-- Insertion des produits
INSERT INTO produit (nom, ian, fabricant, prix, date_ajout, categorie) VALUES
('Smartphone X', '1234567890123', 'TechCorp', 699, '2024-01-01', 'electronique'),
('T-Shirt Bio', '9876543210987', 'EcoWear', 19, '2024-01-02', 'textile'),
('Chaise Plastique', '4567891234567', 'HomeDeco', 49, '2024-01-03', 'plastique'),
('Table en Bois', '3216549876543', 'WoodWorks', 199, '2024-01-04', 'bois');

-- Insertion des clients
INSERT INTO client (nom, email, mot_de_passe, adresse, code_postal, pays, date_naissance, date_inscription, categorie) VALUES
('Alice Dupont', 'alice@example.com', 'password123', '10 rue des Lilas, Paris', '75001', 'France', '1990-05-12', '2024-01-01', 'ancien_client'),
('Bob Martin', 'bob@example.com', 'securepass', '20 avenue Victor Hugo, Lyon', '69002', 'France', '1985-09-23', '2024-01-02', 'reseaux_sociaux');

-- Insertion des commandes
INSERT INTO commande (client_id, produit_id, quantite, remise, sous_total, taxes, montant_total, date_validation) VALUES
(1, 1, 1, 10, 629, 50, 679, '2024-01-05'),
(2, 3, 2, 5, 94, 10, 104, '2024-01-06');

-- Insertion des avis
INSERT INTO avis (client_id, produit_id, note, commentaire, date_redaction) VALUES
(1, 1, 5, 'Excellent produit, très performant !', '2024-01-07'),
(2, 1, 2, 'BOF', '2024-03-10'),
(2, 3, 3, 'Correct, mais la qualité du plastique pourrait être meilleure.', '2024-01-08');


select * from client;
select * from produit;
select * from commande;

select client.nom, avis.note, avis.commentaire, avis.date_redaction from avis
join produit on avis.produit_id = produit.id
join client on avis.client_id = client.id
where produit.nom = 'Smartphone X';