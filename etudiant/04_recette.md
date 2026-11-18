# Fiche de recette — TP SQL avancé

**Nom / binôme :** …  
**Date :** …  
**MySQL :** 8.4 (Docker Compose fourni)

Renseignez la colonne Observé et indiquez une preuve. Une erreur attendue (refus d'annulation) vaut réussite lorsqu'elle est correctement vérifiée.

| Test | Action à réaliser | Attendu | Observé | Preuve |
|---|---|---|---|---|
| T01 | SELECT sur v_participants_publics | 6 lignes, id/nom/ville, sans email | … | … |
| T02 | SELECT sur v_inscriptions_detail | 12 lignes ; inscription 1 = Léa / Photo urbaine | … | … |
| T03 | SELECT sur v_recettes_activites | 7 lignes ; total recettes = 258,00 € avant changement | … | … |
| T04 | CALL sp_inscriptions_participant(1) | 3 lignes : 1, 3, 11 | … | … |
| T05 | CALL sp_total_confirme(1, @total), puis SELECT @total | 75,00 € avant changement | … | … |
| T06 | CALL sp_total_confirme(6, @total), puis SELECT @total | 0,00 € | … | … |
| T07 | UPDATE inscription 3 → confirmee | Une seule nouvelle ligne dans le journal | … | … |
| T08 | Même UPDATE une seconde fois | Toujours une seule ligne dans le journal | … | … |
| T09 | Recalcul des recettes et du total Léa | Recettes = 276,00 € ; Léa = 93,00 € | … | … |
| T10 | UPDATE inscription 1 → annulee | SQLSTATE 45000 ; statut reste confirmee ; journal inchangé | … | … |

**Ordre recommandé :** faire T01 à T06 avant T07, car la confirmation de l'inscription 3 modifie les montants attendus.

## Preuves minimales

1. Capture d'une vue sans e-mail et de ses colonnes.
2. Résultat de la vue de recettes.
3. Deux appels de procédure dont un avec paramètre OUT.
4. Journal avant puis après changement (une seule nouvelle trace).
5. Refus de l'annulation et SELECT montrant que l'inscription 1 n'a pas changé.

## Analyse personnelle (4 à 6 lignes par question)

**A.** Dans ce TP, quelle différence existe entre une vue et une table ?

**B.** Pourquoi une procédure ne s'exécute-t-elle pas automatiquement lors d'un UPDATE ?

**C.** Pourquoi le trigger de refus doit-il se déclencher BEFORE UPDATE ?

**D.** Pourquoi une vue excluant email ne constitue-t-elle pas, à elle seule, une stratégie complète d'habilitation ?

**E.** Qu'avez-vous dû corriger lors de vos essais SQL ? Expliquez au moins une erreur réelle et sa résolution.

## Livraison

Fournir les trois scripts SQL complétés, cette fiche et les preuves. Ne livrez **pas seulement des captures** : le SQL éditable est exigé.
