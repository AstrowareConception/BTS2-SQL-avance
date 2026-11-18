# Carte des données — Centre culturel

```text
participants (1) ───── (N) inscriptions (N) ───── (1) activites
 id (PK)                      id (PK)                    id (PK)
 nom                          participant_id (FK)        titre
 email                        activite_id (FK)           categorie
 ville                        montant                    prix
                              statut                     places_max
                              date_inscription           active

journal_inscriptions
 id (PK)
 inscription_id          ← lien logique vers inscriptions.id
 ancien_statut
 nouveau_statut
 modifie_le
```

**Rappel fonctionnel :** une inscription correspond à un participant ET à une activité ; son montant est conservé indépendamment d'une éventuelle évolution du tarif catalogue. Une même personne ne peut pas avoir deux inscriptions à la même activité (contrainte d'unicité).

Le journal ne possède volontairement pas de clé étrangère vers les inscriptions : dans cet exemple pédagogique, l'objectif est de conserver la trace même si une inscription était supprimée. Cette décision devrait être discutée dans un véritable projet (rétention, droits et audit).

## Les trois états

- **en_attente** : demande enregistrée, pas encore confirmée ;
- **confirmee** : inscription confirmée, prise en compte dans les recettes du TP ;
- **annulee** : demande annulée, exclue des recettes.

Ces états sont un **modèle pédagogique simplifié** : en comptabilité réelle, confirmation et encaissement sont deux événements différents. Le TP choisit explicitement « confirmation » comme règle de calcul de son indicateur de recette.

## Les données à contrôler

| Élément | Nombre initial |
|---|---:|
| Participants | 6 |
| Activités | 7 (dont une inactive) |
| Inscriptions | 12 |
| Confirmées | 7 |
| En attente | 3 |
| Annulées | 2 |
| Journal | 0 |
| Montant des confirmées | 258,00 € |
