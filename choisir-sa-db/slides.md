---
# try also 'default' to start simple
theme: ../slidev-theme-soma
# some information about your slides (markdown enabled)
title: Comment choisir sa base de données
info: |
  ## Comment choisir sa base de données
  Besoins, performances & scalabilité
# apply UnoCSS classes to the current slide
class: text-center
# https://sli.dev/features/drawing
drawings:
  persist: false
# slide transition: https://sli.dev/guide/animations.html#slide-transitions
transition: fade
# enable MDC Syntax: https://sli.dev/features/mdc
mdc: true
hideInToc: true
---

<div class="flex items-center justify-center">
  <div class="flex flex-col items-end text-right">
    <h1 class="text-4xl font-extrabold text-gray-800 dark:text-white mb-2">Comment choisir sa base de données</h1>
    <h2 class="text-xl font-semibold text-gray-800 dark:text-gray-300">
      Besoins, performances & scalabilité
    </h2>
    <span class="text-lg font-bold text-gray-700 dark:text-gray-400 mt-4">
      Hugues GAILLARD - Novembre 2025
    </span>
  </div>
  <div>
      <Compass />
  </div>
</div>
<!-- <div @click="$slidev.nav.next" class="mt-12 py-1" hover:bg="white op-10">
  Press Space for next page <carbon:arrow-right />
</div> -->

<!--
The last comment block of each slide will be treated as slide notes. It will be visible and editable in Presenter Mode along with the slide. [Read more in the docs](https://sli.dev/guide/syntax.html#notes)
-->

---
layout: two-cols
layoutClass: gap-16
hideInToc: true
---

# Au sommaire

Dans cette Masterclass, nous allons explorer les différentes bases de données et leurs spécificités.

<div style="margin: auto; width: 250px;">
  <Compass />
</div>

À la fin de cette heure, vous aurez une culture & une grille de lecture claire pour faire des choix éclairés et justifiés.

::right::

<Toc text-sm minDepth="1" maxDepth="2" />

---
---
# Un peu d'histoire

<style scoped>
.progress-bar {
  position: absolute;
  top: 2.8rem;
  left: 6rem;
  right: 6rem;
  height: 6px;
  z-index: 0;
}

.progress-bar::before {
  content: '';
  position: absolute;
  top: 0;
  left: 0;
  height: 100%;
  background: linear-gradient(to right, var(--soma-pink), var(--soma-blue));
  width: 0%;
  transition: width 0.5s ease-out;
  box-shadow: 0 0 28px rgba(129, 129, 129, 0.67);
}

.progress-bar.step-1::before { width: 0%; }
.progress-bar.step-2::before { width: 0%; }
.progress-bar.step-3::before { width: 20%; }
.progress-bar.step-4::before { width: 40%; }
.progress-bar.step-5::before { width: 60%; }
.progress-bar.step-6::before { width: 80%; }
.progress-bar.step-7::before { width: 100%; }

/* Custom v-click transition with fade and slide-up effect */
.slidev-vclick-target {
  transition: opacity 0.5s ease-out, transform 0.5s ease-out;
}

.slidev-vclick-hidden {
  opacity: 0;
  transform: translateY(20px);
}
</style>

<div class="flex items-start justify-between gap-4 relative pt-12 pb-8 px-8">
  <!-- Continuous horizontal gradient bar -->
  <div
    class="progress-bar"
    :class="{
      'step-1': $clicks === 0,
      'step-2': $clicks === 1,
      'step-3': $clicks === 2,
      'step-4': $clicks === 3,
      'step-5': $clicks === 4,
      'step-6': $clicks === 5,
      'step-7': $clicks >= 6,
    }"
  ></div>

  <!-- Event 1 -->
  <div v-click class="flex flex-col items-center flex-1 z-10">
    <div class="w-6 h-6 rounded-full bg-white border-4 border-[var(--soma-blue)] dark:border-gray-800 shadow-lg -mt-3"></div>
    <div class="mt-4 font-bold text-lg">1964</div>
    <div class="mt-2 text-sm text-gray-700 dark:text-gray-300 text-center px-2">Apparition du terme "data base" dans l'US Navy/DARPA</div>
    <div class="mt-3 w-24 h-24 bg-gray-200 dark:bg-gray-700 rounded"></div>
  </div>

  <!-- Event 2 -->
  <div v-click class="flex flex-col items-center flex-1 z-10">
    <div class="w-6 h-6 rounded-full bg-white border-4 border-[var(--soma-blue)] dark:border-gray-800 shadow-lg -mt-3"></div>
    <div class="mt-4 font-bold text-lg">1970</div>
    <div class="mt-2 text-sm text-gray-700 dark:text-gray-300 text-center px-2">Modèle relationnel d'E. F. Codd (IBM), naissance du SQL</div>
    <div class="mt-3 w-24 h-24 bg-gray-200 dark:bg-gray-700 rounded"></div>
  </div>

  <!-- Event 3 -->
  <div v-click class="flex flex-col items-center flex-1 z-10">
    <div class="w-6 h-6 rounded-full bg-white border-4 border-[var(--soma-blue)] dark:border-gray-800 shadow-lg -mt-3"></div>
    <div class="mt-4 font-bold text-lg">1972</div>
    <div class="mt-2 text-sm text-gray-700 dark:text-gray-300 text-center px-2">B-tree (Rudolf Bayer) chez Boing</div>
    <div class="mt-3 w-24 h-24 bg-gray-200 dark:bg-gray-700 rounded"></div>
  </div>

  <!-- Event 4 -->
  <div v-click class="flex flex-col items-center flex-1 z-10">
    <div class="w-6 h-6 rounded-full bg-white border-4 border-[var(--soma-blue)] dark:border-gray-800 shadow-lg -mt-3"></div>
    <div class="mt-4 font-bold text-lg">1977</div>
    <div class="mt-2 text-sm text-gray-700 dark:text-gray-300 text-center px-2">Naissance d'Oracle</div>
    <div class="mt-3 w-24 h-24 bg-gray-200 dark:bg-gray-700 rounded"></div>
  </div>

  <!-- Event 5 -->
  <div v-click class="flex flex-col items-center flex-1 z-10">
    <div class="w-6 h-6 rounded-full bg-white border-4 border-[var(--soma-blue)] dark:border-gray-800 shadow-lg -mt-3"></div>
    <div class="mt-4 font-bold text-lg">1998</div>
    <div class="mt-2 text-sm text-gray-700 dark:text-gray-300 text-center px-2">Apparition du terme NoSQL</div>
    <div class="mt-3 w-24 h-24 bg-gray-200 dark:bg-gray-700 rounded"></div>
  </div>

  <!-- Event 6 -->
  <div v-click class="flex flex-col items-center flex-1 z-10">
    <div class="w-6 h-6 rounded-full bg-white border-4 border-[var(--soma-blue)] dark:border-gray-800 shadow-lg -mt-3"></div>
    <div class="mt-4 font-bold text-lg">2012</div>
    <div class="mt-2 text-sm text-gray-700 dark:text-gray-300 text-center px-2">Création de Snowflake</div>
    <div class="mt-3 w-24 h-24 bg-gray-200 dark:bg-gray-800 rounded"></div>
  </div>
</div>

---
layout: quote
---
# Law of the instrument

<div class="flex items-center justify-between gap-8 h-[400px]">
  <div class="flex-1 p-6 text-left flex flex-col justify-center">
    <blockquote class="italic text-gray-700 dark:text-gray-200 mb-4">
      <span class="text-2xl">
        “It is tempting, if the only tool you have is a hammer, to treat everything as if it were a nail.”
      </span>
    </blockquote>
    <div class="text-right text-lg text-gray-500 dark:text-gray-400">
      Abraham Maslow, 1966<br>
      <span class="text-base">Law of the instrument</span>
    </div>
  </div>
  <div class="flex-1 flex justify-center items-center">
    <img
      src="/abraham-maslow-jeune.jpg"
      alt="Abraham Maslow"
      class="rounded-lg object-cover shadow-lg dark:shadow-gray-900"
    />
  </div>
</div>


---

# La jungle des bases de données


<Databases />
<p v-click>
</p>
<p v-click>
</p>
<p v-click>
</p>
<p v-click>
</p>

<!--
You can have `style` tag in markdown to override the style for the current page.
Learn more: https://sli.dev/features/slide-scope-style
-->

<!--
Here is another comment.
-->
---
---
# La base de données parfaite ?

<div class="flex flex-col gap-1 items-start text-left text-lg">

<span v-mark.underline.blue v-click="1">- Pour le DBA :</span><span v-click="2"> facile à installer, évolutive, bien documentée...</span>

<span v-mark.underline.blue="3" v-click="3">- Pour les utilisateurs :</span><span v-click="4"> simple à requêter, fiable, rapide...</span>

<span v-mark.underline.blue="5" v-click="5">- Pour la sécurité :</span><span v-click="6"> certifiée, résiliente, chiffrée...</span>

<span v-mark.underline.blue="7" v-click="7">- Pour la direction :</span> <span v-click="8"> économique, supportée, pérenne...</span>

</div>

<div class="mt-8 text-xl font-bold text-center">
<span v-click="9">Est-ce que cette base de données existe ? </span>
<span v-mark.red="10" v-click="10">Non.</span>
</div>

<div class="mt-4 text-lg text-center">
<span v-click="11">Il faut nécessairement faire des </span><span v-mark.box.orange="12" v-click="12">compromis.</span><br>
<span v-click="13">Et pour choisir les bons compromis, il faut d'abord bien comprendre les </span><span v-mark.box.blue="14" v-click="14">besoins.</span>
</div>

---
layout: center
---

# La nature de la charge de travail
# (workload)

---
---

# OLTP


L'OLTP (Online Transaction Processing) est conçu pour gérer des transactions en temps réel. Il se concentre sur l'exécution rapide de requêtes courtes et fréquentes, typiquement utilisées dans les applications opérationnelles.

Exemple : Un système de réservation de billets d'avion où les utilisateurs effectuent des recherches, réservent des sièges et effectuent des paiements. Chaque action génère une transaction qui doit être traitée rapidement et de manière fiable.

<!--
Notes can also sync with clicks

[click] This will be highlighted after the first click

[click] Highlighted with `count = ref(0)`

[click:3] Last click (skip two clicks)
-->

---

# OLAP

Parler d'OLAP + exemple
Dire que pour soulager les bases OLTP, on va se tourner vers des bases OLAP pour faire de l'analytique --> data warehouse, data lakehouse...

---
title: OLTP vs OLAP - Comparaison Technique
---

# OLTP vs OLAP - Comparaison Technique

| Caractéristique Technique | **OLTP (Transactionnel)** | **OLAP (Analytique)** |
| :--- | :---: | :---: |
| **Objectif Principal** | Enregistrement des transactions | Analyse et aide à la décision |
| **Stockage Physique** | Orienté **Ligne** (Row-Store) | Orienté **Colonne** (Column-Store) |
| **Optimisation I/O** | Écritures et lectures de lignes complètes | Lectures de colonnes spécifiques |
| **Modèle de Données** | **Normalisé** (ex: 3NF) | **Dénormalisé** (ex: Schéma en étoile) |
| **Type de Requêtes** | Simples (INSERT, UPDATE, DELETE, SELECT...) | Complexes (Agrégations, SUM, AVG, GROUP BY) |


---

# Vers l'unification des technos transactionnelles et analytiques

On le voit avec les rachats de Neon (par Databricks) et Crunchy Data (par Snowflake), les 2 solutions permettent de déployer facilement des bases PostgreSQL. Donc on pourra faire du transactionnel en plus de l’analytique avec Databricks et Snowflake.


---

# Les autres grandes familles de bases de données

Les NoSQL:
- Document, Clé-Valeur, orienté Colonne, Graphe
- Vectoriel, Hybride / NewSQL


---

# Note sur la scalabilité

- Scalabilité verticale vs horizontale
- Partitionnement (sharding) vs Réplication
- Considérations pratiques : Coût, complexité, latence réseau
- Théorème CAP
- Choix pragmatique selon les besoins réels (ex: une seule instance suffit souvent au début, eg Reddit)

---

# Comment benchmarker une base de données ?

- Les critères CAP-EV
- Scénarios d'usage concrets
- Latence (p95, p99), Débit (TPS, QPS)
- Coût (infrastructure, licences, maintenance)
- Comprendre les limites de son approche <!-- Peut etre que scenario avec 1 seule instance fonctionne pour A mais scalabilité mal implémentée donc scale moins bien... -->

---
# Etude de cas :


---

# Composer avec plusieurs bases de données

---

# Dette technique

  - Définition : Coût de la maintenance et de l'évolution d'un système
  - Origine : Choix technologiques, dettes accumulées, manque de documentation
  - Impact : Ralentissement des développements, augmentation des coûts


---

# Le mot de la fin

---
layout: center
---

# Q & A

---

# Ressources

- [clickhouse.com: Postgres to ClickHouse: Data Modeling Tips](https://clickhouse.com/blog/postgres-to-clickhouse-data-modeling-tips-v2)
- [developpez.com: La généalogie des SGBD](https://fadace.developpez.com/sgbdcmp/story/)
- [wikipedia.org: CAP Theorem](https://en.wikipedia.org/wiki/CAP_theorem)

---

# Merci pour votre attention !


---
src: ./pages/imported-slides.md
hide: false
---


---
---

# Plan

Partie 1 : Les Fondations : OLTP vs. OLAP, le clivage fondamental (10 minutes)
Slide 4 : Le premier filtre : Pour quoi faire ? Opérationnel vs. Analytique

Introduction du concept : la nature de la charge de travail (workload) est le critère N°1.

Slide 5 : L'OLTP (Online Transaction Processing)

Analogie : Le caissier de supermarché.

Objectif : Faire tourner l'application au quotidien.

Caractéristiques : Requêtes courtes et rapides, écritures fréquentes, forte concurrence, faible latence, données très normalisées.

Exemples de requêtes : INSERT INTO users..., UPDATE products SET stock = stock - 1...

Cas d'usage : Panier d'un site e-commerce, inscription utilisateur, transaction bancaire.

Slide 6 : L'OLAP (Online Analytical Processing)

Analogie : Le contrôleur de gestion qui analyse les ventes du trimestre.

Objectif : Aider à la prise de décision (Business Intelligence).

Caractéristiques : Requêtes longues et complexes, lectures massives, agrégations, données historiques dénormalisées (schéma en étoile).

Exemples de requêtes : SELECT SUM(sales), category FROM facts_sales GROUP BY category...

Cas d'usage : Dashboard de ventes, prévision de la demande, analyse de logs.

Slide 7 : Tableau récapitulatif OLTP vs. OLAP

Un tableau simple comparant les deux sur des axes clés : Type de requête, Volume par requête, Fréquence, Orientation (Ligne vs. Colonne), Objectif.

Partie 2 : Le Panorama : Les grandes familles de bases de données (15 minutes)
Slide 8 : Introduction aux familles

"Il n'y a pas de 'meilleure' base de données, seulement le meilleur outil pour un problème donné."

Slide 9 : 1. Le Relationnel (SQL)

Concept : Le standard historique. Schéma strict, tables, jointures, transactions ACID.

Idéal pour : Les données structurées avec des relations complexes et un besoin de forte cohérence.

Exemples : PostgreSQL, MySQL, SQL Server.

Slide 10 : 2. Le NoSQL : Un monde de possibilités

Introduction au mouvement NoSQL : flexibilité, scalabilité horizontale.

a) Document : (MongoDB)

Concept : Stocke des "documents" (JSON, BSON). Schéma flexible.

Idéal pour : Contenu web, catalogues produits, applications aux exigences évolutives.

b) Clé-Valeur : (Redis)

Concept : Le plus simple. Un dictionnaire géant. GET(key) -> value.

Idéal pour : Cache, gestion de sessions, files d'attente. Performance brute.

Slide 11 : Le NoSQL (suite)

c) Orienté Colonne : (Cassandra, Bigtable)

Concept : Stocke les données par colonne, pas par ligne. Très efficace pour les agrégations sur un sous-ensemble de colonnes. (Lien direct avec l'OLAP).

Idéal pour : Séries temporelles, IoT, analytique à grande échelle.

d) Graphe : (Neo4j)

Concept : Optimisé pour stocker et requêter les relations entre les données (nœuds et arêtes).

Idéal pour : Réseaux sociaux, détection de fraude, moteurs de recommandation.

Slide 12 : 3. Les nouvelles frontières

a) Vectoriel : (Pinecone, Weaviate, pg_vector)

Concept : Spécialisé dans le stockage et la recherche de vecteurs (embeddings). Le cerveau des IA modernes.

Idéal pour : Recherche sémantique, recherche par image, systèmes de recommandation basés sur l'IA.

b) Hybride / NewSQL : (CockroachDB, TiDB)

Concept : Le meilleur des deux mondes ? Interface SQL, transactions ACID, mais avec la scalabilité horizontale du NoSQL.

Idéal pour : Applications globales critiques nécessitant à la fois cohérence et scalabilité massive.

Partie 3 : La Boussole : Les 5 critères pour ne plus se tromper (10 minutes)
Slide 13 : Le framework "CAP-EV"

Une grille d'analyse simple pour guider le choix.

Slide 14 : C - Consistance (Modèle de données et garanties)

ACID vs. BASE. Avez-vous besoin d'une cohérence transactionnelle forte (banque) ou d'une cohérence à terme (like sur un post) ?

Quelle est la structure de vos données ? Fixe ou évolutive ?

Slide 15 : A - "Access Patterns" (Modèle de requêtage)

Comment allez-vous lire et écrire la donnée ? Requêtes simples par ID ? Jointures complexes ? Agrégations ? Traversée de graphe ? Recherche full-text ?

C'est le critère le plus souvent sous-estimé.

Slide 16 : P - Performance & Scalabilité

Besoins en latence et débit (reads/sec, writes/sec).

Scalabilité verticale ("scale-up" : une plus grosse machine) ou horizontale ("scale-out" : plus de machines) ?

Slide 17 : E - Ecosystème & Expertise

Le facteur humain : Quelles sont les compétences de votre équipe ?

Maturité de la technologie, support de la communauté, bibliothèques disponibles, outillage (monitoring, backup...).

Slide 18 : V - Volume & Vélocité

Quelle quantité de données aujourd'hui ? Et dans 5 ans ? (Go, To, Po...).

À quelle vitesse les données arrivent-elles ? (Batch vs. Streaming).

Partie 4 : Le Crash Test : 3 bases, 3 usages (15 minutes)
Slide 19 : Scénario 1 : Le cœur d'une application SaaS (OLTP)

Besoin : Gérer les utilisateurs, les abonnements, la facturation. Forte cohérence requise.

Benchmark : PostgreSQL

Pourquoi ?

Consistance : ACID est non-négociable.

Access Pattern : Requêtes relationnelles complexes (jointures entre clients, factures, plans).

Ecosystème : Le plus riche de tous les SGBD open source. Fiable, robuste, des extensions pour tout (PostGIS, pg_vector, TimescaleDB...). C'est le "couteau suisse" par défaut.

Slide 20 : Scénario 2 : Un dashboard analytique interactif (OLAP)

Besoin : Analyser des millions de logs de vente pour un dashboard interne. Vitesse d'analyse primordiale.

Benchmark : DuckDB vs. Snowflake

DuckDB :

Le "SQLite de l'analytique". Base de données en "in-process".

Force : Zéro administration, incroyablement rapide pour des analyses sur un seul nœud (PC, petit serveur). Parfait pour l'exploration de données en local, l'analytique embarquée.

Snowflake :

Le Data Warehouse Cloud natif.

Force : Séparation du stockage et du calcul, scalabilité quasi infinie, modèle de paiement à l'usage. Idéal pour les entrepôts de données d'entreprise, les équipes multiples.

Verdict : DuckDB pour le prototypage et l'analytique "embarquée". Snowflake pour la plateforme BI d'entreprise.

Slide 21 : Scénario 3 : Moteur de recherche sémantique pour une IA

Besoin : Permettre aux utilisateurs de rechercher des produits par des descriptions en langage naturel ("une robe rouge pour l'été").

Benchmark : PostgreSQL + pg_vector

Pourquoi ?

Access Pattern : C'est un cas d'usage de recherche vectorielle (ANN - Approximate Nearest Neighbor).

Le choix pragmatique : pg_vector est une extension qui transforme PostgreSQL en une base vectorielle "suffisamment bonne".

Avantages : Pas besoin de gérer une nouvelle infrastructure. On combine les données transactionnelles (prix, stock) et les vecteurs dans la même base. Idéal pour démarrer.

Alternative (mention) : Une base spécialisée (Pinecone, Weaviate) devient pertinente à très grande échelle, quand la recherche vectorielle est LE cœur du produit.

Conclusion (5 minutes)
Slide 22 : Synthèse des points clés

OLTP vs. OLAP : C'est toujours la première question à se poser.

Connaissez vos requêtes : L' "Access Pattern" dicte la famille de BDD.

Soyez pragmatique : Commencez simple. Un outil polyvalent comme PostgreSQL couvre 80% des besoins. N'ajoutez de la complexité (et une nouvelle BDD) que lorsque c'est absolument nécessaire et justifié.

Slide 23 : Le mot de la fin

"Ne choisissez pas une base de données sur un coup de tête ou pour suivre une mode. Analysez, testez, et choisissez l'outil qui résout votre problème, pas celui qui en crée de nouveaux."

Remerciements et lien vers les slides/ressources.

Slide 24 : Q&A

Une slide simple avec vos coordonnées (Twitter/LinkedIn/GitHub) pour les questions.



Theoreme CAP
ACID vs BASE
B-Tree/B+ Tree Indexing
Query Optimizer