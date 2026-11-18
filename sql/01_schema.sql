-- BTS SIO SLAM 2A · Centre culturel · SCHÉMA INITIAL
-- Fichier exécuté UNE SEULE FOIS lors de la création du volume.
-- Les vues, procédures et triggers ne sont PAS créés ici.
USE centre_culturel;

CREATE TABLE participants (
  id INT AUTO_INCREMENT PRIMARY KEY,
  nom VARCHAR(100) NOT NULL,
  email VARCHAR(190) NOT NULL UNIQUE,
  ville VARCHAR(100) NOT NULL
) ENGINE=InnoDB;

CREATE TABLE activites (
  id INT AUTO_INCREMENT PRIMARY KEY,
  titre VARCHAR(120) NOT NULL,
  categorie VARCHAR(70) NOT NULL,
  prix DECIMAL(10,2) NOT NULL,
  places_max INT NOT NULL,
  active TINYINT(1) NOT NULL DEFAULT 1,
  CONSTRAINT chk_activite_prix CHECK (prix >= 0),
  CONSTRAINT chk_activite_places CHECK (places_max > 0)
) ENGINE=InnoDB;

CREATE TABLE inscriptions (
  id INT AUTO_INCREMENT PRIMARY KEY,
  participant_id INT NOT NULL,
  activite_id INT NOT NULL,
  montant DECIMAL(10,2) NOT NULL,
  statut VARCHAR(20) NOT NULL DEFAULT 'en_attente',
  date_inscription DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT fk_inscription_participant FOREIGN KEY (participant_id)
    REFERENCES participants(id),
  CONSTRAINT fk_inscription_activite FOREIGN KEY (activite_id)
    REFERENCES activites(id),
  CONSTRAINT uq_inscription UNIQUE (participant_id, activite_id),
  CONSTRAINT chk_inscription_montant CHECK (montant >= 0),
  CONSTRAINT chk_inscription_statut
    CHECK (statut IN ('en_attente', 'confirmee', 'annulee'))
) ENGINE=InnoDB;

-- Journal indépendant : aucune suppression en cascade de ses traces.
CREATE TABLE journal_inscriptions (
  id INT AUTO_INCREMENT PRIMARY KEY,
  inscription_id INT NOT NULL,
  ancien_statut VARCHAR(20) NOT NULL,
  nouveau_statut VARCHAR(20) NOT NULL,
  modifie_le DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB;
