-- Données fictives à identifiants fixes pour les tests 2026-2027.
USE centre_culturel;

INSERT INTO participants (id, nom, email, ville) VALUES
  (1, 'Léa Martin', 'lea.martin@example.test', 'Nice'),
  (2, 'Omar Benali', 'omar.benali@example.test', 'Cannes'),
  (3, 'Nina Dubois', 'nina.dubois@example.test', 'Antibes'),
  (4, 'Hugo Laurent', 'hugo.laurent@example.test', 'Nice'),
  (5, 'Sarah Petit', 'sarah.petit@example.test', 'Mougins'),
  (6, 'Emma Perez', 'emma.perez@example.test', 'Grasse');

INSERT INTO activites (id, titre, categorie, prix, places_max, active) VALUES
  (1, 'Photo urbaine', 'Création', 35.00, 12, 1),
  (2, 'Yoga du samedi', 'Bien-être', 18.00, 15, 1),
  (3, 'Cuisine italienne', 'Cuisine', 45.00, 10, 1),
  (4, 'Initiation guitare', 'Musique', 25.00, 8, 1),
  (5, 'Atelier poterie', 'Création', 40.00, 10, 1),
  (6, 'Randonnée découverte', 'Sport', 12.00, 20, 1),
  (7, 'Cinéma en plein air', 'Culture', 8.00, 50, 0);

INSERT INTO inscriptions
  (id, participant_id, activite_id, montant, statut, date_inscription)
VALUES
  (1, 1, 1, 35.00, 'confirmee', '2026-11-02 09:00:00'),
  (2, 2, 1, 35.00, 'confirmee', '2026-11-02 09:15:00'),
  (3, 1, 2, 18.00, 'en_attente', '2026-11-03 11:00:00'),
  (4, 3, 3, 45.00, 'confirmee', '2026-11-04 10:30:00'),
  (5, 4, 4, 25.00, 'annulee', '2026-11-05 13:40:00'),
  (6, 2, 2, 18.00, 'confirmee', '2026-11-05 16:30:00'),
  (7, 5, 5, 40.00, 'confirmee', '2026-11-06 08:10:00'),
  (8, 6, 6, 12.00, 'en_attente', '2026-11-06 13:20:00'),
  (9, 3, 1, 35.00, 'annulee', '2026-11-07 09:50:00'),
  (10, 4, 3, 45.00, 'confirmee', '2026-11-07 12:10:00'),
  (11, 1, 5, 40.00, 'confirmee', '2026-11-08 10:00:00'),
  (12, 5, 4, 25.00, 'en_attente', '2026-11-09 15:00:00');

-- journal_inscriptions est volontairement vide au départ.
