# Notes pédagogiques — sans solutions

**Durée : 220 minutes** · Niveau : BTS SIO SLAM 2e année · Sujet : centre culturel.

Ce document est **public** et ne contient volontairement aucun corrigé. Le corrigé enseignant doit être conservé hors de ce dépôt public.

## Cadence conseillée

| Repère | Temps écoulé | Critère de progression |
|---|---:|---|
| Base ouverte et comprise | 20 min | 6 / 7 / 12 / 0 et 258 € |
| Trois vues validées | 75 min | colonnes, JOIN, agrégat |
| Deux procédures validées | 130 min | IN, OUT et CALL |
| Deux triggers validés | 195 min | journal unique, refus |
| Recette et livraison | 220 min | preuves, analyse |

**Différenciation :** débloquer les étudiants fragiles avec docs/AIDE_MEMOIRE.md et les cas simples des vues ; conserver la vue agrégée avec LEFT JOIN pour la discussion collective. Pour les plus rapides, proposer les défis facultatifs.

**Points d'attention :** ne pas donner les scripts SQL du cours comme corrigés ; vérifier l'unicité du journal sur UPDATE sans changement ; faire tester l'erreur attendue séparément (ne pas lancer tout le lot dans une transaction qui masque les observations). Les montants attendus changent après confirmation de l'inscription 3.

**Correction / évaluation :** le barème de TP_ETUDIANT.md est indicatif. Demander une justification orale rapide d'une vue, d'un CALL avec OUT et de l'ordre BEFORE/AFTER. Les scripts doivent être réellement exécutés ; les captures seules ne suffisent pas.

**Sécurité des données :** l'exclusion de email d'une vue est une réduction de surface d'exposition. Elle n'est pas une protection effective si le compte de base de données conserve SELECT sur participants ; les privilèges restent à gérer à part.

**Conformité BTS SIO :** activité Gestion des données de l'option SLAM (requêtes, fonctionnalités dans un SGBD, tests, documentation). Les objets SQL choisis illustrent le référentiel, sans prétendre que MySQL ou ces objets sont exigés nommément à l'examen.
